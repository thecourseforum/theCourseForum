import pandas as pd
import numpy as np
import os

def get_rename_dict(grade_dict):
    rename_dict = {}
    max_columns = max([len(grade_df.columns) for filename, grade_df in grade_dict.items()])
    for col in range(max_columns):
        colNames = set(df.columns[col] for fname, df in grade_dict.items())
        # print("{}: {}".format(col, colNames))
        colName = max(colNames, key=len)
        for name in colNames:
            if name != colName:
                rename_dict[name] = colName
    return rename_dict

def load_grade_file(fname):
    # read excel file to identify header_row
    df = pd.read_excel(fname)
    
    # isolate instructor last name column
    first_col = df.iloc[:, 0]
    
    # if first row is not "Instructor Last Name", set header_row to the row that contains it.
    # otherwise, use first row as header_row
    try:
        header_row = first_col[first_col == "Instructor Last Name"].index[0]
    except IndexError as e:
        header_row = 0
        
    # re-read excel file with correct header_row
    grades = pd.read_excel(fname, header=header_row)
    
    # drop all rows that only have NA values
    grades = grades.dropna(how='all')
    return grades

def clean_grades(grade_df):

    required_col_idxs = [3,4,5,8]
    required_col_names = [grade_df.columns[col] for col in required_col_idxs]
    
    # drop any rows that have NA values in course number or subject columns
    grade_df = grade_df.dropna(how='any', subset=required_col_names)
    
    # columns 9 through 24 are the grade counts (including DR and W)
    grade_col_idxs = [grade_df.columns[col] for col in range(9, 25)]

    # if grade_df does not have "Totals" column, add it
    # else, ensure that it is accurate
    grade_cols = grade_df[grade_col_idxs]
    if grade_df.shape[1] <= 25:
        grade_df['Total'] = grade_cols.sum(axis=1)
    else:
        grade_df[grade_df.columns[25]] = grade_cols.sum(axis=1)

    return grade_df

def load_grade_files(data_dir):
    grade_dict = {}
    # loop through all file names in data_dir
    for filename in os.listdir(data_dir):
        # don't read file if it is a temp excel swap file
        if filename.startswith("~"):
            continue
        print("Loading {}".format(filename))
        # construct file path for file
        file_path = os.path.join(data_dir, filename)
        # load excel file into dataframe
        grade_df = load_grade_file(file_path)
        # clean grade dataframe
        grade_df = clean_grades(grade_df)

        grade_dict[filename] = grade_df

    rename_dict = get_rename_dict(grade_dict)

    for fname in grade_dict:
        grade_dict[fname] = grade_dict[fname].rename(index=str, columns=rename_dict)

    return grade_dict

def numeric_conversion_errors(df, column_name):
    # create a temporary copy of the column
    column_copy = df[column_name].copy()
    # a list of error messages
    errors = []
    has_errors = True
    # loop while we encounter an error converting column_copy to numeric
    while has_errors:
        try:
            pd.to_numeric(column_copy)
        except Exception as e:
            # append error message
            errors.append("{}: {}".format(column_name, e))
            # find position of problematic value
            index = int(str(e).split()[-1])
            # replace with -1 to mark as "seen"
            column_copy.iloc[index] = -1
            continue
        # set has_errors to false if we don't encounter a problem during conversion
        has_errors = False
    return errors


def find_numeric_conversion_errors(df):
    # define columns that should be numeric
    numeric_columns = [5,6,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    errors = []
    # loop through numeric columns and find all errors
    for col in numeric_columns:
        column_name = df.columns[col]
        col_errors = numeric_conversion_errors(df, column_name)
        if col_errors:
            print("\t" + "\n\t".join(col_errors))
            errors.extend(col_errors)
    return errors
        
def validate_grade_dfs(grade_dict):
    for fname, grade_df in grade_dict.items():
        print("Validating {}".format(fname))
        errors = find_numeric_conversion_errors(grade_df)
        if len(errors) > 0:
            print(errors)

def validate_grade_files(data_dir):
    grade_dict = load_grade_files(data_dir)
    validate_grade_dfs(grade_dict)
    return grade_dict