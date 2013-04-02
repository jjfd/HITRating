<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Find
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>we are find <span class="red">EVERYTING</span> related to <a>"<%: ViewData["Key"] %>"</a>, <br />to give <span class="red">YOU</span> the best advice and opinions!</h2>
    <br />
    <p class="small">But it's under construction, please wait a few days, :< <a href="/Account/Home">return to homepage</a>.</p>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    
</asp:Content>
