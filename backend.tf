terraform {
    backend "s3" {

        bucket = "statefile-terraform"
        key    = "terraform.tfstate"
        region = "us-west-2"
    }
}
