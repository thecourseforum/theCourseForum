from flask import Flask, make_response, abort, jsonify
import redis

app = Flask(__name__)

rds = redis.Redis(host='grades_db', port=6379, db=0)


def json_resp(s):
	resp = make_response(s)
	resp.headers['content-type'] = 'application/json'
	return resp

COURSE_API_PREFIX = '/grades/api/v1'

@app.route('/')
def hello_world():
    return 'Flask Dockerized'

@app.route(COURSE_API_PREFIX + '/<subject>')
def department_gpas(subject):
	try:
		redis_resp = rds.execute_command(
			'JSON.GET', 'grades', "{}.course_gpas".format(subject))
	except redis.exceptions.ResponseError:
		# abort(404)
		return jsonify(None)
	return json_resp(redis_resp)

@app.route(COURSE_API_PREFIX + '/<subject>/all')
def department_data(subject):
	try:
		redis_resp = rds.execute_command(
			'JSON.GET', 'grades', "{}".format(subject))
	except redis.exceptions.ResponseError:
		# abort(404)
		return jsonify(None)
	return json_resp(redis_resp)


@app.route(COURSE_API_PREFIX + '/<subject>/<int:number>')
def course_gpas(subject, number):
	try:
		redis_resp = rds.execute_command(
			'JSON.GET', 'grades', "{}['{}'].professor_gpas".format(subject, number))
	except redis.exceptions.ResponseError:
		# abort(404)
		return jsonify(None)
	return json_resp(redis_resp)

@app.route(COURSE_API_PREFIX + '/<subject>/<int:number>/all')
def course_data(subject, number):
	try:
		redis_resp = rds.execute_command(
			'JSON.GET', 'grades', "{}['{}']".format(subject, number))
	except redis.exceptions.ResponseError:
		# abort(404)
		return jsonify(None)
	return json_resp(redis_resp)

@app.route(COURSE_API_PREFIX + '/<subject>/<int:number>/gpa')
def course_gpa(subject, number):
	try:
		redis_resp = rds.execute_command(
			'JSON.GET', 'grades', "{}['{}'].gpa".format(subject, number))
	except redis.exceptions.ResponseError:
		# abort(404)
		return jsonify(None)
	return json_resp(redis_resp)


@app.route(COURSE_API_PREFIX + '/<subject>/<int:number>/<prof_id>')
def professor_data(subject, number, prof_id):
	try:
		redis_resp = rds.execute_command(
			'JSON.GET', 'grades', "{}['{}'].professors['{}']".format(subject, number, prof_id))
	except redis.exceptions.ResponseError:
		# abort(404)
		return jsonify(None)
	return json_resp(redis_resp)

if __name__ == '__main__':
    app.run(debug=True, port='80', host='0.0.0.0')