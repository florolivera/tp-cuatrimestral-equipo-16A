using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio.objects
{
    public class Turno
    {
        public int Id { get; set; }

        public Paciente Paciente { get; set; }
        public Medico Medico { get; set; }
        public Especialidad Especialidad { get; set; }

        public System.DateTime Inicio { get; set; }           
        public int DuracionMin { get; set; } = 60;
        public string Observaciones { get; set; } 
        public int ReprogramadoDeId { get; set; }
        public System.DateTime CreatedAt { get; set; }
        public System.DateTime? UpdatedAt { get; set; }
        public System.DateTime Fin => Inicio.AddMinutes(DuracionMin);
    }
}
