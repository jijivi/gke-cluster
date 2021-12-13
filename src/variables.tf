variable "project" {
  description = "project id"
}

# variable "credentials_file" {
#   description = "GCP creds"
# }

variable "region" {
  default     = "us-west2"
  description = "region"
}

variable "zone" {
  default     = "us-west2-a"
  description = "zone"
}


variable "name" {
  default = "dev"
}


variable "location" {
  default = "us-west2-a"
}

variable "initial_node_count" {
  default = 1
}

variable "machine_type" {
  default = "n1-standard-1"
}
