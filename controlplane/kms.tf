resource "google_kms_key_ring" "key_ring" {
   name     = "vault-unseal-kr"
   location = "global"
}

resource "google_kms_crypto_key" "crypto_key" {
   name            = "vault-unseal-key"
   key_ring        = google_kms_key_ring.key_ring.self_link
   rotation_period = "100000s"
}

resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
   key_ring_id = google_kms_key_ring.key_ring.id
   role = "roles/owner"

   members = [
     "serviceAccount:${var.service_account}",
   ]
}