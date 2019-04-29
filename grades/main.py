from flask import Flask
import redis

app = Flask(__name__)

rds = redis.Redis(host='grades_db', port=6379, db=0)

@app.route('/')
def hello_world():
    return 'Flask Dockerized'

@app.route('/api/v1/course/<course_subject>/<int:course_number>/gpa')
def course_overall_gpa(course_subject, course_number):
	return "{} {}".format(course_subject, course_number)

@app.route('/api/v1/course/<course_subject>/<int:course_number>')
def course_overall(course_subject, course_number):
	return "{} {}".format(course_subject, course_number)

@app.route('/api/v1/course/<course_subject>/<int:course_number>/<prof_id>/gpa')
def course_prof_gpa(course_subject, course_number, prof_id):
	return "{} {} {}".format(course_subject, course_number, prof_id)

@app.route('/api/v1/course/<course_subject>/<int:course_number>/<prof_id>')
def course_prof(course_subject, course_number, prof_id):
	return "{} {} {}".format(course_subject, course_number, prof_id)

@app.route('/api/v1/course/<course_subject>/<int:course_number>/<prof_id>/<int:year>/<season>')
def course_prof_semester(course_subject, course_number, prof_id, year, season):
	return "{} {} {} {} {}".format(course_subject, course_number, prof_id, year, season)

if __name__ == '__main__':
    app.run(debug=True, port='80', host='0.0.0.0')