RESOURCE_GROUP="my_resource_group"
STREAM_JOB="my_stream_job"

echo "Stop the stream analytics job process"
az stream-analytics job stop --job-name $STREAM_JOB --resource-group $RESOURCE_GROUP

echo "Uninstalling resource group $RESOURCE_GROUP ..."
az group delete --name $RESOURCE_GROUP --yes