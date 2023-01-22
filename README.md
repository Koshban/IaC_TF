AWS Terraform Template

Basic Info : Using Terraform for Creating ( on AWS ) a near real life project with Compute, Keys Management, Auto Scaling and Load Balancers,
storing state in Backend ( S3 ), segregating staging and Prod Infra management through Modules , Autromated Testing etc.
Also includes multi region, multi account providers.
    
Deploying a sample cluster of static webservers saying "Hello World, Here I come!!".
Access the Webserver using the DNS of the ALB e.g. curl http://<alb_dns_name>

Requirements : You will need to download Terraform. Ensure you have AWS account with Entitlements of "AdministratorAccess ".
Also ensure your iAM Role has security credentrials with Access Key ID and Secret Access Key.
You can use those on .env file, or export ( using Linux ) or set ( using Windows ) on cmd line. 

Best option is to use them in your $HOME/.aws/ files.

Contact Info : Feel free to contact me to discuss any issues, questions, or comments. My contact info can be found on my GitHub page.

License : I am providing code and resources in this repository to you under an open source license. Because this is my personal repository, the license you receive to my code and resources is from me and not my employer (JP Morgan Asset Management Asia Ltd).

Copyright : Copyright 2022 Kaushik Banerjee

Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)

https://creativecommons.org/licenses/by-sa/4.0/
