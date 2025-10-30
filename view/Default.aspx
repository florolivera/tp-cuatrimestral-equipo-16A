<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="view._Default" %>

<asp:Content ID="ctTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Inicio
</asp:Content>

<asp:Content ID="ctHeader" ContentPlaceHolderID="PageHeader" runat="server">
    Panel principal
</asp:Content>

<asp:Content ID="ctMain" ContentPlaceHolderID="MainContent" runat="server">

    <section class="hero p-4 p-md-5 mb-4">
        <div class="d-flex flex-column flex-md-row align-items-start align-items-md-center justify-content-between gap-3">
            <div>
                <h2 class="h3 mb-1">¡Bienvenido/a, <asp:LoginName ID="lnUser" runat="server" FormatString="{0}" />!</h2>
                <p class="text-muted mb-0">Hoy es <strong><asp:Literal ID="litFecha" runat="server" /></strong></p>
            </div>
            <div class="d-flex gap-2">
                <a runat="server" href="~/Turnos/NuevoTurno.aspx" class="btn btn-primary">Nuevo turno</a>
                <a runat="server" href="~/Turnos/ListadoTurnos.aspx" class="btn btn-outline-primary">Ver turnos</a>
            </div>
        </div>
    </section>

    <asp:LoginView ID="lvDash" runat="server">
        <AnonymousTemplate>
            <div class="alert alert-info d-flex align-items-center" role="alert">
                <div>
                    Iniciá sesión para gestionar <strong>turnos</strong>, <strong>pacientes</strong> y <strong>médicos</strong>.
                    <a runat="server" href="~/Account/Login.aspx" class="alert-link ms-1">Ingresar</a>
                </div>
            </div>
        </AnonymousTemplate>

         <RoleGroups>

           
           <asp:RoleGroup Roles="Admin">
                <ContentTemplate>
                    <div class="row g-3 mb-4">
                        <div class="col-12 col-md-3">
                            <div class="stat p-3 shadow-sm bg-white">
                                <div class="text-muted small">Usuarios</div>
                                <div class="h4 mb-2"><asp:Literal ID="litUsuarios" runat="server" Text="—" /></div>
                                <a runat="server" href="~/Admin/Usuarios.aspx" class="link-primary small">Gestionar usuarios</a>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="stat p-3 shadow-sm bg-white">
                                <div class="text-muted small">Médicos</div>
                                <div class="h4 mb-2"><asp:Literal ID="litMedicos" runat="server" Text="—" /></div>
                                <a runat="server" href="~/Admin/Medicos.aspx" class="link-primary small">Gestionar médicos</a>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="stat p-3 shadow-sm bg-white">
                                <div class="text-muted small">Especialidades</div>
                                <div class="h4 mb-2"><asp:Literal ID="litEspecialidades" runat="server" Text="—" /></div>
                                <a runat="server" href="~/Admin/Especialidades.aspx" class="link-primary small">Gestionar especialidades</a>
                            </div>
                        </div>
                        <div class="col-12 col-md-3">
                            <div class="stat p-3 shadow-sm bg-white">
                                <div class="text-muted small">Turnos (hoy)</div>
                                <div class="h4 mb-2"><asp:Literal ID="litTurnosHoy" runat="server" Text="—" /></div>
                                <a runat="server" href="~/Admin/Reportes.aspx" class="link-primary small">Ver reportes</a>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:RoleGroup> 

            <asp:RoleGroup Roles="Recepcion">
                <ContentTemplate>
                    <div class="row g-3 mb-4">
                        <div class="col-12 col-md-4">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h3 class="h6">Accesos rápidos</h3>
                                    <div class="d-grid gap-2">
                                        <a runat="server" href="~/Turnos/NuevoTurno.aspx" class="btn btn-primary btn-sm">Dar de alta turno</a>
                                        <a runat="server" href="~/Pacientes/Pacientes.aspx" class="btn btn-outline-primary btn-sm">Gestionar pacientes</a>
                                        <a runat="server" href="~/Medicos/Medicos.aspx" class="btn btn-outline-primary btn-sm">Gestionar médicos</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-12 col-md-8">
                            <div class="card shadow-sm h-100">
                                <div class="card-body">
                                    <h3 class="h6 mb-3">Próximos turnos (hoy)</h3>
                                    <div id="listTurnosRecep">
                                        <div class="turno-item py-2 d-flex justify-content-between">
                                            <span class="text-muted">Sin datos aún</span>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <a runat="server" href="~/Turnos/ListadoTurnos.aspx" class="btn btn-link p-0">Ver todos los turnos</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:RoleGroup>

            <asp:RoleGroup Roles="Medico">
                <ContentTemplate>
                    <div class="row g-3 mb-4">
                        <div class="col-12 col-lg-8">
                            <div class="card shadow-sm h-100">
                                <div class="card-body">
                                    <h3 class="h6 mb-3">Mis turnos de hoy</h3>
                                    <div id="listTurnosMedico">
                                        <div class="turno-item py-2 d-flex justify-content-between">
                                            <span class="text-muted">Sin datos aún</span>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <a runat="server" href="~/Turnos/MisTurnos.aspx" class="btn btn-link p-0">Ver agenda completa</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-12 col-lg-4">
                            <div class="card shadow-sm h-100">
                                <div class="card-body">
                                    <h3 class="h6">Acciones</h3>
                                    <div class="d-grid gap-2">
                                        <a runat="server" href="~/Turnos/MisTurnos.aspx" class="btn btn-outline-primary btn-sm">Abrir mi agenda</a>
                                        <a runat="server" href="~/Perfil/Editar.aspx" class="btn btn-outline-secondary btn-sm">Editar mi perfil</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:RoleGroup> 

        </RoleGroups>
    </asp:LoginView>

</asp:Content>

<asp:Content ID="ctScripts" ContentPlaceHolderID="ScriptsContent" runat="server">
</asp:Content>