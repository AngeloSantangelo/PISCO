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

-- CreateIndex
CREATE UNIQUE INDEX "Sensor_matricola_key" ON "Sensor"("matricola");

-- CreateIndex
CREATE UNIQUE INDEX "Pullman_matricola_key" ON "Pullman"("matricola");
