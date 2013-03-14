<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    测试
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $("a").click(function () {

                $.ajax({
                    type: "PUT",
                    url: "/Api/Vendor/2",
                    dataType: "json",
                    success: function (data) {
                        alert("edited");
                    },
                    error: function (data) {
                        alert("error");
                    }
                })
            })

            $.ajax({
                type: "POST",
                url: "/Api/Vendors",
                data: {Title: "Test 3" },
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

    <a>Edit Vendor 2</a>
</asp:Content>
