<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    测试
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $.ajax({
                type: "DELETE",
                url: "/Api/Comment/2",
                data: {Details: "this is a comment to review #6 edited by ryan" },
                dataType: "json",
                success: function (data) {
                    alert("DELETE");
                },
                error: function (data) {
                    alert("error");
                }
            })
        })
    </script>
</asp:Content>
