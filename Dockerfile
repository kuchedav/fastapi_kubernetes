FROM python:3.8

RUN mkdir /app
WORKDIR /app/

COPY src/fastapi_kubernetes/. .
RUN python -m pip install -r requirements.txt

ENTRYPOINT ["python", "-m", "uvicorn", "main:app"]
