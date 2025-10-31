using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio.objects
{
    public class Paciente
    {
        public int PacienteId { get; set; }
        public string DNI { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string Apellido { get; set; } = string.Empty;
        public System.DateTime? FechaNac { get; set; }
        public string Email { get; set; } = string.Empty;
        public string Telefono { get; set; } = string.Empty;
        public string Direccion { get; set; } = string.Empty;
        public bool IsActive { get; set; } = true;
        public System.DateTime CreatedAt { get; set; }

        public string NombreCompleto => $"{Nombre} {Apellido}";
    }
}
