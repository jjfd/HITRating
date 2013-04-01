<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查看HIT产品信息
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var vendorId = "<%: ViewData["Id"] %>";

        $(function () {
            $.ajax({
                type: "GET",
                url: "/Api/Vendor/" + vendorId,
                dataType: "json",
                success: function(data) {
                    $("#the_vendor").html($.renderVendor(data.Entity));

                    $("#the_vendor nav .taction:last").remove();
                },
                error: function() {
                    $.miniErrorAjaxResult("#" + vendorId + " HIT供应商不存在");
                }
            });

            $.ajax({
                type: "GET",
                url: "/Api/Products?VendorId=" + vendorId,
                dataType: "json",
                success: function(data) {
                    var entities = data.Entities;

                    for (var i=0; i<entities.length; i++) {
                        $("#products .container").append($.renderProduct(entities[i]));
                    }

                    if (entities.length >= 20) {
                        $("#products .more").show();
                    }
                },
                error: function() {
                    ;
                }
            });

            $("#products .more").click(function() {
                $.ajax({
                    type: "GET",
                    url: "/Api/Products?VendorId=" + vendorId,
                    data: { IdLower: $("#products .container .product_instant:last").attr("object_id") },
                    dataType: "json",
                    success: function(data) {
                        var entities = data.Entities;

                        for (var i=0; i<entities.length; i++) {
                            $("#products .container").append($.renderProduct(entities[i]));
                        }

                        if (entities.length < 20) {
                            $("#products .more").hide();
                        }

                        $.enableButtons($("#products .more").parent());
                    },
                    error: function() {
                        $("#products .container").append("<p class='line gray center'>没有更多了</p>")
                        $("#products .more").hide();
                    }
                });
            })
        })
    </script>

    <div id="the_vendor"></div>

    <div id="products">
        <p class="gray_background">HIT产品信息</p>
        <br />
        <div class="container"></div>

        <div class="line big_buttons one_click_buttons hidden">
            <a href="#more" class="more">更多产品评价</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <input class="mini_search tip_search" value="查询其它HIT供应商" action="/Vendor/Search?api=/Api/Vendors?Title=" title="Enter直接查询">
</asp:Content>
