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

# Create a MssQL Server
if ! az mysql flexible-server show \
  --resource-group "$resourceGroup" \
  --name "$mysqlServerName" &>/dev/null; then

  az mysql flexible-server create \
    --resource-group "$resourceGroup" \
    --name "$mysqlServerName" \
    --location $location \
    --admin-user "$mysqlServerAdmin" \
    --admin-password "$mysqlServerPassword" \
    --sku-name Standard_B1s \
    --version 5.7 \
    --tags $tags
else
  echo "MySQL Server: $mysqlServerName already setup."
fi

ruleName="allowAllAzureIPs"
if ! az mysql flexible-server firewall-rule show \
  --resource-group "$resourceGroup" \
  --name "$mysqlServerName" \
  --rule-name "$ruleName" &>/dev/null; then

  az mysql flexible-server firewall-rule create \
    --name "$mysqlServerName" \
    --resource-group "$resourceGroup" \
    --rule-name "$ruleName" \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 0.0.0.0
else
  echo "MySQL Server Firewall Rule: $ruleName already setup."
fi

# Create WordPress Database
wpDbName="wordpress"
if ! az mysql flexible-server db show \
  --resource-group "$resourceGroup" \
  --server-name "$mysqlServerName" \
  --database-name "$wpDbName" &>/dev/null; then

  az mysql flexible-server db create \
    --resource-group "$resourceGroup" \
    --server-name "$mysqlServerName" \
    --database-name "$wpDbName"
else
  echo "MySQL Server Database: $wpDbName already setup."
fi
