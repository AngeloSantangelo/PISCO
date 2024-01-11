import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'


export async function createPullman(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    
    const prisma = new PrismaClient()
    
    try {
        const data:any = await request.json();
        const matricola = data.matricola;
        const numPiani = data.numPiani;
        const numPosti = data.numPosti;

        // Verifica che tutti i parametri necessari siano presenti
        if (!matricola || !numPiani || !numPosti) {
            return { status: 400, body: 'Missing parameters' };
        }

        const pullman = await prisma.pullman.create({
            data: {
                matricola: matricola,
                numPosti: parseInt(numPosti),
                numPiani: parseInt(numPiani)
            }
        });

        return { status: 200, body: `Pullman created successfully con id ${pullman.idPullman}, matricola ${pullman.matricola}, numPiani ${pullman.numPiani} e numPosti ${pullman.numPosti}` };
    } catch (error) {
        console.error('Error processing request:', error);
        return { body: error };
    } finally {
        await prisma.$disconnect();
    }
};

app.http('createPullman', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: createPullman
});