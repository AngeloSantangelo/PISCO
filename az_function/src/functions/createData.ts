import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'


export async function createData(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    
    const prisma = new PrismaClient()
    
    try {
        const data:any = await request.json();
        const peopleNumber = data.peopleNumber;
        const idSensor = data.idSensor;

        /*for(let month = 1; month <= 12; month++)
        {
            for(let j=0; j<10; j++)
            {
                const date = new Date(`2024-${month.toString().padStart(2, '0')}-${(j+1).toString().padStart(2, '0')}T18:25:26.216Z`);
                const collectedData = await prisma.collectedData.create({
                    data: {
                        peopleNumber: peopleNumber,
                        idSensor: idSensor,
                        date: date
                    }
                });
                
            }
        }*/

        const collectedData = await prisma.collectedData.create({
            data: {
                peopleNumber: peopleNumber,
                idSensor: idSensor
            }
        });

        return {
            jsonBody: {
                collectedData
            },
        };
        
    } catch (error) {
        console.error('Error processing request:', error);
        return { body: error };
    } finally {
        await prisma.$disconnect();
    }
};

app.http('createData', {
    methods: ['GET', 'POST', 'OPTIONS'],
    authLevel: 'anonymous',
    handler: createData
});