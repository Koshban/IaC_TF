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

variable "cluster_name" {
    description = "Cluster Resources Name"
    type        = string
}

variable "db_remote_state_bucket" {
    description = "The name of the S3 bucket for the database's remote state"
    type          = string  
}

variable "db_remote_state_key" {
    description = "The path for the database's remote state in S3"
    type          = string  
}

variable "instance_type" {
    description = "The type of EC2 Instances to run (e.g. t2.micro)"
    type        = string  
}

variable "min_size" {
    description = "The minimum number of EC2 Instances in the ASG"
    type        = number  
}

variable "max_size" {
    description = "The maximum number of EC2 Instances in the ASG"
    type        = number  
}

variable "custom_tags" {
    description = "Custom tags to set on the Instances in the ASG"
    type        = map(string)
    default     = {}  
}

variable "enable_autoscaling" {
    description = "If set to true, enable auto scaling"
    type        = bool
    default     = false  
}

variable "ami" {
    description = "The AMI to run in the cluster"
    type        = string
    default     = "ami-02045ebddb047018b"  # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-12-01 
}

variable "server_text" {
    description = "The text the web server should return"
    type        = string
    default     = "Hello, World. Girdle Up. Here I come :)"  
}

