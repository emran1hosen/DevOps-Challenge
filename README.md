#Instruction to run the project

*Prerequisites:

i. Install prerequisits wget, git, docker, docker-compose, terraform, aws cli.

ii. Clone this git repo https://github.com/111emran/devops-ipg

A. Build and run in local environment:

i. Go to project directory “DevOps_ST_IP”

ii. Run command: docker-compose up -d

B. Provision the infra with terraform:

i. Login to aws using AWS cli

ii. Run below commands:

terraform init

terraform plan

terraform apply -auto-approve



iii. After running the terraform successfully, wait a little while (5+ minutes). Because to up docker containers, to active LB, to add ec2 to TG, startup script to run.

iv. browse application using aws load balancer url
