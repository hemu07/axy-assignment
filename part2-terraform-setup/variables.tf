variable "region" {
    default = "us-east-1"
}

variable "app_name" {
    default = "simple-fullstack-app"
}

variable "container_port" {
    default = 4000
}

variable "image" {
    description = "Docker image URI (ECR)"
}

