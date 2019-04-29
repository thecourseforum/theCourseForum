import redis
import sys

def load_grades(fname, rds):
    f = open(fname, 'r')
    grade_json = f.read()
    load_status = rds.execute_command('JSON.SET', 'grades', '.', grade_json)
    if not load_status == b'OK':
        return False
    return True



if __name__ == "__main__":
    rds = redis.StrictRedis(host='grades_db', port=6379, db=0)
    if len(sys.argv) < 2:
        print("Please specify a .json file")
        exit()
    fname = sys.argv[1]
    res = load_grades(fname, rds)
    if res:
        print("Grades loaded.")
        exit()
    else:
        print("Unable to load grades.")
        exit(1)