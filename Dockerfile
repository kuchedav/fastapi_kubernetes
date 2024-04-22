FROM python:3.11.4

RUN mkdir /app
WORKDIR /app

COPY . .
RUN python -m pip install pip setuptools build . --upgrade

EXPOSE 8000

WORKDIR /app/src/fastapi_kubernetes/
# ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
