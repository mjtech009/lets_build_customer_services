#!/bin/bash -ex
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
log_file="terraform_$timestamp.txt"
exec &> "$log_file"
# Function to apply Terraform configuration
terraform init -upgrade
terraform apply --auto-approve