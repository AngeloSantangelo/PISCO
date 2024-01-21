-- CreateTable
CREATE TABLE "Sensor" (
    "idSensor" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "matricola" TEXT NOT NULL,
    "connectionString" TEXT NOT NULL,
    "idPullman" INTEGER NOT NULL,
    CONSTRAINT "Sensor_idPullman_fkey" FOREIGN KEY ("idPullman") REFERENCES "Pullman" ("idPullman") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Pullman" (
    "idPullman" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "matricola" TEXT NOT NULL,
    "numPiani" INTEGER NOT NULL,
    "numPosti" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "CollectedData" (
    "idData" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "peopleNumber" INTEGER NOT NULL,
    "date" DATETIME NOT NULL,
    "idSensor" INTEGER NOT NULL,
    CONSTRAINT "CollectedData_idSensor_fkey" FOREIGN KEY ("idSensor") REFERENCES "Sensor" ("idSensor") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Sensor_matricola_key" ON "Sensor"("matricola");

-- CreateIndex
CREATE UNIQUE INDEX "Pullman_matricola_key" ON "Pullman"("matricola");
