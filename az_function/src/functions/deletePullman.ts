import { app, HttpRequest, HttpResponseInit, InvocationContext } from "@azure/functions";
import { PrismaClient } from '@prisma/client'

export async function deletePullman(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
    const prisma = new PrismaClient();

    try{
        const data:any = await request.json();
        const pullman = await prisma.pullman.delete({
            where:{
                idPullman: parseInt(data.idPullman),
            },
        });

        return {
            jsonBody: {
                pullman
            },
          };
    }catch(error){
        console.error('Errore durante l\'elaborazione della richiesta:', error);
        return { body: error };
    }finally{
        await prisma.$disconnect();
    }
    
};

app.http('deletePullman', {
    methods: ['GET','POST'],
    authLevel: 'anonymous',
    handler: deletePullman
});