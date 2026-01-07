SEAL_KEYS_DIR := ".seals"

fetch-key env:
    @mkdir -p {{ SEAL_KEYS_DIR }}
    @echo "Syncing {{ env }} key"
    kubeseal --fetch-cert --context mimosa-{{ env }} > {{ SEAL_KEYS_DIR }}/{{ env }}.pem
    @echo "Cluster public key fetched: {{ SEAL_KEYS_DIR }}/{{ env }}.pem"

# just seal-secret pocketid tst db-secrets "user=admin" "pass=123"
seal-secret app env secret_name *args:
    @if [ ! -f {{ SEAL_KEYS_DIR }}/{{ env }}.pem ]; then \
        echo "Error: Public key for {{ env }} not found. Run 'just fetch-key {{ env }}' first."; \
        exit 1; \
    fi
    @mkdir -p apps/{{ app }}/overlays/{{ env }}
    @echo "Encrypting for {{ env }} (Namespace: {{ app }})..."

    kubectl create secret generic {{ secret_name }} \
        -n {{ app }} \
        $(for pair in {{ args }}; do printf -- "--from-literal=%s " "$pair"; done) \
        --dry-run=client -o yaml | \
    kubeseal --cert {{ SEAL_KEYS_DIR }}/{{ env }}.pem --format yaml > \
        apps/{{ app }}/overlays/{{ env }}/{{ secret_name }}.yaml

traefik-dashboard:
    kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name -n traefik) 8080:8080 -n traefik

k8s-dashboard:
    kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443

generate-k8s-dashboard-token:
    kubectl create token lyra -n kubernetes-dashboard | pbcopy
