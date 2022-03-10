provider "aws" {
  profile = "terraform_profile"
  region  = "eu-west-1"
}

provider "aws" {
  alias = "us-east"
  profile = "terraform_profile"
  region  = "us-east-1"
}
