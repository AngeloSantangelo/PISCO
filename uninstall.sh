RESOURCE_GROUP="piscoo"

echo "Uninstalling resource group $RESOURCE_GROUP ..."
az group delete --name $RESOURCE_GROUP --yes