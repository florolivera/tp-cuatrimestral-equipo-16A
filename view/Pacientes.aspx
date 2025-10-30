<%@ Page Title="Pacientes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Pacientes.aspx.cs" Inherits="view.Pacientes" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Pacientes</asp:Content>
<asp:Content ContentPlaceHolderID="PageHeader" runat="server">Pacientes</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="row g-3">
    <div class="col-12 col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h5 class="card-title h6">Nuevo / Editar paciente</h5>
          <asp:ValidationSummary ID="vsPac" runat="server" CssClass="text-danger small" />
          <div class="mb-2">
            <label class="form-label">DNI</label>
            <asp:TextBox ID="txtDni" runat="server" CssClass="form-control" />
            <asp:RequiredFieldValidator ControlToValidate="txtDni" runat="server" CssClass="text-danger small" ErrorMessage="Obligatorio" />
          </div>
          <div class="mb-2">
            <label class="form-label">Nombre</label>
            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
            <asp:RequiredFieldValidator ControlToValidate="txtNombre" runat="server" CssClass="text-danger small" ErrorMessage="Obligatorio" />
          </div>
          <div class="mb-2">
            <label class="form-label">Apellido</label>
            <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" />
            <asp:RequiredFieldValidator ControlToValidate="txtApellido" runat="server" CssClass="text-danger small" ErrorMessage="Obligatorio" />
          </div>
          <div class="mb-2">
            <label class="form-label">Fecha Nac.</label>
            <asp:TextBox ID="txtFechaNac" runat="server" CssClass="form-control" TextMode="Date" />
          </div>
          <div class="mb-2">
            <label class="form-label">Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
          </div>
          <div class="mb-2">
            <label class="form-label">Teléfono</label>
            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" />
          </div>
          <div class="mb-3">
            <label class="form-label">Dirección</label>
            <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
          </div>
          <asp:HiddenField ID="hfPacienteId" runat="server" />
          <div class="d-flex gap-2">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary btn-sm" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-outline-secondary btn-sm" OnClick="btnCancelar_Click" CausesValidation="false" />
          </div>
        </div>
      </div>
    </div>

    <div class="col-12 col-lg-8">
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-center mb-2">
            <h5 class="card-title h6 mb-0">Listado</h5>
            <div class="input-group input-group-sm" style="max-width:280px;">
              <span class="input-group-text">Buscar</span>
              <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" />
              <button type="button" class="btn btn-outline-primary" runat="server" onserverclick="btnBuscar_ServerClick">Ir</button>
            </div>
          </div>
          <asp:GridView ID="gvPacientes" runat="server" CssClass="table table-sm table-striped"
              AutoGenerateColumns="false" DataKeyNames="PacienteId"
              OnSelectedIndexChanged="gvPacientes_SelectedIndexChanged"
              OnPageIndexChanging="gvPacientes_PageIndexChanging" AllowPaging="true" PageSize="10">
            <Columns>
              <asp:BoundField HeaderText="ID" DataField="PacienteId" />
              <asp:BoundField HeaderText="DNI" DataField="DNI" />
              <asp:BoundField HeaderText="Apellido" DataField="Apellido" />
              <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
              <asp:BoundField HeaderText="Email" DataField="Email" />
              <asp:TemplateField>
                <ItemTemplate>
                  <asp:LinkButton ID="lnkSel" runat="server" CommandName="Select" CssClass="btn btn-link btn-sm">Editar</asp:LinkButton>
                </ItemTemplate>
              </asp:TemplateField>
            </Columns>
          </asp:GridView>
        </div>
      </div>
    </div>
  </div>
</asp:Content>