import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'

export async function findSensorByIdPullman(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    const prisma = new PrismaClient();

    try {
        const data:any = await request.json();
        const sensors = await prisma.sensor.findMany({
            where: {
                idPullman: parseInt(data.idPullman),
            },
        });

        return {
            jsonBody: {
                sensors,
            },
        };
        
    } catch (error) {
        context.log(error);
        return { body: error };
    } finally {
        await prisma.$disconnect();
    }
};


app.http('findSensorByIdPullman', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: findSensorByIdPullman
});