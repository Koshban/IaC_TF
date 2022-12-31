resource "aws_instance" "kaushikb_ws" {
    ami             = "ami-02045ebddb047018b"  # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-12-01
    # If Deafult workspace create t2.medium size else t2.micro size instance
    instance_type   = terraform.workspace == "default" ? "t2.medium" : "t2.micro" 
    
    tags = {
        Name = "KaushikTerraFormExample_ws"  # EC2 Instance Name
    }
}