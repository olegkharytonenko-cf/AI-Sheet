provider "aws" {
  profile = var.profile
  alias = "ai-sheet"
  region  = data.aws_region.current.name
}

