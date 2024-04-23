# Manual command for Kubernetes

---
## Create the david_secret on kubernetes

```bash
kubectl create secret generic david-secret --from-literal=david_secret='<david_secret_stored_in_bitwarden>'
```
