traefik-dashboard:
    kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name -n traefik) 8080:8080 -n traefik

update-traefik:
    helm upgrade traefik traefik/traefik \
        --namespace traefik \
        --values ./traefik/values.yaml

restart-cert-manager:
    kubectl rollout restart deployment cert-manager -n cert-manager

k8s-dashboard:
    kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443

generate-k8s-dashboard-token:
    kubectl create token lyra -n kubernetes-dashboard
