# Kubectl Cheat Sheet

## Create the david_secret on kubernetes

```bash
kubectl create secret generic david-secret --from-literal=david_secret='<david_secret_stored_in_bitwarden>'
```

## Command alias
add following commands to {mac: ~/.bash_profile}

```bash
alias k="kubectl"
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias ke='kubectl exec -it'
```
