data "terraform_remote_state" "level1" {
  backend = "s3"

  config = {
    bucket = "vlad-tfstate"
    key    = "level1.tfstate"
    region = "us-east-1"
  }
}