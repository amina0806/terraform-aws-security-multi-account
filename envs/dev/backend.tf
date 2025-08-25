terraform {
  backend "s3" {
    bucket         = "amina-tf-state-us-east-1-20250824"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:us-east-1:958006149724:key/9c247944-3792-405b-b326-ca17ee8aea8a"
  }
}
