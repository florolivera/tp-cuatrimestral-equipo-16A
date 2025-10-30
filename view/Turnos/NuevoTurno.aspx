<%@ Page Title="Nuevo turno" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NuevoTurno.aspx.cs" Inherits="view.Turnos.NuevoTurno" %>
<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Nuevo turno</asp:Content>
<asp:Content ContentPlaceHolderID="PageHeader" runat="server">Nuevo turno</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="card shadow-sm">
    <div class="card-body">
      <asp:ValidationSummary ID="vs" runat="server" CssClass="text-danger small" />
      <div class="row g-3">
        <div class="col-12 col-md-4">
          <label class="form-label">Paciente</label>
          <asp:DropDownList ID="ddlPaciente" runat="server" CssClass="form-select" />
          <asp:RequiredFieldValidator ControlToValidate="ddlPaciente" runat="server" InitialValue="" ErrorMessage="Seleccione paciente" CssClass="text-danger small" />
        </div>
        <div class="col-12 col-md-4">
          <label class="form-label">Especialidad</label>
          <asp:DropDownList ID="ddlEspecialidad" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEspecialidad_SelectedIndexChanged" />
        </div>
        <div class="col-12 col-md-4">
          <label class="form-label">Médico</label>
          <asp:DropDownList ID="ddlMedico" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlMedico_SelectedIndexChanged" />
        </div>

        <div class="col-12 col-md-3">
          <label class="form-label">Fecha</label>
          <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" TextMode="Date" AutoPostBack="true" OnTextChanged="txtFecha_TextChanged" />
        </div>
        <div class="col-12 col-md-3">
          <label class="form-label">Hora (sugerida)</label>
          <asp:DropDownList ID="ddlHora" runat="server" CssClass="form-select" />
        </div>
        <div class="col-12 col-md-6">
          <label class="form-label">Observaciones</label>
          <asp:TextBox ID="txtObs" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
        </div>
      </div>

      <div class="mt-3 d-flex gap-2">
        <asp:Button ID="btnSugerir" runat="server" Text="Sugerir horarios" CssClass="btn btn-outline-primary btn-sm" OnClick="btnSugerir_Click" />
        <asp:Button ID="btnGuardar" runat="server" Text="Confirmar turno" CssClass="btn btn-primary btn-sm" OnClick="btnGuardar_Click" />
        <a runat="server" href="~/Turnos/ListadoTurnos.aspx" class="btn btn-light btn-sm">Volver al listado</a>
      </div>

      <asp:Panel ID="pnlSugerencias" runat="server" CssClass="mt-3" Visible="false">
        <h6 class="mb-2">Sugerencias</h6>
        <asp:Repeater ID="rptSugerencias" runat="server">
          <HeaderTemplate><ul class="list-group list-group-flush"></HeaderTemplate>
          <ItemTemplate>
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <span><%# Eval("InicioPropuesto","{0:dd/MM/yyyy HH:mm}") %> — <%# Eval("Medico") %></span>
              <asp:LinkButton ID="lnkUsar" runat="server" CommandName="usar" CommandArgument='<%# Eval("InicioPropuesto","{0:O}") + "|" + Eval("MedicoId") %>' CssClass="btn btn-sm btn-outline-primary">Usar</asp:LinkButton>
            </li>
          </ItemTemplate>
          <FooterTemplate></ul></FooterTemplate>
        </asp:Repeater>
      </asp:Panel>
    </div>
  </div>
</asp:Content>
