# TODO: Consider using terraform provider
resource "null_resource" "setup_kubernetes" {
  triggers = {
    key = "${uuid()}"
  }
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = module.jumpbox.private_key
      host     = module.jumpbox.jumpbox_ip
    }
    source = "./manifests"
    destination = "/tmp"
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = module.jumpbox.private_key
      host     = module.jumpbox.jumpbox_ip
    }
    inline = [
      "sudo snap install kubectl --classic",
      "/snap/bin/gcloud config set account ${var.service_account}",
      "/snap/bin/gcloud container clusters get-credentials demo-cp --region asia-northeast1",
      "/snap/bin/kubectl create namespace argocd",
      "sed -i -e 's/GITHUB_TOKEN/${var.github_token}/g' /tmp/manifests/argocd-config.yaml",
      "/snap/bin/kubectl apply -n argocd -f /tmp/argocd.yaml -f /tmp/ingress.yaml",
    ]
  }
}