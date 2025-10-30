<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TurnosTrabajo.aspx.cs" Inherits="view.TurnosTrabajo" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Turnos de trabajo</asp:Content>
<asp:Content ContentPlaceHolderID="PageHeader" runat="server">Turnos de trabajo</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="row g-3">
    <div class="col-12 col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <h6 class="mb-3">Nuevo / Editar turno</h6>
          <div class="mb-2">
            <label class="form-label">Nombre</label>
            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
          </div>
          <div class="mb-2">
            <label class="form-label">Entrada</label>
            <asp:TextBox ID="txtEntrada" runat="server" CssClass="form-control" TextMode="Time" />
          </div>
          <div class="mb-3">
            <label class="form-label">Salida</label>
            <asp:TextBox ID="txtSalida" runat="server" CssClass="form-control" TextMode="Time" />
          </div>
          <asp:HiddenField ID="hfTurnoId" runat="server" />
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
          <asp:GridView ID="gvTurnos" runat="server" CssClass="table table-sm table-striped"
              AutoGenerateColumns="false" DataKeyNames="TurnoTrabajoId" OnSelectedIndexChanged="gvTurnos_SelectedIndexChanged">
            <Columns>
              <asp:BoundField HeaderText="ID" DataField="TurnoTrabajoId" />
              <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
              <asp:BoundField HeaderText="Entrada" DataField="HoraEntrada" />
              <asp:BoundField HeaderText="Salida" DataField="HoraSalida" />
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