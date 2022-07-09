terraform {
  backend "s3" {
    bucket = "saftronbucket"
    key    = "foo//terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "state-lock"
  }
}