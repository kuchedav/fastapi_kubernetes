from locust import between
from locust import HttpUser
from locust import task


class WebsiteUser(HttpUser):
    wait_time = between(1, 2.5)

    @task(1)
    def index(self):
        self.client.get("/")
