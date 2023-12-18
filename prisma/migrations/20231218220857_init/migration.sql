-- CreateTable
CREATE TABLE "Sensor" (
    "idSensor" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "matricola" TEXT NOT NULL,
    "connectionString" TEXT NOT NULL,
    "installed" BOOLEAN NOT NULL DEFAULT false,
    "idPullman" INTEGER NOT NULL,
    CONSTRAINT "Sensor_idPullman_fkey" FOREIGN KEY ("idPullman") REFERENCES "Pullman" ("idPullman") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Pullman" (
    "idPullman" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);

-- CreateIndex
CREATE UNIQUE INDEX "Sensor_matricola_key" ON "Sensor"("matricola");
