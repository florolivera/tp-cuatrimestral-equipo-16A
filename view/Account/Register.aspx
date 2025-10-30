<%@ Page Title="Registrarse" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="view.Account.Register" %>
<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Registrarse</asp:Content>
<asp:Content ContentPlaceHolderID="PageHeader" runat="server">Registrarse</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="row justify-content-center">
    <div class="col-12 col-md-6 col-lg-5">
      <div class="card shadow-sm">
        <div class="card-body">
          <asp:ValidationSummary ID="vs" runat="server" CssClass="text-danger small" />
          <div class="mb-2">
            <label class="form-label">Usuario</label>
            <asp:TextBox ID="txtUser" runat="server" CssClass="form-control" />
          </div>
          <div class="mb-2">
            <label class="form-label">Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" />
          </div>
          <div class="mb-2">
            <label class="form-label">Contraseña</label>
            <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" TextMode="Password" />
          </div>
          <div class="mb-3">
            <label class="form-label">Rol</label>
            <asp:DropDownList ID="ddlRol" runat="server" CssClass="form-select">
              <asp:ListItem Text="Recepcion" Value="2"></asp:ListItem>
              <asp:ListItem Text="Medico" Value="3"></asp:ListItem>
            </asp:DropDownList>
          </div>
          <asp:Button ID="btnReg" runat="server" Text="Crear cuenta" CssClass="btn btn-primary w-100" OnClick="btnReg_Click" />
        </div>
      </div>
    </div>
  </div>
</asp:Content>
