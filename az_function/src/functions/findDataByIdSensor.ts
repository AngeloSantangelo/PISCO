import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'

export async function findDataByIdSensor(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    const prisma = new PrismaClient();

    try {
        const data:any = await request.json();
        const collectedData = await prisma.collectedData.findMany({
            where: {
                idSensor: parseInt(data.idSensor),
            },
        });

        return {
            jsonBody: {
                collectedData,
            },
        };
        
    } catch (error) {
        context.log(error);
        return { body: error };
    } finally {
        await prisma.$disconnect();
    }
};


app.http('findDataByIdSensor', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: findDataByIdSensor
});