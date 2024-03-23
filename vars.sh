#!/usr/bin/env bash

declare -r name="multicontainerwp"
declare -r location="switzerlandnorth"
declare -r environment="dev"
declare -r rand="001"
declare -r postfix="$name-$environment-$rand"
declare -r resourceGroup="rg-$postfix"
declare -r appservicePlanName="asp-$postfix"
declare -r appserviceName="app-$postfix"
declare -r tags="environment=$environment division=id subDivision=idsys"

declare -r mysqlServerName="mysql-$postfix"
declare -r mysqlServerAdmin="adminuser"
declare -r mysqlServerPassword="My5p!3rr0Paw0rd"
