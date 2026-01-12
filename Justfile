# just seal-secret pocketid tst db-secrets "user=admin" "pass=123"
seal-secret platform app secret_name *args:
    @echo "Encrypting secrets for {{ app }}..."

    kubectl create secret generic {{ secret_name }} \
        -n {{ app }} \
        $(for pair in {{ args }}; do printf -- "--from-literal=%s " "$pair"; done) \
        --dry-run=client -o yaml | \
    kubeseal --format yaml > \
        kubernetes/{{ platform }}/{{ app }}/{{ secret_name }}.yaml
