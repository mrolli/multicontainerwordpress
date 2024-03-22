#!/usr/bin/env bash

declare -rx name="multicontaierwp"
declare -rx location="switzerlandnorth"
declare -rx environment="dev"
declare -rx rand="001"
declare -rx postfix="$name-$environment-$rand"
declare -rx resourceGroup="rg-$postfix"
declare -rx appservicePlanName="asp-$postfix"
declare -rx appserviceName="app-$postfix"
declare -rx tags="environment=$environment division=id subDivision=idsys"
