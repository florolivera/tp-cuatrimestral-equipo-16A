using dominio.objects;
using negocio.DataAccess;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace negocio
{
    public class PacienteNegocio
    {
        const string consultaListar = @"
SELECT PacienteId, DNI, Nombre, Apellido, FechaNac, Email, Telefono, Direccion, IsActive, CreatedAt
FROM Pacientes
ORDER BY Apellido, Nombre;";
        const string consultaObtenerPorId = @"
SELECT PacienteId, DNI, Nombre, Apellido, FechaNac, Email, Telefono, Direccion, IsActive, CreatedAt
FROM Pacientes
WHERE PacienteId = @id;";
        const string consultaBuscarPorDni = @"
SELECT TOP 1 PacienteId, DNI, Nombre, Apellido, FechaNac, Email, Telefono, Direccion, IsActive, CreatedAt
FROM Pacientes
WHERE DNI = @dni;";
        const string consultaCrear =@"
INSERT INTO Pacientes (DNI, Nombre, Apellido, FechaNac, Email, Telefono, Direccion, IsActive)
VALUES (@dni, @nombre, @apellido, @fechaNac, @email, @tel, @dir, @isActive);
SELECT CAST(SCOPE_IDENTITY() AS INT);";
        const string consultaActualizar = @"
UPDATE Pacientes
SET DNI=@dni, Nombre=@nombre, Apellido=@apellido, FechaNac=@fechaNac,
    Email=@email, Telefono=@tel, Direccion=@dir, IsActive=@isActive
WHERE PacienteId=@id;";
        const string existeDni = @"
SELECT 1
FROM Pacientes
WHERE DNI = @dni
  AND (@excludeId IS NULL OR PacienteId <> @excludeId);";

        #region Lectura

        public List<Paciente> Listar(string filtro = null, bool soloActivos = true)
        {
            List<Paciente> lista = new List<Paciente>();
            try
            {
                if (filtro == null)
                {
                    AccesoDB db = new AccesoDB();

                    db.setearConsulta(consultaListar);
                    db.ejecutarLectura();
                    while (db.Lector.Read())
                    {
                        Paciente aux = new Paciente();
                        aux.PacienteId = (int)db.Lector["PacienteId"];
                        aux.DNI = (string)db.Lector["DNI"];
                        aux.Nombre = (string)db.Lector["Nombre"];
                        aux.Apellido = (string)db.Lector["Apellido"];
                        aux.FechaNac = (db.Lector["FechaNac"] != DBNull.Value) ? (DateTime?)db.Lector["FechaNac"] : null;
                        aux.Email = (db.Lector["Email"] != DBNull.Value) ? (string)db.Lector["Email"] : string.Empty;
                        aux.Telefono = (db.Lector["Telefono"] != DBNull.Value) ? (string)db.Lector["Telefono"] : string.Empty;
                        aux.Direccion = (db.Lector["Direccion"] != DBNull.Value) ? (string)db.Lector["Direccion"] : string.Empty;
                        aux.IsActive = (bool)db.Lector["IsActive"];
                        aux.CreatedAt = (DateTime)db.Lector["CreatedAt"];
                        if (soloActivos)
                        {
                            lista.Add(aux);
                        }
                    }
                }

            }
            catch (Exception e)
            {
                throw e;
            }
            return lista;
        }

        public Paciente ObtenerPorId(int pacienteId)
        {
            Paciente paciente = new Paciente();
            try
            {
                AccesoDB db = new AccesoDB();
                db.setearConsulta(consultaObtenerPorId);
                db.setearParametro("@id", pacienteId);
                db.ejecutarLectura();
                while (db.Lector.Read())
                {
                    paciente.PacienteId = (int)db.Lector["PacienteId"];
                    paciente.DNI = (string)db.Lector["DNI"];
                    paciente.Nombre = (string)db.Lector["Nombre"];
                    paciente.Apellido = (string)db.Lector["Apellido"];
                    paciente.FechaNac = (db.Lector["FechaNac"] != DBNull.Value) ? (DateTime?)db.Lector["FechaNac"] : null;
                    paciente.Email = (db.Lector["Email"] != DBNull.Value) ? (string)db.Lector["Email"] : string.Empty;
                    paciente.Telefono = (db.Lector["Telefono"] != DBNull.Value) ? (string)db.Lector["Telefono"] : string.Empty;
                    paciente.Direccion = (db.Lector["Direccion"] != DBNull.Value) ? (string)db.Lector["Direccion"] : string.Empty;
                    paciente.IsActive = (bool)db.Lector["IsActive"];
                    paciente.CreatedAt = (DateTime)db.Lector["CreatedAt"];

                }

            }
            catch (Exception)
            {

                throw;
            }
            return paciente;
        }

        public Paciente BuscarPorDni(string dni)
        {
            Paciente paciente = new Paciente();
            try
            {
                AccesoDB db = new AccesoDB();
                db.setearConsulta(consultaBuscarPorDni);
                db.setearParametro("@id", dni);
                db.ejecutarLectura();
                while (db.Lector.Read())
                {
                    paciente.PacienteId = (int)db.Lector["PacienteId"];
                    paciente.DNI = (string)db.Lector["DNI"];
                    paciente.Nombre = (string)db.Lector["Nombre"];
                    paciente.Apellido = (string)db.Lector["Apellido"];
                    paciente.FechaNac = (db.Lector["FechaNac"] != DBNull.Value) ? (DateTime?)db.Lector["FechaNac"] : null;
                    paciente.Email = (db.Lector["Email"] != DBNull.Value) ? (string)db.Lector["Email"] : string.Empty;
                    paciente.Telefono = (db.Lector["Telefono"] != DBNull.Value) ? (string)db.Lector["Telefono"] : string.Empty;
                    paciente.Direccion = (db.Lector["Direccion"] != DBNull.Value) ? (string)db.Lector["Direccion"] : string.Empty;
                    paciente.IsActive = (bool)db.Lector["IsActive"];
                    paciente.CreatedAt = (DateTime)db.Lector["CreatedAt"];

                }

            }
            catch (Exception)
            {

                throw;
            }
            return paciente;
        }
        

        #endregion

        #region Escritura

        public int Crear(Paciente p)
        {
            try
            {
                AccesoDB db = new AccesoDB();

                db.setearParametro("@dni", p.DNI);
                db.setearParametro("@nombre", p.Nombre);
                db.setearParametro("@apellido", p.Apellido);
                db.setearParametro("@fechaNac", p.FechaNac);
                if (p.Email != null)
                {
                    db.setearParametro("@email", p.Email);
                }
                else
                {
                    db.setearParametro("@email", DBNull.Value);
                }
                if (p.Telefono != null)
                {
                    db.setearParametro("@tel", p.Telefono);
                }
                else
                {
                    db.setearParametro("@tel", DBNull.Value);
                }
                if (p.Direccion != null)
                {
                    db.setearParametro("@dir", p.Direccion);
                }
                else
                {
                    db.setearParametro("@dir", DBNull.Value);
                }
                db.setearParametro("@isActive", p.IsActive);
                db.setearConsulta(consultaCrear);
                db.ejecutarLectura();
                int newId = db.ejecutarAccionScalar();
                return newId;
            }
            catch (Exception)
            {

                throw;
            }
            
        }

        public void Actualizar(Paciente p)
        {
            try
            {
                AccesoDB db = new AccesoDB();
                db.setearParametro("@dni", p.DNI);
                db.setearParametro("@nombre", p.Nombre);
                db.setearParametro("@apellido", p.Apellido);
                db.setearParametro("@fechaNac", p.FechaNac);
                if(p.Email != null) { 
                    db.setearParametro("@email", p.Email);
                }
                else
                {
                    db.setearParametro("@email", DBNull.Value);
                }
                if(p.Telefono != null)
                {
                    db.setearParametro("@tel", p.Telefono);
                }
                else
                {
                    db.setearParametro("@tel", DBNull.Value);
                }
                if(p.Direccion != null)
                {
                    db.setearParametro("@dir", p.Direccion);
                }
                else
                {
                    db.setearParametro("@dir", DBNull.Value);
                }
                db.setearParametro("@isActive", p.IsActive);
                db.setearParametro("@id", p.PacienteId);
                db.setearConsulta(consultaActualizar);
                db.ejecutarAccion();
            }
            catch (Exception)
            {
                throw;
            }

        }


        /// <summary>
        /// Reactivar: IsActive = 1
        /// </summary>

        #endregion

        #region Validaciones

        public bool ExisteDni(string dni)
        {
            try
            {
                DataAccess.AccesoDB db = new DataAccess.AccesoDB();
                db.setearParametro("@dni", dni);
                db.setearConsulta(existeDni);
                db.ejecutarLectura();
                return db.Lector.Read();
            }
            catch (Exception)
            {

                return false;
            }
        }
        #endregion
    }
}
