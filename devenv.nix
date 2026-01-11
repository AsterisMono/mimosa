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
}
