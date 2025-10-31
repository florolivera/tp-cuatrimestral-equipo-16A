using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio.objects
{
    public class Medico
    {
        public int MedicoId { get; set; }
        public string Matricula { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string Apellido { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Telefono { get; set; } = string.Empty;
        public bool IsActive { get; set; } = true;
        public System.DateTime CreatedAt { get; set; }

        public string NombreCompleto => $"{Nombre} {Apellido}";

        public System.Collections.Generic.List<Especialidad> Especialidades { get; set; } = new();
    }
}
