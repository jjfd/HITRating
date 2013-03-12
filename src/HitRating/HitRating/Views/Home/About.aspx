<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    测试
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $("#create_vendor input:submit").click(function () {
                $.ajax({
                    type: "POST",
                    url: "/Api/Vendors",
                    data: { Title: $("#create_vendor input[name='Title']").val() },
                    dataType: "json",
                    success: function (data) {
                        alert(data.Entity.Id + " " + data.Entity.Title);
                    }
                })
            })

            $.ajax({
                type: "DELETE",
                url: "/Api/Vendor/1",
                dataType: "json",
                success: function (data) {
                    alert("deleted");
                },
                error: function (data) {
                    alert("error");
                }
            })
        })
    </script>
    <div id="create_vendor">
        <input name="Title" />
        <input type="submit" "创建Vendor" />

    </div>
</asp:Content>
