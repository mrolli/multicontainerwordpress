#!/usr/bin/env bash

# Set who we are and where we are
script_dir="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit 1
  pwd -P
)"

# Source bash script utilities
source "${script_dir}/vars.sh"

# Delete the resource group and all resources within it
if az group show --name "$resourceGroup" &>/dev/null; then
  echo "Deleting resource group $resourceGroup"
  az group delete --name "$resourceGroup"
fi
