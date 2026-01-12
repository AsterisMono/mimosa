{
  pkgs,
  ...
}:

{
  packages = with pkgs; [
    kubeseal
    kubectl
    kubeconform
    kustomize
    kubernetes-helm
    argocd
    terraform
    packer
    talosctl
    just
    jq
    cilium-cli
    _1password-cli
  ];

  env = {
    KUBECONFIG = "./.kube/kubeconfig";
    TALOSCONFIG = "./.kube/talosconfig";
    TF_VAR_hcloud_token = "op://Requiem.Garden/Hetzner.Token.API.RequiemGarden/credential";
    AWS_ACCESS_KEY_ID = "op://Requiem.Garden/Hetzner.Token.S3.MimosaTerraformState/username";
    AWS_SECRET_ACCESS_KEY = "op://Requiem.Garden/Hetzner.Token.S3.MimosaTerraformState/credential";
  };

  git-hooks.hooks.kubeconform = {
    enable = true;
    name = "kubeconform";
    files = "kubernetes/.*\.yaml";
    entry = "kubeconform -schema-location default -schema-location 'https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' -schema-location 'https://www.schemastore.org/kustomization.json' -strict";
  };
}
