FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY . .

CMD [ "-m", "unittest", "test/unit_test.py" ]
ENTRYPOINT [ "python" ]



