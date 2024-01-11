BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[Sensor] (
    [idSensor] INT NOT NULL IDENTITY(1,1),
    [matricola] NVARCHAR(1000) NOT NULL,
    [connectionString] NVARCHAR(1000) NOT NULL,
    [idPullman] INT NOT NULL,
    CONSTRAINT [Sensor_pkey] PRIMARY KEY CLUSTERED ([idSensor]),
    CONSTRAINT [Sensor_matricola_key] UNIQUE NONCLUSTERED ([matricola])
);

-- CreateTable
CREATE TABLE [dbo].[Pullman] (
    [idPullman] INT NOT NULL IDENTITY(1,1),
    [matricola] NVARCHAR(1000) NOT NULL,
    [numPiani] INT NOT NULL,
    [numPosti] INT NOT NULL,
    CONSTRAINT [Pullman_pkey] PRIMARY KEY CLUSTERED ([idPullman]),
    CONSTRAINT [Pullman_matricola_key] UNIQUE NONCLUSTERED ([matricola])
);

-- CreateTable
CREATE TABLE [dbo].[CollectedData] (
    [id] INT NOT NULL IDENTITY(1,1),
    [peopleNumber] INT NOT NULL,
    CONSTRAINT [CollectedData_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- AddForeignKey
ALTER TABLE [dbo].[Sensor] ADD CONSTRAINT [Sensor_idPullman_fkey] FOREIGN KEY ([idPullman]) REFERENCES [dbo].[Pullman]([idPullman]) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
