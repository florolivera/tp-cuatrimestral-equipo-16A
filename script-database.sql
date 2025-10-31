--CREATE DATABASE ClinicaDB
--USE ClinicaDB; -- <- descomentar si ya creaste la BD
--GO

CREATE TABLE Roles
(
    RolId      INT IDENTITY PRIMARY KEY,
    Descripcion        NVARCHAR(50) NOT NULL UNIQUE,  -- Admin | Recepcion | Medico
    CreatedAt   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
)

CREATE TABLE Users
(
    UserId          INT IDENTITY PRIMARY KEY,
    Username        NVARCHAR(50) NOT NULL UNIQUE,
    Email           NVARCHAR(254) NOT NULL,
    PasswordHash    VARBINARY(512) NULL,     -- manejar desde la app
    IsActive        BIT NOT NULL DEFAULT 1,
    CreatedAt       DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
)

CREATE TABLE UserRoles
(
    UserId  INT NOT NULL,
    RolId  INT NOT NULL,
    CONSTRAINT PK_UserRoles PRIMARY KEY (UserId, RolId),
    CONSTRAINT FK_UserRoles_User  FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT FK_UserRoles_Role  FOREIGN KEY (RolId) REFERENCES Roles(RolId)
)

CREATE TABLE Pacientes
(
    PacienteId  INT IDENTITY PRIMARY KEY,
    DNI         VARCHAR(20) NOT NULL UNIQUE,
    Nombre      NVARCHAR(80) NOT NULL,
    Apellido    NVARCHAR(80) NOT NULL,
    FechaNac    DATE NULL,
    Email       NVARCHAR(254) NULL,
    Telefono    NVARCHAR(50) NULL,
    Direccion   NVARCHAR(200) NULL,
    CreatedAt   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    IsActive    BIT NOT NULL DEFAULT 1
)

CREATE TABLE Medicos
(
    MedicoId    INT IDENTITY PRIMARY KEY,
    Matricula   NVARCHAR(40) NOT NULL UNIQUE,
    Nombre      NVARCHAR(80) NOT NULL,
    Apellido    NVARCHAR(80) NOT NULL,
    Email       NVARCHAR(254) NULL,
    Telefono    NVARCHAR(50) NULL,
    IsActive    BIT NOT NULL DEFAULT 1,
    CreatedAt   DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME()
)

CREATE TABLE Especialidades
(
    EspecialidadId  INT IDENTITY PRIMARY KEY,
    Nombre          NVARCHAR(100) NOT NULL UNIQUE,
    Descripcion     NVARCHAR(300) NULL,
    IsActive        BIT NOT NULL DEFAULT 1
)


CREATE TABLE MedicoEspecialidad
(
	MedicoEspecialidadId INT NOT NULL, 
    MedicoId        INT NOT NULL,
    EspecialidadId  INT NOT NULL,
    CONSTRAINT PK_MedicoEspecialidad PRIMARY KEY (MedicoEspecialidadId),
    CONSTRAINT FK_MedEsp_Medico        FOREIGN KEY (MedicoId)       REFERENCES Medicos(MedicoId),
    CONSTRAINT FK_MedEsp_Especialidad  FOREIGN KEY (EspecialidadId) REFERENCES Especialidades(EspecialidadId)
)


CREATE TABLE TurnosTrabajo
(
    TurnoTrabajoId  INT IDENTITY PRIMARY KEY,
    Nombre          NVARCHAR(50) NOT NULL UNIQUE,   
    HoraEntrada     TIME(0) NOT NULL,
    HoraSalida      TIME(0) NOT NULL,
    CONSTRAINT CK_TurnosTrabajo_Rango CHECK (HoraSalida > HoraEntrada)
)

CREATE TABLE AgendaMedico
(
    AgendaId        INT IDENTITY PRIMARY KEY,
    MedicoId        INT NOT NULL,
    TurnoTrabajoId  INT NOT NULL,
    DiaSemana       TINYINT NOT NULL,
    IsActive        BIT NOT NULL DEFAULT 1,
    CONSTRAINT CK_Agenda_DiaSemana CHECK (DiaSemana BETWEEN 1 AND 7),
    CONSTRAINT UQ_Agenda UNIQUE (MedicoId, TurnoTrabajoId, DiaSemana),
    CONSTRAINT FK_Agenda_Medico        FOREIGN KEY (MedicoId)       REFERENCES Medicos(MedicoId),
    CONSTRAINT FK_Agenda_TurnoTrabajo  FOREIGN KEY (TurnoTrabajoId) REFERENCES TurnosTrabajo(TurnoTrabajoId)
)


CREATE TABLE EstadosTurno
(
    EstadoId    INT IDENTITY PRIMARY KEY,
    Nombre      NVARCHAR(30) NOT NULL UNIQUE   -- Nuevo | Reprogramado | Cancelado | No Asistio | Cerrado
)

CREATE TABLE Turnos
(
    TurnoId         BIGINT IDENTITY PRIMARY KEY,
    NumeroTurno     NVARCHAR(20) NOT NULL,

    PacienteId      INT NOT NULL,
    MedicoId        INT NOT NULL,
    EspecialidadId  INT NOT NULL,

    Inicio          DATETIME2(0) NOT NULL,    -- fecha/hora de inicio
    DuracionMin     INT NOT NULL,             -- convención 60’
    Observaciones   NVARCHAR(1000) NULL,
    EstadoId        INT NOT NULL,
    ReprogramadoDeId BIGINT NULL,             -- referencia al turno original si se reprograma

    -- Claves foráneas
    CONSTRAINT FK_Turnos_Paciente       FOREIGN KEY (PacienteId)      REFERENCES Pacientes(PacienteId),
    CONSTRAINT FK_Turnos_Medico         FOREIGN KEY (MedicoId)        REFERENCES Medicos(MedicoId),
    CONSTRAINT FK_Turnos_Especialidad   FOREIGN KEY (EspecialidadId)  REFERENCES Especialidades(EspecialidadId),
    CONSTRAINT FK_Turnos_Estado         FOREIGN KEY (EstadoId)        REFERENCES EstadosTurno(EstadoId),
    CONSTRAINT FK_Turnos_ReprogramadoDe FOREIGN KEY (ReprogramadoDeId) REFERENCES Turnos(TurnoId)
)

CREATE TABLE EmailLog
(
    EmailLogId      BIGINT IDENTITY PRIMARY KEY,
    TurnoId         BIGINT NOT NULL,
    ParaEmail       NVARCHAR(254) NOT NULL,
    Asunto          NVARCHAR(200) NOT NULL,
    Cuerpo          NVARCHAR(MAX) NOT NULL,
    EnviadoAt       DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),
    EstadoEnvio     NVARCHAR(30) NOT NULL,         -- Enviado | Error | Reintento
    ErrorDetalle    NVARCHAR(1000) NULL,
    CONSTRAINT FK_EmailLog_Turno FOREIGN KEY (TurnoId) REFERENCES Turnos(TurnoId)
)


/* ============================
   SEEDS / INSERTS ClinicaDB
   ============================ */

---------------------------
-- Roles
---------------------------

USE Clinicadb
IF NOT EXISTS (SELECT 1 FROM Roles WHERE Descripcion = 'Admin')
    INSERT INTO Roles (Descripcion) VALUES ('Admin');
IF NOT EXISTS (SELECT 1 FROM Roles WHERE Descripcion = 'Recepcion')
    INSERT INTO Roles (Descripcion) VALUES ('Recepcion');
IF NOT EXISTS (SELECT 1 FROM Roles WHERE Descripcion = 'Medico')
    INSERT INTO Roles (Descripcion) VALUES ('Medico');

---------------------------
-- Users
---------------------------
IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'admin')
    INSERT INTO Users (Username, Email, PasswordHash) VALUES ('admin', 'admin@clinica.local', NULL);

IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'recep1')
    INSERT INTO Users (Username, Email, PasswordHash) VALUES ('recep1', 'recepcion@clinica.local', NULL);

IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'dr.ana')
    INSERT INTO Users (Username, Email, PasswordHash) VALUES ('dr.ana', 'ana.perez@clinica.local', NULL);

IF NOT EXISTS (SELECT 1 FROM Users WHERE Username = 'dr.luis')
    INSERT INTO Users (Username, Email, PasswordHash) VALUES ('dr.luis', 'luis.gomez@clinica.local', NULL);

---------------------------
-- UserRoles
---------------------------
-- admin -> Admin
IF NOT EXISTS (
    SELECT 1 FROM UserRoles ur
    JOIN Users u ON u.UserId = ur.UserId
    JOIN Roles r ON r.RolId = ur.RolId
    WHERE u.Username = 'admin' AND r.Descripcion = 'Admin'
)
INSERT INTO UserRoles (UserId, RolId)
SELECT u.UserId, r.RolId FROM Users u CROSS JOIN Roles r
WHERE u.Username = 'admin' AND r.Descripcion = 'Admin';

-- recep1 -> Recepcion
IF NOT EXISTS (
    SELECT 1 FROM UserRoles ur
    JOIN Users u ON u.UserId = ur.UserId
    JOIN Roles r ON r.RolId = ur.RolId
    WHERE u.Username = 'recep1' AND r.Descripcion = 'Recepcion'
)
INSERT INTO UserRoles (UserId, RolId)
SELECT u.UserId, r.RolId FROM Users u CROSS JOIN Roles r
WHERE u.Username = 'recep1' AND r.Descripcion = 'Recepcion';

-- dr.ana -> Medico
IF NOT EXISTS (
    SELECT 1 FROM UserRoles ur
    JOIN Users u ON u.UserId = ur.UserId
    JOIN Roles r ON r.RolId = ur.RolId
    WHERE u.Username = 'dr.ana' AND r.Descripcion = 'Medico'
)
INSERT INTO UserRoles (UserId, RolId)
SELECT u.UserId, r.RolId FROM Users u CROSS JOIN Roles r
WHERE u.Username = 'dr.ana' AND r.Descripcion = 'Medico';

-- dr.luis -> Medico
IF NOT EXISTS (
    SELECT 1 FROM UserRoles ur
    JOIN Users u ON u.UserId = ur.UserId
    JOIN Roles r ON r.RolId = ur.RolId
    WHERE u.Username = 'dr.luis' AND r.Descripcion = 'Medico'
)
INSERT INTO UserRoles (UserId, RolId)
SELECT u.UserId, r.RolId FROM Users u CROSS JOIN Roles r
WHERE u.Username = 'dr.luis' AND r.Descripcion = 'Medico';

---------------------------
-- Pacientes
---------------------------
IF NOT EXISTS (SELECT 1 FROM Pacientes WHERE DNI = '30111222')
INSERT INTO Pacientes (DNI, Nombre, Apellido, FechaNac, Email, Telefono, Direccion)
VALUES ('30111222','María','López','1990-05-10','maria.lopez@mail.com','351-123456','Av. Siempre Viva 123');

IF NOT EXISTS (SELECT 1 FROM Pacientes WHERE DNI = '30999888')
INSERT INTO Pacientes (DNI, Nombre, Apellido, FechaNac, Email, Telefono, Direccion)
VALUES ('30999888','Juan','Sosa','1988-11-22','juan.sosa@mail.com','11-555555','Calle Falsa 456');

---------------------------
-- Médicos
---------------------------
IF NOT EXISTS (SELECT 1 FROM Medicos WHERE Matricula = 'MAT-1001')
INSERT INTO Medicos (Matricula, Nombre, Apellido, Email, Telefono)
VALUES ('MAT-1001','Ana','Pérez','ana.perez@clinica.local','1111-1111');

IF NOT EXISTS (SELECT 1 FROM Medicos WHERE Matricula = 'MAT-1002')
INSERT INTO Medicos (Matricula, Nombre, Apellido, Email, Telefono)
VALUES ('MAT-1002','Luis','Gómez','luis.gomez@clinica.local','2222-2222');

---------------------------
-- Especialidades
---------------------------
IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Nombre = N'Clínica Médica')
INSERT INTO Especialidades (Nombre, Descripcion) VALUES (N'Clínica Médica', N'Medicina general');

IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Nombre = N'Odontología')
INSERT INTO Especialidades (Nombre, Descripcion) VALUES (N'Odontología', N'Dentista');

IF NOT EXISTS (SELECT 1 FROM Especialidades WHERE Nombre = N'Pediatría')
INSERT INTO Especialidades (Nombre, Descripcion) VALUES (N'Pediatría', N'Niños y adolescentes');

---------------------------
-- MedicoEspecialidad  (tu tabla NO es IDENTITY; generamos el próximo id)
---------------------------
-- Ana Pérez -> Clínica Médica
IF NOT EXISTS (
    SELECT 1 FROM MedicoEspecialidad me
    JOIN Medicos m ON m.MedicoId = me.MedicoId
    JOIN Especialidades e ON e.EspecialidadId = me.EspecialidadId
    WHERE m.Matricula = 'MAT-1001' AND e.Nombre = N'Clínica Médica'
)
INSERT INTO MedicoEspecialidad (MedicoEspecialidadId, MedicoId, EspecialidadId)
SELECT ISNULL((SELECT MAX(MedicoEspecialidadId) FROM MedicoEspecialidad),0)+1,
       m.MedicoId, e.EspecialidadId
FROM Medicos m, Especialidades e
WHERE m.Matricula = 'MAT-1001' AND e.Nombre = N'Clínica Médica';

-- Ana Pérez -> Odontología
IF NOT EXISTS (
    SELECT 1 FROM MedicoEspecialidad me
    JOIN Medicos m ON m.MedicoId = me.MedicoId
    JOIN Especialidades e ON e.EspecialidadId = me.EspecialidadId
    WHERE m.Matricula = 'MAT-1001' AND e.Nombre = N'Odontología'
)
INSERT INTO MedicoEspecialidad (MedicoEspecialidadId, MedicoId, EspecialidadId)
SELECT ISNULL((SELECT MAX(MedicoEspecialidadId) FROM MedicoEspecialidad),0)+1,
       m.MedicoId, e.EspecialidadId
FROM Medicos m, Especialidades e
WHERE m.Matricula = 'MAT-1001' AND e.Nombre = N'Odontología';

-- Luis Gómez -> Odontología
IF NOT EXISTS (
    SELECT 1 FROM MedicoEspecialidad me
    JOIN Medicos m ON m.MedicoId = me.MedicoId
    JOIN Especialidades e ON e.EspecialidadId = me.EspecialidadId
    WHERE m.Matricula = 'MAT-1002' AND e.Nombre = N'Odontología'
)
INSERT INTO MedicoEspecialidad (MedicoEspecialidadId, MedicoId, EspecialidadId)
SELECT ISNULL((SELECT MAX(MedicoEspecialidadId) FROM MedicoEspecialidad),0)+1,
       m.MedicoId, e.EspecialidadId
FROM Medicos m, Especialidades e
WHERE m.Matricula = 'MAT-1002' AND e.Nombre = N'Odontología';

---------------------------
-- Turnos de trabajo
---------------------------
IF NOT EXISTS (SELECT 1 FROM TurnosTrabajo WHERE Nombre = N'Mañana')
INSERT INTO TurnosTrabajo (Nombre, HoraEntrada, HoraSalida) VALUES (N'Mañana','08:00','12:00');

IF NOT EXISTS (SELECT 1 FROM TurnosTrabajo WHERE Nombre = N'Mediodía')
INSERT INTO TurnosTrabajo (Nombre, HoraEntrada, HoraSalida) VALUES (N'Mediodía','12:00','16:00');

IF NOT EXISTS (SELECT 1 FROM TurnosTrabajo WHERE Nombre = N'Tarde')
INSERT INTO TurnosTrabajo (Nombre, HoraEntrada, HoraSalida) VALUES (N'Tarde','16:00','20:00');

---------------------------
-- Agenda semanal (ejemplos)
---------------------------
-- Ana: Lunes y Miércoles por la mañana
IF NOT EXISTS (
    SELECT 1 FROM AgendaMedico a
    JOIN Medicos m ON m.MedicoId = a.MedicoId
    JOIN TurnosTrabajo t ON t.TurnoTrabajoId = a.TurnoTrabajoId
    WHERE m.Matricula='MAT-1001' AND t.Nombre=N'Mañana' AND a.DiaSemana=1
)
INSERT INTO AgendaMedico (MedicoId, TurnoTrabajoId, DiaSemana, IsActive)
SELECT m.MedicoId, t.TurnoTrabajoId, 1, 1
FROM Medicos m CROSS JOIN TurnosTrabajo t
WHERE m.Matricula='MAT-1001' AND t.Nombre=N'Mañana';

IF NOT EXISTS (
    SELECT 1 FROM AgendaMedico a
    JOIN Medicos m ON m.MedicoId = a.MedicoId
    JOIN TurnosTrabajo t ON t.TurnoTrabajoId = a.TurnoTrabajoId
    WHERE m.Matricula='MAT-1001' AND t.Nombre=N'Mañana' AND a.DiaSemana=3
)
INSERT INTO AgendaMedico (MedicoId, TurnoTrabajoId, DiaSemana, IsActive)
SELECT m.MedicoId, t.TurnoTrabajoId, 3, 1
FROM Medicos m CROSS JOIN TurnosTrabajo t
WHERE m.Matricula='MAT-1001' AND t.Nombre=N'Mañana';

-- Luis: Lunes y Jueves por la tarde
IF NOT EXISTS (
    SELECT 1 FROM AgendaMedico a
    JOIN Medicos m ON m.MedicoId = a.MedicoId
    JOIN TurnosTrabajo t ON t.TurnoTrabajoId = a.TurnoTrabajoId
    WHERE m.Matricula='MAT-1002' AND t.Nombre=N'Tarde' AND a.DiaSemana=1
)
INSERT INTO AgendaMedico (MedicoId, TurnoTrabajoId, DiaSemana, IsActive)
SELECT m.MedicoId, t.TurnoTrabajoId, 1, 1
FROM Medicos m CROSS JOIN TurnosTrabajo t
WHERE m.Matricula='MAT-1002' AND t.Nombre=N'Tarde';

IF NOT EXISTS (
    SELECT 1 FROM AgendaMedico a
    JOIN Medicos m ON m.MedicoId = a.MedicoId
    JOIN TurnosTrabajo t ON t.TurnoTrabajoId = a.TurnoTrabajoId
    WHERE m.Matricula='MAT-1002' AND t.Nombre=N'Tarde' AND a.DiaSemana=4
)
INSERT INTO AgendaMedico (MedicoId, TurnoTrabajoId, DiaSemana, IsActive)
SELECT m.MedicoId, t.TurnoTrabajoId, 4, 1
FROM Medicos m CROSS JOIN TurnosTrabajo t
WHERE m.Matricula='MAT-1002' AND t.Nombre=N'Tarde';

---------------------------
-- Estados de turno
---------------------------
IF NOT EXISTS (SELECT 1 FROM EstadosTurno WHERE Nombre = 'Nuevo')
    INSERT INTO EstadosTurno (Nombre) VALUES ('Nuevo');
IF NOT EXISTS (SELECT 1 FROM EstadosTurno WHERE Nombre = 'Reprogramado')
    INSERT INTO EstadosTurno (Nombre) VALUES ('Reprogramado');
IF NOT EXISTS (SELECT 1 FROM EstadosTurno WHERE Nombre = 'Cancelado')
    INSERT INTO EstadosTurno (Nombre) VALUES ('Cancelado');
IF NOT EXISTS (SELECT 1 FROM EstadosTurno WHERE Nombre = 'No Asistio')
    INSERT INTO EstadosTurno (Nombre) VALUES ('No Asistio');
IF NOT EXISTS (SELECT 1 FROM EstadosTurno WHERE Nombre = 'Cerrado')
    INSERT INTO EstadosTurno (Nombre) VALUES ('Cerrado');

---------------------------
-- Turnos (ejemplos próximos)
---------------------------
-- María con Ana (Odontología) hoy + 2h
IF NOT EXISTS (
    SELECT 1 FROM Turnos t
    JOIN Pacientes p ON p.PacienteId = t.PacienteId
    JOIN Medicos m ON m.MedicoId = t.MedicoId
    WHERE p.DNI='30111222' AND m.Matricula='MAT-1001'
          AND CONVERT(date, t.Inicio) = CONVERT(date, SYSUTCDATETIME())
)
INSERT INTO Turnos (NumeroTurno, PacienteId, MedicoId, EspecialidadId, Inicio, DuracionMin, Observaciones, EstadoId, ReprogramadoDeId)
SELECT 'T-000001',
       p.PacienteId,
       m.MedicoId,
       e.EspecialidadId,
       DATEADD(HOUR, 2, SYSUTCDATETIME()),
       60,
       N'Control rutina',
       (SELECT EstadoId FROM EstadosTurno WHERE Nombre='Nuevo'),
       NULL
FROM Pacientes p, Medicos m, Especialidades e
WHERE p.DNI='30111222' AND m.Matricula='MAT-1001' AND e.Nombre=N'Odontología';

-- Juan con Luis (Odontología) hoy + 3h
IF NOT EXISTS (
    SELECT 1 FROM Turnos t
    JOIN Pacientes p ON p.PacienteId = t.PacienteId
    JOIN Medicos m ON m.MedicoId = t.MedicoId
    WHERE p.DNI='30999888' AND m.Matricula='MAT-1002'
          AND CONVERT(date, t.Inicio) = CONVERT(date, SYSUTCDATETIME())
)
INSERT INTO Turnos (NumeroTurno, PacienteId, MedicoId, EspecialidadId, Inicio, DuracionMin, Observaciones, EstadoId, ReprogramadoDeId)
SELECT 'T-000002',
       p.PacienteId,
       m.MedicoId,
       e.EspecialidadId,
       DATEADD(HOUR, 3, SYSUTCDATETIME()),
       60,
       N'Primera consulta',
       (SELECT EstadoId FROM EstadosTurno WHERE Nombre='Nuevo'),
       NULL
FROM Pacientes p, Medicos m, Especialidades e
WHERE p.DNI='30999888' AND m.Matricula='MAT-1002' AND e.Nombre=N'Odontología';

---------------------------
-- EmailLog (ejemplo)
---------------------------
IF NOT EXISTS (SELECT 1 FROM EmailLog WHERE Asunto = N'Confirmación de turno T-000001')
INSERT INTO EmailLog (TurnoId, ParaEmail, Asunto, Cuerpo, EstadoEnvio)
SELECT t.TurnoId, p.Email,
       N'Confirmación de turno T-000001',
       N'Estimado/a, su turno ha sido confirmado.',
       N'Enviado'
FROM Turnos t
JOIN Pacientes p ON p.PacienteId = t.PacienteId
WHERE t.NumeroTurno = 'T-000001';

IF NOT EXISTS (SELECT 1 FROM EmailLog WHERE Asunto = N'Confirmación de turno T-000002')
INSERT INTO EmailLog (TurnoId, ParaEmail, Asunto, Cuerpo, EstadoEnvio)
SELECT t.TurnoId, p.Email,
       N'Confirmación de turno T-000002',
       N'Estimado/a, su turno ha sido confirmado.',
       N'Enviado'
FROM Turnos t
JOIN Pacientes p ON p.PacienteId = t.PacienteId
WHERE t.NumeroTurno = 'T-000002';
