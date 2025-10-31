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
        public string Matricula { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Email { get; set; } 
        public string Telefono { get; set; } 
        public bool IsActive { get; set; } = true;
        public System.DateTime CreatedAt { get; set; }

        public string NombreCompleto => $"{Nombre} {Apellido}";

        public System.Collections.Generic.List<Especialidad> Especialidades { get; set; }
    }
}
