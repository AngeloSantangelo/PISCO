import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'
import { createPullman } from "./createPullman";

const prisma = new PrismaClient()

export async function createSensor(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {

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
    return {
        jsonBody: {
            sensor
        },
    };

    }catch(error){
        console.error('Errore durante l\'elaborazione della richiesta:', error);
        return { body: error };
    }finally{
        prisma.$disconnect();
    }

};

app.http('createSensor', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: createSensor
});