import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'

export async function findAllPullman(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    const prisma = new PrismaClient();

    try {
        const pullman = await prisma.pullman.findMany();

        return {
            jsonBody: {
                pullman,
            },
        };
    } catch (error) {
        context.log(error);
        return { body: error };
    } finally {
        await prisma.$disconnect();
    }
};


app.http('findAllPullman', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: findAllPullman
});
