![Logo PISCO](https://github.com/AngeloSantangelo/PISCO/assets/115495018/e7e96419-f808-49ae-afc9-19542b2db25d)

# PISCO (Pullman IoT Software with Cloud Optimization)
PISCO è un sistema ideato per compagnie di trasporto pubblico ed è stato realizzato come progetto Universitario per il corso di Cloud Computing del dipartimento di Informatica presso l'Università degli Studi di Salerno.
## Obiettivo e Descrizione
PISCO è un sistema Cloud-based che sfrutta le tecnologie Internet of Things (IoT) per modernizzare la gestione del trasporto pubblico e per monitorare e gestire i pullman in maniera efficiente. L'obiettivo di PISCO è offrire un sistema di monitoraggio in tempo reale dell'afflusso dei passeggeri a bordo su tali mezzi attraverso l'utilizzo di sensori IoT installati internamente, fornendo informazioni e insight preziosi per ottimizzare le corse e migliorare l'efficienza operativa complessiva.
## Funzionalità
- Creazione ed Eliminazione dei pullman.
- Creazione ed Eliminazione dei sensori con annessa assegnazione al corrispondente pullman.
- Visualizzazione in tempo reale dei dati inviati dai sensori mediante grafici che riporteranno esclusivamente i giorni in cui un pullman è stato in servizio, indicando il numero massimo di passeggeri saliti a bordo in ciascuna di tali giornate. L'azienda, in questo modo, può beneficiare di una visione chiara dell'affluenza giornaliera, consentendole di valutare la necessità di inserire ulteriori pullman e garantire un ambiente più sicuro evitando situazioni di sovraffollamento.
## Architettura di PISCO
![ArchitetturaPisco](https://github.com/AngeloSantangelo/PISCO/assets/115495018/dc2c85c2-254c-49e6-a5ca-348ecb81a920)
## Descrizione dell'architettura
- I sensori IoT sono dispositivi fisici che raccolgono dati dal mondo reale, ovvero il numero di persone all'interno di un pullman, e vengono gestiti e archiviati all'interno del servizio Azure IoT Hub.
- Azure IoT Hub invia i dati raccolti dai sensori al servizio Azure Stream Analytics Job, il quale si occupa di elaborarli in tempo reale eseguendo operazioni su di essi, come filtraggio e aggregazione.
- Azure Stream Analytics Job invia i dati elaborati ad SQL Database, dove verranno archiviati per un accesso successivo.
- Azure SQL Database archivia tutti i dati raccolti dai sensori e dalle Azure Function.
- Le Azure Functions rappresentano una componente serverless che risponde a eventi richiesti dal servizio App Service e hanno accesso al database. Verranno utilizzate anche per recuperare, dal database, i dati raccolti dai sensori e visualizzarli sottoforma di grafici all'interno della pagina web. 
- L'App Service è il componente che ospita l'applicazione web. L'utente interagirà con l'applicazione inviando richieste come creazione ed eliminazione di pullman e sensori, le quali verranno soddisfatte tramite le Azure Functions.
## Requisiti
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) per eseguire il provisioning dell'infrastruttura.
- Node.js (v20.9.0), TypeScript (v4.0.0) e Prisma (v^5.7.1) per effettuare il deploy delle risorse.
