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
