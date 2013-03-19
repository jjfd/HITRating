<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    组件
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $.ajax({
                type: "POST",
                url: "/Api/Votes",
                data: {ReviewId: 6, Supportive: false },
                dataType: "json",
                success: function (data) {
                    alert("Voted");
                },
                error: function (data) {
                    alert("error");
                }
            })
        })
    </script>
</asp:Content>
