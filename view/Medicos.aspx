<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Medicos.aspx.cs" Inherits="view.Medicos" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Médicos</asp:Content>
<asp:Content ContentPlaceHolderID="PageHeader" runat="server">Médicos</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="row g-3">
    <div class="col-12 col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h6 class="mb-3">Nuevo / Editar médico</h6>
          <asp:ValidationSummary ID="vsDoc" runat="server" CssClass="text-danger small" />
          <div class="mb-2">
            <label class="form-label">Matrícula</label>
            <asp:TextBox ID="txtMatricula" runat="server" CssClass="form-control" />
            <asp:RequiredFieldValidator ControlToValidate="txtMatricula" runat="server" CssClass="text-danger small" ErrorMessage="Obligatorio" />
          </div>
          <div class="mb-2">
            <label class="form-label">Nombre</label>
            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
          </div>
          <div class="mb-2">
            <label class="form-label">Apellido</label>
            <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" />
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
            <label class="form-label">Especialidades</label>
            <asp:CheckBoxList ID="cblEspecialidades" runat="server" CssClass="form-check"
                RepeatLayout="Flow" RepeatDirection="Vertical" />
          </div>
          <asp:HiddenField ID="hfMedicoId" runat="server" />
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
            <h6 class="mb-0">Listado</h6>
            <div class="input-group input-group-sm" style="max-width:280px;">
              <span class="input-group-text">Buscar</span>
              <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" />
              <button runat="server" onserverclick="btnBuscar_ServerClick" class="btn btn-outline-primary">Ir</button>
            </div>
          </div>

          <asp:GridView ID="gvMedicos" runat="server" CssClass="table table-sm table-striped"
              AutoGenerateColumns="false" DataKeyNames="MedicoId"
              OnSelectedIndexChanged="gvMedicos_SelectedIndexChanged"
              AllowPaging="true" PageSize="10" OnPageIndexChanging="gvMedicos_PageIndexChanging">
            <Columns>
              <asp:BoundField HeaderText="ID" DataField="MedicoId" />
              <asp:BoundField HeaderText="Matrícula" DataField="Matricula" />
              <asp:BoundField HeaderText="Apellido" DataField="Apellido" />
              <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
              <asp:BoundField HeaderText="Email" DataField="Email" />
              <asp:TemplateField HeaderText="Especialidades">
                <ItemTemplate>
                  <%# Eval("EspecialidadesCsv") %>
                </ItemTemplate>
              </asp:TemplateField>
              <asp:TemplateField>
                <ItemTemplate>
                  <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Select" CssClass="btn btn-link btn-sm">Editar</asp:LinkButton>
                </ItemTemplate>
              </asp:TemplateField>
            </Columns>
          </asp:GridView>
        </div>
      </div>
    </div>
  </div>
</asp:Content>
