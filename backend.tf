terraform {
    backend "s3" {

        bucket = "khaled-terraform"
        key    = "terraform.tfstate"
        region = "us-west-2"
    }
}