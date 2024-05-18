terraform {
  required_version = "~>1.7"
  backend "s3" {
    bucket         = "ai-sheet-us-east-1-tf-state"
    region         = "us-east-1"
    key            = "ai-sheet-region-setup.tfstate"
    dynamodb_table = "ai-sheet-us-east-1-state-lock"
    encrypt        = true
  }
#  backend "local" {
#   }
}