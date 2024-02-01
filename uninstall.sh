RESOURCE_GROUP="piscoo"
STREAM_JOB="pisco_job"

echo "Stop the stream analytics job process"
az stream-analytics job stop --job-name $STREAM_JOB --resource-group $RESOURCE_GROUP

echo "Uninstalling resource group $RESOURCE_GROUP ..."
az group delete --name $RESOURCE_GROUP --yes