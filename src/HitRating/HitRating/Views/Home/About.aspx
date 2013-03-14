<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    测试
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $.ajax({
                type: "DELETE",
                url: "/Api/Product/3",
                data: { Published: "2012-12-23" },
                dataType: "json",
                success: function (data) {
                    alert("edited");
                },
                error: function (data) {
                    alert("error");
                }
            })
        })
    </script>
</asp:Content>
