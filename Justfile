# just seal-secret pocketid tst db-secrets "user=admin" "pass=123"
seal-secret app env secret_name *args:
    @mkdir -p apps/{{ app }}/overlays/{{ env }}
    @echo "Encrypting for {{ env }} (Namespace: {{ app }})..."

    kubectl create secret generic {{ secret_name }} \
        -n {{ app }} \
        $(for pair in {{ args }}; do printf -- "--from-literal=%s " "$pair"; done) \
        --dry-run=client -o yaml | \
    kubeseal --context mimosa-{{ env }} --format yaml > \
        apps/{{ app }}/overlays/{{ env }}/{{ secret_name }}.yaml

traefik-dashboard:
    kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name -n traefik) 8080:8080 -n traefik

k8s-dashboard:
    kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443

generate-k8s-dashboard-token:
    kubectl create token lyra -n kubernetes-dashboard | pbcopy
