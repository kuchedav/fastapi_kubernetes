# fastapi_kubernetes

A short description of the project.

# Get Minikube running

To run the code on minikube (like me) you have to follow these steps:

1. > minikube start
2. > minikube addons enable ingress
3. > minikube tunnel

# Connect from Safari

Check the port on your ingress
> kg ingress

enter following link in your browser
in my case it was port 80
> localhost:<port_number>