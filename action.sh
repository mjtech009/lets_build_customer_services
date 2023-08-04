#!/bin/bash -ex

# Function to apply Terraform configuration
terraform init -upgrade
terraform apply --auto-approve