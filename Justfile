# just seal-secret pocketid tst db-secrets "user=admin" "pass=123"
seal-secret app env secret_name *args:
    @echo "Encrypting for {{ env }} (Namespace: {{ app }})..."

    kubectl create secret generic {{ secret_name }} \
        -n {{ app }} \
        $(for pair in {{ args }}; do printf -- "--from-literal=%s " "$pair"; done) \
        --dry-run=client -o yaml | \
    kubeseal --format yaml > \
        apps/{{ app }}/{{ secret_name }}.yaml
