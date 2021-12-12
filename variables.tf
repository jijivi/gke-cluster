variable "project" {
  description = "project id"
}

variable "credentials_file" {
  description = "GCP creds"
}

variable "region" {
  default     = "us-central1"
  description = "region"
}

variable "zone" {
  default     = "us-central1-c"
  description = "zone"
}


variable "name" {
  default = "dev"
}


variable "location" {
  default = "us-central1-c"
}

variable "initial_node_count" {
  default = 2
}

variable "machine_type" {
  default = "n1-standard-1"
}
