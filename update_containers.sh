#!/usr/bin/env bash

# Set who we are and where we are
script_dir="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)"

# Source bash script utilities
source "${script_dir}/vars.sh"

az webapp config appsettings set \
  --resource-group "$resourceGroup" \
  --name "$appserviceName" \
  --settings @app-settings.json

az webapp config container set \
  --resource-group "$resourceGroup" \
  --name "$appserviceName" \
  --multicontainer-config-type compose \
  --multicontainer-config-file docker-compose-wordpress.yml
