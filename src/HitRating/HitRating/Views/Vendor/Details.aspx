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
                    var theVendor = $("<div></div>");
                    theVendor.append("<img class='float_right' src='" + data.Entity.Logo + "' style='width:4.5em; height: 4.5em; padding: 1px; border: 1px solid #ddd;'/>")
                              .append("<h1>" + data.Entity.Title + "</h1>")
                              .append("<div class='small line'><a href='" + data.Entity.HomePage + "'>" + data.Entity.HomePage + "</a></div>")
                              .append("<div class='small line'><label>电话：</label>" + data.Entity.Phone + " | <label>400：</label>" + data.Entity.Phone_400 + " | <label>800：</label>" + data.Entity.Phone_800 + " | <label>传真：</label>" + data.Entity.Fax + "</div>")
                              .append("<div class='small line'><label>地址：</label>" + data.Entity.Address + " " + (data.Entity.PostNo?data.Entity.PostNo:"") +"</div>")
                              .append("<div class='toggle_read'><div class='toggle_content'>" + $.renderDescription(data.Entity.Description, 300) + "<a class='toggle' title='展开/收起'>&#8645</a></div><div class='toggle_content hidden'>" + $.renderDescription(data.Entity.Description) + "<a class='toggle' title='展开/收起'>&#8645</a></div></div>")
                    
                    $("#the_vendor").html(theVendor.html());
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

    <br />
    <br />

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
