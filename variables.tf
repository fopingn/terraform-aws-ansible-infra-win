# --- root/variables ----
variable "aws_region" {
  default = "us-east-1"
}

variable "access_ip" {
  description = "The IP address to access your infrastrucuture"
  default     = ""
}

variable "key_name" {
  description = "The AWS key pair to use for resources. This have to be change to match your own key"
  default     = "name_key"
}
variable "windows_user" {

}
variable "windows_password" {

}

