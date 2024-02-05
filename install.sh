LOCATION="my_location"
RESOURCE_GROUP="my_resource_group"
SQL_SERVER="my_server"
SHADOW_DB="my_shadow_db"
SQL_DATABASE="my_database"
USERNAME="my_username"
PASSWORD="my_password"
IOT_HUB="my_iot_hub"
FUNCTION_APP="my_function_app"
STORAGE_ACCOUNT="my_storage_account"
STREAM_JOB="my_stream_job"
IOT_HUB_POLICY_NAME="iothubowner"
OUTPUT_NAME="output_name_stream_job"


echo "Login to Azure ..."
az login

echo "Creating resource group $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Creating sql server $SQL_SERVER..."
az sql server create --name $SQL_SERVER --resource-group $RESOURCE_GROUP --location $LOCATION --admin-user $USERNAME --admin-password $PASSWORD

echo "Configuring firewall..."
az sql server firewall-rule create --resource-group $RESOURCE_GROUP --server $SQL_SERVER --start-ip-address "0.0.0.0" --end-ip-address "255.255.255.255" --name "AllowAllAzureIPs"

echo "Creating $SQL_DATABASE on $SQL_SERVER..."
az sql db create --resource-group $RESOURCE_GROUP --server $SQL_SERVER --name $SQL_DATABASE --free-limit true --free-limit-exhaustion-behavior AutoPause --edition GeneralPurpose --compute-model Serverless --family Gen5 --capacity 1

echo "Creating $SHADOW_DB on $SQL_SERVER..."
az sql db create --resource-group $RESOURCE_GROUP --server $SQL_SERVER --name $SHADOW_DB --edition GeneralPurpose --compute-model Serverless --family Gen5 --capacity 1 --zone-redundant false

echo "Creating the IoT Hub $IOT_HUB"
az iot hub create -n $IOT_HUB --resource-group $RESOURCE_GROUP --sku F1 --partition-count 2 --location $LOCATION

echo "" >> az_function/.env
echo IOT_HUB_CONNECTION_STRING="$( az iot hub connection-string show --hub-name $IOT_HUB --policy-name registryReadWrite --resource-group $RESOURCE_GROUP | jq '.connectionString' )" >> az_function/.env
echo "DATABASE_URL=\"sqlserver://$SQL_SERVER.database.windows.net:1433;database=$SQL_DATABASE;user=$USERNAME@$SQL_SERVER;password=$PASSWORD\"" >> az_function/.env
echo "SHADOW_DATABASE_URL=\"sqlserver://$SQL_SERVER.database.windows.net:1433;database=$SHADOW_DB;user=$USERNAME@$SQL_SERVER;password=$PASSWORD\"" >> az_function/.env

echo "Creating the storage account $STORAGE_ACCOUNT"
az storage account create --name $STORAGE_ACCOUNT --resource-group $RESOURCE_GROUP --location $LOCATION --sku Standard_LRS --kind StorageV2

echo "Creating the function app $FUNCTION_APP"
az functionapp create --name $FUNCTION_APP --resource-group $RESOURCE_GROUP --consumption-plan-location $LOCATION --runtime node --runtime-version 18 --functions-version 4 --os-type Linux --storage-account $STORAGE_ACCOUNT

echo "Generating scheme Prisma ..."
cd az_function
npx prisma generate
npx prisma db push

echo "Waiting for additional time before deploying..."
sleep 10

echo "Deploying Azure Function on $FUNCTION_APP ..."
func azure functionapp publish $FUNCTION_APP


echo "Creating stream analytics job $STREAM_JOB ..."
az stream-analytics job create --name $STREAM_JOB --resource-group $RESOURCE_GROUP --location $LOCATION --transformation name="transformationtest" streaming-units=1 query="my_query_stream_job"


# Prendere la chiave della policy dell'IoT Hub
IOT_HUB_POLICY_KEY=$(az iot hub policy show --hub-name $IOT_HUB -n "iothubowner" | jq -r '.primaryKey')
# Configurazione input per lo Stream Analytics Job
INPUT_PROPERTIES=$(cat <<EOF
{
  "type": "Stream",
  "datasource": {
    "type": "Microsoft.Devices/IotHubs",
    "properties": {
      "consumerGroupName": "\$Default",
      "endpoint": "messages/events",
      "iotHubNamespace": "$IOT_HUB",
      "sharedAccessPolicyKey": "$IOT_HUB_POLICY_KEY",
      "sharedAccessPolicyName": "$IOT_HUB_POLICY_NAME"
    }
  },
  "serialization": {
    "type": "Json",
    "properties": {
      "encoding": "UTF8"
    }
  }
}
EOF
)

# Il nome dell'input sarà uguale al nome dell'IoT-Hub (scelta progettuale)
echo "Configuring input for Stream Analytics Job $STREAM_JOB: $IOT_HUB ..."
az stream-analytics input create --name $IOT_HUB --job-name $STREAM_JOB --resource-group $RESOURCE_GROUP --properties "$INPUT_PROPERTIES"


# Configurazione output per lo Stream Analytics Job 
# Il nome dell'ouptut sarà diverso dal nome del Database perchè vi è il divieto di inserire carattere speciale come '_' (underscore)
TABLE_DATABASE_OUTPUT="CollectedData"
echo "Configuring output for Stream Analytics Job $STREAM_JOB: $OUTPUT_NAME ..."
az stream-analytics output create --job-name $STREAM_JOB --datasource "{\"type\":\"Microsoft.Sql/Server/Database\",\"properties\":{\"server\":\"$SQL_SERVER\",\"database\":\"$SQL_DATABASE\",\"user\":\"$USERNAME\",\"password\":\"$PASSWORD\",\"table\":\"$TABLE_DATABASE_OUTPUT\"}}" --serialization "{\"type\":\"Json\",\"properties\":{\"format\":\"Array\",\"encoding\":\"UTF8\"}}" --output-name $OUTPUT_NAME --resource-group $RESOURCE_GROUP


echo "Starting the Process of Stream Analytics Job $STREAM_JOB ..."
az stream-analytics job start --name $STREAM_JOB --resource-group $RESOURCE_GROUP