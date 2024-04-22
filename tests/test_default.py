import pytest
from fastapi.testclient import TestClient

from fastapi_kubernetes.app import app


@pytest.fixture(scope="module")
def client():
    return TestClient(app)


def test_api_output(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}
