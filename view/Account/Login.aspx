<%@ Page Title="Ingresar" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="view.Account.Login" %>
<asp:Content ContentPlaceHolderID="TitleContent" runat="server">Ingresar</asp:Content>
<asp:Content ContentPlaceHolderID="PageHeader" runat="server">Ingresar</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
  <div class="row justify-content-center">
    <div class="col-12 col-md-6 col-lg-4">
      <div class="card shadow-sm">
        <div class="card-body">
          <asp:ValidationSummary ID="vs" runat="server" CssClass="text-danger small" />
          <div class="mb-2">
            <label class="form-label">Usuario</label>
            <asp:TextBox ID="txtUser" runat="server" CssClass="form-control" />
          </div>
          <div class="mb-3">
            <label class="form-label">Contraseña</label>
            <asp:TextBox ID="txtPass" runat="server" CssClass="form-control" TextMode="Password" />
          </div>
          <asp:Button ID="btnLogin" runat="server" Text="Ingresar" CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />
        </div>
      </div>
    </div>
  </div>
</asp:Content>
