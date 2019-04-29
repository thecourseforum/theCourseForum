FROM tiangolo/uwsgi-nginx-flask:python3.6

WORKDIR /app

# Install any needed packages specified in requirements.txt
COPY ./requirements.txt /app
RUN pip install -r requirements.txt

COPY ./ /app

EXPOSE 5000

# CMD ["python", "main.py"]