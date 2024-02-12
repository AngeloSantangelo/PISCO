![Logo PISCO](https://github.com/AngeloSantangelo/PISCO/assets/115495018/e7e96419-f808-49ae-afc9-19542b2db25d)

# PISCO (Pullman IoT Software with Cloud Optimization)
PISCO è un sistema ideato per compagnie di trasporto pubblico ed è stato realizzato come progetto Universitario per il corso di Cloud Computing del dipartimento di Informatica presso l'Università degli Studi di Salerno.
## Obiettivo e Descrizione
PISCO è un sistema Cloud-based che sfrutta le tecnologie Internet of Things (IoT) per modernizzare la gestione del trasporto pubblico e per monitorare e gestire i pullman in maniera efficiente. L'obiettivo di PISCO è offrire un sistema di monitoraggio in tempo reale dell'afflusso dei passeggeri a bordo su tali mezzi attraverso l'utilizzo di sensori IoT installati internamente, fornendo informazioni e insight preziosi per ottimizzare le corse e migliorare l'efficienza operativa complessiva.
## Funzionalità
- Creazione ed eliminazione dei pullman.
- Creazione ed eliminazione dei sensori con annessa assegnazione al corrispondente pullman.
- Visualizzazione in tempo reale dei dati inviati dai sensori mediante grafici che riporteranno esclusivamente i giorni in cui un pullman è stato in servizio, indicando il numero massimo di passeggeri saliti a bordo in ciascuna di tali giornate. L'azienda, in questo modo, può beneficiare di una visione chiara dell'affluenza giornaliera, consentendole di valutare la necessità di inserire ulteriori pullman e garantire un ambiente più sicuro evitando situazioni di sovraffollamento.
## Architettura di PISCO
![ArchitetturaPisco](https://github.com/AngeloSantangelo/PISCO/assets/115495018/1e32bb3f-8ee9-4e71-bd00-a28ca55bc449)

## Descrizione dell'architettura
- I __sensori__ __IoT__ sono dispositivi fisici che raccolgono dati dal mondo reale, ovvero il numero di persone all'interno di un pullman.
- Dopo la creazione di un sensore, viene generato un suo 'gemello', che costituisce una rappresentazione virtuale dettagliata del dispositivo fisico. Questo __Device Twin__ viene gestito e archiviato all'interno del servizio Azure IoT Hub.
- __Azure IoT Hub__ invia i dati raccolti dai sensori al servizio Azure Stream Analytics Job, il quale si occupa di elaborarli in tempo reale eseguendo operazioni su di essi, come filtraggio e aggregazione.
- __Azure Stream Analytics Job__ invia i dati elaborati ad Azure SQL Database, dove verranno archiviati per un accesso successivo.
- __Azure SQL Server__ rappresenta il motore di database che gestisce il flusso e l'accesso ai dati. È il punto centrale per archiviare e gestire tutti i dati provenienti dai sensori e elaborati dalle Azure Functions.
- __Azure SQL Database__ è un servizio di database relazionale completamente gestito su Microsoft Azure. Rappresenta il luogo dove verranno archiviati tutti i dati provenienti dai sensori e elaborati dalle Azure Functions.
- __Azure SQL Shadow Database__ è un database temporaneo che viene creato ed eliminato ad ogni migrazione del database principale, a causa di Prisma. La sua utilità è garantire sicurezza nelle varie migrazioni, controllando che non ci siano modifiche impreviste allo schema del database principale. Per tale motivo, viene usato solo in fase di deployment dell'applicazione e non durante l'effettivo uso di PISCO.
- La __Azure Functions App__ rappresenta un contenitore logico per le Azure Functions, consentendo di gestirle e organizzarle in modo efficiente all'interno dell'applicazione. Le __Azure Functions__ rappresentano una componente serverless che risponde a eventi richiesti dalla Static Web App e hanno accesso al database. Verranno utilizzate per recuperare, dal database, i dati raccolti dai sensori e visualizzarli sottoforma di grafici all'interno della pagina web.
- Per supportare la Azure Function App, è necessario uno __Storage Account__, che fornisce lo storage persistente per i dati e le risorse utilizzate dalle funzioni serverless. Lo Storage Account contribuisce alla gestione affidabile dei dati e degli asset necessari per il corretto funzionamento delle funzioni all'interno dell'architettura cloud.
- La __Azure Static Web App__ è il componente che ospita l'applicazione web e offre un'architettura serverless. L'utente interagisce con l'applicazione inviando richieste come creazione ed eliminazione di pullman e sensori, le quali vengono gestite tramite le Azure Functions.
## Requisiti
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) per eseguire il provisioning dell'infrastruttura.
- [Node.js (v20.9.0)](https://radixweb.com/blog/installing-npm-and-nodejs-on-windows-and-mac), [TypeScript (v4.0.0)](https://www.typescriptlang.org/download#:~:text=across%20different%20machines.-,via%20npm,latest%20version%20(currently%205.3).), [Prisma (v^5.7.1)](https://www.prisma.io/docs/getting-started/quickstart) e [Python (v^3)](https://www.python.org/downloads/) per effettuare il deploy delle risorse.
## Descrizione delle cartelle
- La cartella "az_function" contiene i vari file di configurazione (.json), una cartella "prisma" dove è definito lo schema del database e, infine, una cartella "src/functions" contenente tutte le Azure Functions del progetto.
- La cartella "front-end" contiene tutti i file html riguardanti l'interfaccia grafica e il logo di Pisco.
- La cartella "mock_sensors" contiene lo script Python utilizzato per simulare l'invio dei dati da un sensore installato internamente al pullman.
- I due script "install.sh" e "uninstall.sh" sono descritti nella prossima sezione "Configurazione dell'infrastruttura di Azure".
## Configurazione dell'infrastruttura di Azure
Per automatizzare la procedura di provisioning di tutte le risorse necessarie per il funzionamento di PISCO, è stato sviluppato uno script Bash (install.sh). Per personalizzare l'installazione in base al tuo progetto, è fondamentale apportare le opportune modifiche alle variabili d'ambiente nel file "install.sh", specificando i valori appropriati per la propria architettura. Una volta completata la configurazione, esegui il seguente comando per avviare il processo di installazione:
```bash

bash install.sh

```
Questo comando garantirà l'esecuzione del provisioning dell'infrastruttura con le impostazioni personalizzate definite nel file "install.sh". Tuttavia, la creazione della [Azure Static Web App](https://learn.microsoft.com/en-us/azure/static-web-apps/get-started-portal?tabs=vanilla-javascript&pivots=github) non è inclusa all'interno di questo script. Pertanto, per configurare correttamente tale servizio, è necessario eseguire manualmente il processo previsto direttamente su Azure.


Un ulteriore script Bash (uninstall.sh) è stato implementato per automatizzare il processo di eliminazione di tutte le risorse precedentemente create. Analogamente al processo di installazione, è necessario personalizzare le variabili d'ambiente per la propria architettura. Per avviare questa procedura, esegui il seguente comando:
```bash

bash uninstall.sh

```
L'esecuzione di questo comando garantirà la corretta eliminazione di tutte le risorse create durante il provisioning, semplificando così il processo di deprovisioning dell'infrastruttura legata al progetto.
