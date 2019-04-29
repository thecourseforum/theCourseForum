import pandas as pd
import numpy as np
import re
from tqdm import tqdm
import json
import sys

from validate_grades import validate_grade_files

def merge_grades(grade_dict):
    for fname, df in grade_dict.items():
        # add year and season columns
        year = re.search("\d{4}", fname).group(0)
        season = "Fall" if "Fall" in fname else "Spring"
        df['Year'] = year
        df['Season'] = season
    
    # merge all grades
    grades = pd.concat(list(grade_dict.values()))
    
    # convert integer columns to integers
    int_columns = [5,6,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]
    for col in int_columns:
        grades[grades.columns[col]] = grades[grades.columns[col]].fillna(value=0).astype(int)
    
    return grades

def grade_dist_dict(grade_df):
    # sum along all grade count columns ('A+', 'A', 'A-', ..., 'Total')
    return grade_df.iloc[:,list(range(9,26))].sum().to_dict()

def gpa_mean(grade_df):
    # Find mean GPA
    return round(grade_df['Course GPA'].mean(), 2)

def gpa_trends(grade_df):
    # Create a dict with keys of form 'Fall2018' and values of form '3.25'
    return {"{}{}".format(*sem): gpa for sem, gpa in grade_df.groupby(['Year', 'Season']).mean()['Course GPA'].to_dict().items()}

def grade_data_dict(grade_df):
    # piece together mean gpa, distribution, and 
    return {
        'gpa': gpa_mean(grade_df),
        'distribution': grade_dist_dict(grade_df),
        'trends': gpa_trends(grade_df)
    }

def department_gpas_dict(department_grades, subject):
    d = department_grades.loc[(department_grades.index.get_level_values('Course Subject') == subject)].to_dict()
    return {tup[1]: round(gpa, 2) for tup, gpa in d['Course GPA'].items()}

def professor_gpas_dict(course_data_professors):
    return { email.split("@")[0]: round(gpa,2) for email, gpa in course_data_professors.mean()['Course GPA'].to_dict().items()}

def grades_dict(grades_df):
    courses = grades_df.groupby(['Course Subject', 'Course Number'])
    grade_data = {}
    department_grades = courses.mean()['Course GPA'].to_frame()
    
    for course_key in tqdm(courses.groups.keys()):
        course_data = courses.get_group(course_key)
        subject, number = course_key      
        grade_data.setdefault(subject, {
            'course_gpas': department_gpas_dict(department_grades, subject)
        })
        grade_data[subject][number] = grade_data_dict(course_data)
        profs = course_data.groupby(['Instructor Email'])
        grade_data[subject][number]['professor_gpas'] = professor_gpas_dict(profs)
        
        
        for prof_key in profs.groups.keys():
            prof_data = profs.get_group(prof_key)
            comp_id = prof_key.split('@')[0]
            grade_data[subject][number].setdefault('professors', {})
            grade_data[subject][number]['professors'][comp_id] = grade_data_dict(prof_data)
            
    return grade_data

def update_grades(data_dir, fname):
    grade_dict = validate_grade_files(data_dir)
    grade_df = merge_grades(grade_dict)
    print("Building grades JSON...")
    grade_data = grades_dict(grade_df)

    try:
        f = open(fname, "w")
        f.write(json.dumps(grade_data))
        f.close()
    except:
        return False
    return True

if __name__ == "__main__":

    if len(sys.argv) < 3:
        print("Please specify a source directory and output file")
        exit(1)

    data_dir = sys.argv[1]
    fname = sys.argv[2]

    res = update_grades(data_dir, fname)

    if res:
        print("Grades updated and placed in {}.".format(fname))
        exit()
    else:
        print("Unable to update grades.")
        exit(1)