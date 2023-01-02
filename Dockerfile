FROM python:3.8

RUN mkdir /app
WORKDIR /app/

COPY src/fastapi_kubernetes/. .

ENTRYPOINT ["tail", "-f", "/dev/null"]
