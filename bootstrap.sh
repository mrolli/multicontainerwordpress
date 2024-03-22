#!/usr/bin/env bash

# Set who we are and where we are
script_dir="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)"

# Source bash script utilities
source "${script_dir}/vars.sh"

# Create a resource group
az group create \
  --name "$resourceGroup" \
  --location $location \
  --tags $tags

az appservice plan create \
  --name "$appservicePlanName" \
  --resource-group "$resourceGroup" \
  --sku S1 \
  --is-linux \
  --tags $tags

# Create an App Service plan
az webapp create \
  --resource-group "$resourceGroup" \
  --plan "$appservicePlanName" \
  --name "$appserviceName" \
  --multicontainer-config-type compose \
  --multicontainer-config-file docker-compose-wordpress.yml \
  --tags $tags
