variable "region" {
  default = "us-west-2"
}

variable "example" {
  default = {
    key1 = "looklokeghhh"
  }

  type = map
}

variable "key_name" {
  default = "KeyName"
}
