<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Especialidades.aspx.cs" Inherits="view.Especialidades" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Especialidades</asp:Content>
<asp:Content ContentPlaceHolderID="PageHeader" runat="server">Especialidades</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="row g-3">
    <div class="col-12 col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h6 class="mb-3">Nueva / Editar especialidad</h6>
          <div class="mb-2">
            <label class="form-label">Nombre</label>
            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
            <asp:RequiredFieldValidator ControlToValidate="txtNombre" runat="server" CssClass="text-danger small" ErrorMessage="Obligatorio" />
          </div>
          <div class="mb-3">
            <label class="form-label">Descripción</label>
            <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
          </div>
          <asp:HiddenField ID="hfEspId" runat="server" />
          <div class="d-flex gap-2">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary btn-sm" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-outline-secondary btn-sm" CausesValidation="false" OnClick="btnCancelar_Click" />
          </div>
        </div>
      </div>
    </div>

    <div class="col-12 col-lg-8">
      <div class="card shadow-sm">
        <div class="card-body">
          <asp:GridView ID="gvEsp" runat="server" CssClass="table table-sm table-striped"
              AutoGenerateColumns="false" DataKeyNames="EspecialidadId"
              OnSelectedIndexChanged="gvEsp_SelectedIndexChanged">
            <Columns>
              <asp:BoundField HeaderText="ID" DataField="EspecialidadId" />
              <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
              <asp:BoundField HeaderText="Descripción" DataField="Descripcion" />
              <asp:CheckBoxField HeaderText="Activa" DataField="IsActive" />
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