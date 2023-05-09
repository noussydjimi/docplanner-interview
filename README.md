# docplanner-interview
Technical test for docplanner



## Initialize terraform

- Create a s3 bucket and reference it in backend config file.
- Create an AWS profile from a user with ``` AdministratorAccess ``` policy attached.
- Create an aws profile with that user credential and reference it in the backend config file.
- Fill the ```terraform.tfvars ``` with the desired variables.


## Initialize terraform

> terraform init -var-file environments/prod/eu-north-1/terraform.tfvars -backend-config=environments/prod/eu-north-1/backend-config



## Apply terraform

> terraform apply -var-file environments/prod/eu-north-1/terraform.tfvars


## Update local kubeconfig
> aws eks update-kubeconfig --name ```{{ clustername }}``` --region ```{{ region }}``` --profile ```{{ aws_profile }}```

## Check applications logs
> kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter

> kubectl logs -f -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller


## Connect to rds instance
> aws ssm start-session --region ```{{ region }}``` --target ```{{ rds_bastion_instance_id }}```  --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters host=```{{ rds_endpoint }}```,portNumber="5432",localPortNumber="5432" --profile ```{{ aws_profile }}```

then
> psql -h 127.0.0.1 -p 5432 -U testuser -d interview

The pasword is display as an output.






#### INSTRUCTIONS

```DevOps Trial Task
Your task is to:
Setup EKS on AWS (Stockholm) using Terraform
make sure that egress traffic from the cluster is using just one IP address
prepare Terraform directory structure knowing that we gonna use multiple regions and 2 environments in each - production and testing
Dockerize provided applications ( https://github.com/DocPlanner/devops-sample-apps )
Expose applications from previous point on single load balancer so that they will be accessible on paths /api/v1/ and /api/v2/
Configure HPA for those two applications that you have dockerized
Setup RDS PostgreSQL/MySQL database using Terraform
Introduce a mechanism which will spawn a new node in a nodegroup when the cluster has insufficient resources
Think about how we can automate adding additional users (Developers) to databases

While planning your work, please keep in mind that the project will eventually grow in the future. This means (among others) that the Terraform codebase should be extensible and allow for easy collaboration and small changes in requirements should not introduce a need to redesign the whole system.

```
