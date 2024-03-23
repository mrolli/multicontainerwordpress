#!/usr/bin/env bash

# Set who we are and where we are
script_dir="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)"

# Source bash script utilities
source "${script_dir}/vars.sh"

# Create a resource group
if ! az group show --name "$resourceGroup" &>/dev/null; then
  az group create \
    --name "$resourceGroup" \
    --location $location \
    --tags $tags
else
  echo "Resource Group: $resourceGroup already setup."
fi

# Create an App Service plan
if ! az appservice plan show \
  --name "$appservicePlanName" \
  --resource-group "$resourceGroup" &>/dev/null; then

  az appservice plan create \
    --name "$appservicePlanName" \
    --resource-group "$resourceGroup" \
    --sku S1 \
    --is-linux \
    --tags $tags
else
  echo "App Service Plan: $appservicePlanName already setup."
fi

if ! az webapp show \
  --name "$appserviceName" \
  --resource-group "$resourceGroup" &>/dev/null; then

  az webapp create \
    --resource-group "$resourceGroup" \
    --plan "$appservicePlanName" \
    --name "$appserviceName" \
    --multicontainer-config-type compose \
    --multicontainer-config-file docker-compose-wordpress.yml \
    --tags $tags
else
  echo "Web App: $appserviceName already setup."
fi
