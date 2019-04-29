import pandas as pd
import numpy as np
import os
import redis

r = redis.Redis(host='grades_db', port=6379, db=0)

# TODO: port stuff frmo ./data/Grades.ipynb and load into redis