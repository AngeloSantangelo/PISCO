import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'
import { createPullman } from "./createPullman";


export async function createSensor(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    const prisma = new PrismaClient()
    
    var iothub = require('azure-iothub');
    var connectionString = process.env.IOT_HUB_CONNECTION_STRING;
    var registry = iothub.Registry.fromConnectionString(connectionString);

   try{
    const data:any = await request.json();
    const idPullman = data.idPullman;
    
    const sensor = await prisma.sensor.create({
        data: {
            matricola: data.matricola,
            connectionString: "",
            pullman: {
                connect: { idPullman: idPullman } // Collegamento al pullman tramite l'ID
            }
        },
    });

    const device = (await registry.create({
        deviceId:sensor.idSensor
    })).responseBody;

    var cs =  `HostName=piscooiothub.azure-devices.net;DeviceId=${sensor.idSensor};SharedAccessKey=${device.authentication.symmetricKey.primaryKey}`;

    const updateSensor = await prisma.sensor.update({
        where: {
          idSensor: sensor.idSensor,
        },
        data: {
          connectionString: cs,
        },
    })

    return {
        status:200,
        jsonBody: {
            updateSensor
        },
    };

    }catch(error){
        console.error('Errore durante l\'elaborazione della richiesta:', error);
        return { body: error };
    }finally{
        await prisma.$disconnect();
    }

};

app.http('createSensor', {
    methods: ['POST'],
    authLevel: 'anonymous',
    handler: createSensor
});