using dominio.objects;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace view.Turnos
{
    public partial class NuevoTurno : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PacienteNegocio n = new PacienteNegocio();
            List<Paciente> lista = n.Listar();
            ddlPaciente.DataSource = lista;
            ddlPaciente.DataTextField = "NombreCompleto"; 
            ddlPaciente.DataValueField = "PacienteId";    
            ddlPaciente.DataBind();
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {

        }

        protected void btnSugerir_Click(object sender, EventArgs e)
        {

        }

        protected void txtFecha_TextChanged(object sender, EventArgs e)
        {

        }

        protected void ddlMedico_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void ddlEspecialidad_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}