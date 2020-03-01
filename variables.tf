variable "public_key_path" {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}

variable "count_instance" {
  description = "Count of instance"
  default     = "1"
}

variable "image" {
  description = "Image of OS"
  default     = "Ubuntu-1804-LTS"
}

variable "project_a" {
  description = "Name of first google project"
}

variable "user" {
  description = "user for ssh access"
}

variable "credentials_file" {
  description = "file with system account credentials"
}
