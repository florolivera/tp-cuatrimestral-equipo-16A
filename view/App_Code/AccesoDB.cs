using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Datos
{
    /// <summary>
    /// Acceso a SQL Server simple para todo el proyecto.
    /// Uso tipico:
    ///   using (var db = new AccesoDB()) {
    ///       db.SetConsulta("SELECT * FROM Especialidades WHERE IsActive=1");
    ///       db.EjecutarLectura();
    ///       while (db.Lector.Read()) { /* leer campos */ }
    ///   }
    /// </summary>
    public class AccesoDB : IDisposable
    {
        private readonly SqlConnection _conn;
        private readonly SqlCommand _cmd;
        private SqlDataReader _reader;
        private SqlTransaction _tx;

        public SqlDataReader Lector => _reader;

        public AccesoDB()
        {
            var cs = ConfigurationManager.ConnectionStrings["ClinicaDb"]?.ConnectionString
                     ?? throw new Exception("Falta connectionString ClinicaDb en Web.config");
            _conn = new SqlConnection(cs);
            _cmd = new SqlCommand { Connection = _conn, CommandTimeout = 30, CommandType = CommandType.Text };
        }

        /* Texto SQL plano (SELECT/INSERT/UPDATE/DELETE) */
        public void SetConsulta(string sql)
        {
            _cmd.Parameters.Clear();
            _cmd.CommandType = CommandType.Text;
            _cmd.CommandText = sql;
        }

        /* Stored Procedure */
        public void SetSP(string nombreSp)
        {
            _cmd.Parameters.Clear();
            _cmd.CommandType = CommandType.StoredProcedure;
            _cmd.CommandText = nombreSp;
        }

        /* Parametros seguros (evita concatenar SQL) */
        public void AgregarParametro(string nombre, object valor)
        {
            _cmd.Parameters.AddWithValue(nombre, valor ?? DBNull.Value);
        }

        /* Ejecuta un SELECT y deja listo el SqlDataReader para recorrer */
        public void EjecutarLectura()
        {
            Abrir();
            _reader = _cmd.ExecuteReader();
        }

        /* Ejecuta INSERT/UPDATE/DELETE y devuelve filas afectadas */
        public int EjecutarAccion()
        {
            Abrir();
            return _cmd.ExecuteNonQuery();
        }

        /* Ejecuta y devuelve un solo valor (ej: COUNT, SCOPE_IDENTITY) */
        public object EjecutarEscalar()
        {
            Abrir();
            return _cmd.ExecuteScalar();
        }

        /* Transacciones (para operaciones multiples atomicas) */
        public void BeginTran()
        {
            Abrir();
            _tx = _conn.BeginTransaction();
            _cmd.Transaction = _tx;
        }

        public void Commit()
        {
            _tx?.Commit();
            _tx = null;
            _cmd.Transaction = null;
        }

        public void Rollback()
        {
            if (_tx != null)
            {
                _tx.Rollback();
                _tx = null;
                _cmd.Transaction = null;
            }
        }

        private void Abrir()
        {
            if (_conn.State != ConnectionState.Open)
                _conn.Open();
        }

        public void Cerrar()
        {
            if (_reader != null && !_reader.IsClosed) _reader.Close();
            if (_conn.State == ConnectionState.Open) _conn.Close();
        }

        public void Dispose()
        {
            Cerrar();
            _reader?.Dispose();
            _cmd?.Dispose();
            _conn?.Dispose();
        }
    }
}
