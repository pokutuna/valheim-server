variable "project" {
  type    = string
  default = "times-takuya-valheim"
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "zone" {
  type    = string
  default = "asia-northeast1-b"
}

# 費用
# https://cloud.google.com/compute/all-pricing?hl=ja
variable "instance_type" {
  type    = string
  default = "n1-standard-2"
}
