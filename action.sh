#!/bin/bash -ex
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
log_file="terraform_$timestamp.txt"
exec &> "$log_file"
# Function to apply Terraform configuration
apply_terraform() {
    local tf_dir="$1"

    if [ -z "$tf_dir" ]; then
        echo "Usage: apply_terraform /root/lets-build-engine-infra"
        return 1
    fi

    if [ ! -d "$tf_dir" ]; then
        echo "Error: Directory '$tf_dir' not found."
        return 1
    fi

    # Change to the Terraform directory
    cd "$tf_dir" || return 1

    # Initialize Terraform
    terraform init -upgrade
    if [ $? -ne 0 ]; then
        echo "Error: Terraform initialization failed."
        return 1
    fi

    # Apply Terraform changes
    terraform apply --auto-approve
    if [ $? -ne 0 ]; then
        echo "Error: Terraform apply failed."
        return 1
    fi

    echo "Terraform apply completed successfully."
}

# Call the function with the path to your Terraform directory
apply_terraform "/root/lets-build-engine-infra"
