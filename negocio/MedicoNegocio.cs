using dominio.objects;
using negocio.DataAccess;
using System;
using System.Collections.Generic;
using System.Data;

namespace negocio
{
    public class MedicoNegocio
    {
        const string consultaListar = @"
SELECT MedicoId, Matricula, Nombre, Apellido, Email, Telefono, IsActive, CreatedAt
FROM Medicos
ORDER BY Apellido, Nombre;";

        const string consultaObtenerPorId = @"
SELECT MedicoId, Matricula, Nombre, Apellido, Email, Telefono, IsActive, CreatedAt
FROM Medicos
WHERE MedicoId = @id;";

        const string consultaBuscarPorMatricula = @"
SELECT TOP 1 MedicoId, Matricula, Nombre, Apellido, Email, Telefono, IsActive, CreatedAt
FROM Medicos
WHERE Matricula = @matricula;";

        const string consultaCrear = @"
INSERT INTO Medicos (Matricula, Nombre, Apellido, Email, Telefono, IsActive)
VALUES (@matricula, @nombre, @apellido, @email, @tel, @isActive);
SELECT CAST(SCOPE_IDENTITY() AS INT);";

        const string consultaActualizar = @"
UPDATE Medicos
SET Matricula=@matricula, Nombre=@nombre, Apellido=@apellido,
    Email=@email, Telefono=@tel, IsActive=@isActive
WHERE MedicoId=@id;";

        const string existeMatricula = @"
SELECT 1
FROM Medicos
WHERE Matricula = @matricula
  AND (@excludeId IS NULL OR MedicoId <> @excludeId);";

        #region Lectura

        public List<Medico> Listar(string filtro = null, bool soloActivos = true)
        {
            List<Medico> lista = new List<Medico>();
            try
            {
                if (filtro == null)
                {
                    AccesoDB db = new AccesoDB();

                    db.setearConsulta(consultaListar);
                    db.ejecutarLectura();
                    while (db.Lector.Read())
                    {
                        Medico aux = new Medico();
                        aux.MedicoId = (int)db.Lector["MedicoId"];
                        aux.Matricula = (string)db.Lector["Matricula"];
                        aux.Nombre = (string)db.Lector["Nombre"];
                        aux.Apellido = (string)db.Lector["Apellido"];
                        aux.Email = (db.Lector["Email"] != DBNull.Value) ? (string)db.Lector["Email"] : string.Empty;
                        aux.Telefono = (db.Lector["Telefono"] != DBNull.Value) ? (string)db.Lector["Telefono"] : string.Empty;
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

        public Medico ObtenerPorId(int medicoId)
        {
            Medico medico = new Medico();
            try
            {
                AccesoDB db = new AccesoDB();
                db.setearConsulta(consultaObtenerPorId);
                db.setearParametro("@id", medicoId);
                db.ejecutarLectura();
                while (db.Lector.Read())
                {
                    medico.MedicoId = (int)db.Lector["MedicoId"];
                    medico.Matricula = (string)db.Lector["Matricula"];
                    medico.Nombre = (string)db.Lector["Nombre"];
                    medico.Apellido = (string)db.Lector["Apellido"];
                    medico.Email = (db.Lector["Email"] != DBNull.Value) ? (string)db.Lector["Email"] : string.Empty;
                    medico.Telefono = (db.Lector["Telefono"] != DBNull.Value) ? (string)db.Lector["Telefono"] : string.Empty;
                    medico.IsActive = (bool)db.Lector["IsActive"];
                    medico.CreatedAt = (DateTime)db.Lector["CreatedAt"];
                }
            }
            catch (Exception)
            {
                throw;
            }
            return medico;
        }

        public Medico BuscarPorMatricula(string matricula)
        {
            Medico medico = new Medico();
            try
            {
                AccesoDB db = new AccesoDB();
                db.setearConsulta(consultaBuscarPorMatricula);
                db.setearParametro("@matricula", matricula);
                db.ejecutarLectura();
                while (db.Lector.Read())
                {
                    medico.MedicoId = (int)db.Lector["MedicoId"];
                    medico.Matricula = (string)db.Lector["Matricula"];
                    medico.Nombre = (string)db.Lector["Nombre"];
                    medico.Apellido = (string)db.Lector["Apellido"];
                    medico.Email = (db.Lector["Email"] != DBNull.Value) ? (string)db.Lector["Email"] : string.Empty;
                    medico.Telefono = (db.Lector["Telefono"] != DBNull.Value) ? (string)db.Lector["Telefono"] : string.Empty;
                    medico.IsActive = (bool)db.Lector["IsActive"];
                    medico.CreatedAt = (DateTime)db.Lector["CreatedAt"];
                }
            }
            catch (Exception)
            {
                throw;
            }
            return medico;
        }

        #endregion

        #region Escritura

        public int Crear(Medico m)
        {
            try
            {
                AccesoDB db = new AccesoDB();

                db.setearParametro("@matricula", m.Matricula);
                db.setearParametro("@nombre", m.Nombre);
                db.setearParametro("@apellido", m.Apellido);

                if (m.Email != null)
                    db.setearParametro("@email", m.Email);
                else
                    db.setearParametro("@email", DBNull.Value);

                if (m.Telefono != null)
                    db.setearParametro("@tel", m.Telefono);
                else
                    db.setearParametro("@tel", DBNull.Value);

                db.setearParametro("@isActive", m.IsActive);

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

        public void Actualizar(Medico m)
        {
            try
            {
                AccesoDB db = new AccesoDB();

                db.setearParametro("@matricula", m.Matricula);
                db.setearParametro("@nombre", m.Nombre);
                db.setearParametro("@apellido", m.Apellido);

                if (m.Email != null)
                    db.setearParametro("@email", m.Email);
                else
                    db.setearParametro("@email", DBNull.Value);

                if (m.Telefono != null)
                    db.setearParametro("@tel", m.Telefono);
                else
                    db.setearParametro("@tel", DBNull.Value);

                db.setearParametro("@isActive", m.IsActive);
                db.setearParametro("@id", m.MedicoId);

                db.setearConsulta(consultaActualizar);
                db.ejecutarAccion();
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        #region Validaciones

        public bool ExisteMatricula(string matricula, int? excludeId = null)
        {
            try
            {
                AccesoDB db = new AccesoDB();
                db.setearParametro("@matricula", matricula);
                if (excludeId.HasValue)
                    db.setearParametro("@excludeId", excludeId.Value);
                else
                    db.setearParametro("@excludeId", DBNull.Value);

                db.setearConsulta(existeMatricula);
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
