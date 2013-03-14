<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    测试
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $.ajax({
                type: "POST",
                url: "/Api/Products",
                data: {Title: "Test 3", VendorId: 2, Version: "1.2.23" },
                dataType: "json",
                success: function (data) {
                    alert("created");
                },
                error: function (data) {
                    alert("error");
                }
            })
        })
    </script>
</asp:Content>
