#!/usr/bin/env bash
set -euo pipefail

[ -z "$ARM_SUBSCRIPTION_ID" ] && ARM_SUBSCRIPTION_ID=az account show -o tsv --query "id"
[ -z "$ARM_TENANT_ID" ] && ARM_TENANT_ID=az account show -o tsv --query "tenantId"
[ -z "$STATE_RESOURCE_GROUP_NAME" ] && STATE_CONTAINER_NAME="terraform-states"
[ -z "$STATE_CONTAINER_NAME" ] && STATE_CONTAINER_NAME="states"
[ -z "$STATE_SUBSCRIPTION_ID" ] && STATE_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID
[ -z "$STATE_TENANT_ID" ] && STATE_SUBSCRIPTION_ID=$ARM_TENANT_ID

[ -z "$TERRAFORM_BACKEND_FILE" ] && \
terraform init \
    -backend-config="$TERRAFORM_BACKEND_FILE" || \
[ -z "$STATE_STORAGE_ACCOUNT" ] && echo "You must define environment variable STATE_STORAGE_ACCOUNT" || \
terraform init \
    -backend-config="resource_group_name=$STATE_RESOURCE_GROUP_NAME" \
    -backend-config="storage_account_name=$STATE_STORAGE_ACCOUNT" \
    -backend-config="container_name=$SUBSCRIPTION_ID" \
    -backend-config="key=$ARM_SUBSCRIPTION_ID.tfvar" \
    -backend-config="subscription_id=$STATE_SUBSCRIPTION_ID"
    -backend-config="tenant_id=$STATE_TENANT_ID"