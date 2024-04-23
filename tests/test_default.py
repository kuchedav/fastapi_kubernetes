import pytest
from daves_utilities.david_secrets import get_credentials
from fastapi.testclient import TestClient

from fastapi_kubernetes.main import app


@pytest.fixture(scope="module")
def client():
    return TestClient(app)


def test_api_output(client):
    crd = get_credentials("fastapi")
    response = client.get("/", auth=(crd["usr"], crd["pwd"]))
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}


if __name__ == "__main__":
    ...
    test_api_output(client())
