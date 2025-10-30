<%@ Page Title="Listado de turnos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ListadoTurnos.aspx.cs" Inherits="view.Turnos.ListadoTurnos" %>
<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Turnos</asp:Content>
<asp:Content ContentPlaceHolderID="PageHeader" runat="server">Turnos</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="card shadow-sm">
    <div class="card-body">
      <div class="row g-2 align-items-end">
        <div class="col-6 col-md-3">
          <label class="form-label">Desde</label>
          <asp:TextBox ID="txtDesde" runat="server" CssClass="form-control" TextMode="Date" />
        </div>
        <div class="col-6 col-md-3">
          <label class="form-label">Hasta</label>
          <asp:TextBox ID="txtHasta" runat="server" CssClass="form-control" TextMode="Date" />
        </div>
        <div class="col-12 col-md-3">
          <label class="form-label">Estado</label>
          <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select" />
        </div>
        <div class="col-12 col-md-3 d-grid d-md-block">
          <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-primary" OnClick="btnFiltrar_Click" />
          <a runat="server" href="~/Turnos/NuevoTurno.aspx" class="btn btn-outline-primary ms-md-2">Nuevo turno</a>
        </div>
      </div>

      <hr />
      <asp:GridView ID="gvTurnos" runat="server" CssClass="table table-sm table-striped"
          AutoGenerateColumns="false" DataKeyNames="TurnoId">
        <Columns>
          <asp:BoundField HeaderText="#" DataField="NumeroTurno" />
          <asp:BoundField HeaderText="Fecha" DataField="Inicio" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
          <asp:BoundField HeaderText="Paciente" DataField="Paciente" />
          <asp:BoundField HeaderText="Médico" DataField="Medico" />
          <asp:BoundField HeaderText="Especialidad" DataField="Especialidad" />
          <asp:BoundField HeaderText="Estado" DataField="Estado" />
          <asp:TemplateField>
            <ItemTemplate>
              <asp:LinkButton ID="lnkReprogramar" runat="server" CommandName="reprog" CommandArgument='<%# Eval("TurnoId") %>' CssClass="btn btn-link btn-sm">Reprogramar</asp:LinkButton>
              <asp:LinkButton ID="lnkCancelar" runat="server" CommandName="cancel" CommandArgument='<%# Eval("TurnoId") %>' CssClass="btn btn-link btn-sm text-danger">Cancelar</asp:LinkButton>
            </ItemTemplate>
          </asp:TemplateField>
        </Columns>
      </asp:GridView>
    </div>
  </div>
</asp:Content>
