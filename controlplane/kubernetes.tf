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
      "sed -i -e 's/GITHUB_TOKEN/${var.github_token}/g' /tmp/manifests/secrets.yaml",
      "sed -i -e 's/INGRESS_IP/${google_compute_global_address.cp_ingress_ip.address}/g' /tmp/manifests/nginx-ingress.yaml",
      "/snap/bin/kubectl apply -n argocd -f /tmp/manifests/",
      "/snap/bin/kubectl apply -n argocd -f /tmp/manifests/argocd-config.yaml",
    ]
  }
}