# DEclare Variables to use as Input at various places or can be declared in .env or used in parameters while calling tf apply
variable "server_port" {
    description = "Port number for the HTTP requests"
    type        = number
    default     = 8080
}

variable "alb_sg_port" {
    description = "Port number for the HTTP requests"
    type        = number
    default     = 80
}