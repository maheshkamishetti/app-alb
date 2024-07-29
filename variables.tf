variable "common_tags" {
  default = {
    Project     = "live"
    Environment = "dev"
    Terraform   = "true"
  }
}

variable "tags" {
  default = {
    Component = "app-alb"
  }
}

variable "project_name" {
  default = "live"
}
variable "environment" {
  default = "dev"
}

