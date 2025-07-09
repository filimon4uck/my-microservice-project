FROM python:3.13-slim

RUN mkdir /project

WORKDIR /project

COPY requirements.txt /project/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /project/requirements.txt

COPY . /project

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
