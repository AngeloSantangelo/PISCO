import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'

export async function findAllSensor(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    const prisma = new PrismaClient();

    try {
        const sensor = await prisma.sensor.findMany();

        return {
            jsonBody: {
                sensor,
            },
        };
    } catch (error) {
        context.log(error);
        return { body: error };
    } finally {
        await prisma.$disconnect();
    }
};


app.http('findAllSensor', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: findAllSensor
});