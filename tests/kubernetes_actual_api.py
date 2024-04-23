import pytest
import requests
from daves_utilities.david_secrets import get_credentials
from fastapi.testclient import TestClient


@pytest.fixture(scope="module")
def client():
    return TestClient("http://localhost:80")


def kubernetes_api_output(client):
    crd = get_credentials("fastapi")
    response = requests.get("http://localhost:8000/", auth=(crd["usr"], crd["pwd"]))
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}


if __name__ == "__main__":
    ...
    kubernetes_api_output(client())
