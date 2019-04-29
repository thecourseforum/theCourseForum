from flask import Flask
import redis

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Flask Dockerized'

if __name__ == '__main__':
    app.run(debug=True,port='80',host='0.0.0.0')