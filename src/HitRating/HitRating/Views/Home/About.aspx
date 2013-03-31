<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Welcome to HitRating, <%: Page.User.Identity.Name %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Welcome to HitRating.TestPanels, <%: Page.User.Identity.Name %></h2>

    <div>
        <a href="#create_vendor" class="taction" object="Vendor" taction_type="1" taction_id="Create_Vendor" method="POST" api="/Api/Vendors" title="创建供应商信息">创建供应商信息</a>
        <a href="#read_vendor" class="taction" object="Vendor" object_id="5" taction_type="2" taction_id="Read_Vendor" method="GET" api="/Api/Vendor/5" title="查看供应商信息">查看供应商信息</a>
        <a href="#edit_vendor" class="taction" object="Vendor" object_id="5" taction_type="3" taction_id="Edit_Vendor" method="PUT" api="/Api/Vendor/5" title="修改供应商信息">修改供应商信息</a>
        <a href="#search_vendor" class="taction" object="Vendor" taction_type="5" taction_id="Search_Vendor" method="GET" api="/Api/Vendors" title="查询供应商信息">查询供应商信息</a>
        <div id="vendor_5">
            <script type="text/javascript">
                $(function () {
                    $.ajax({
                        type: "GET",
                        url: "/Api/Vendor/" + 5,
                        dataType: "json",
                        success: function (data) {
                            $("#vendor_5").append($.renderVendor(data.Entity));
                        }
                    })
                })
            </script>
        </div>
    </div>

</asp:Content>
