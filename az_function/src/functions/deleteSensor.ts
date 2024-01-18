import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'

export async function deleteSensor(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    const prisma = new PrismaClient();

    // var iothub = require('azure-iothub');
    // var connectionString = process.env.IOT_HUB_CONNECTION_STRING;
    // var registry = iothub.Registry.fromConnectionString(connectionString);

    try{
        const data:any = await request.json();
        const sensor = await prisma.sensor.delete({
            where:{
                idSensor:parseInt(data.idSensor),
            },
        });

        //const device =  (await registry.delete((sensor.idSensor).toString())).responseBody;

        return {
            jsonBody: {
                sensor
            },
          };
    }catch(error){
        console.error('Errore durante l\'elaborazione della richiesta:', error);
        return { body: error };
    }finally{
        await prisma.$disconnect();
    }
    
};

app.http('deleteSensor', {
    methods: ['GET','POST'],
    authLevel: 'anonymous',
    handler: deleteSensor
});