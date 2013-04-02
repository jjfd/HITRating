<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查询HIT产品信息
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
        var api = "<%: ViewData["Api"] %>";
        var avg_rate = 0;

        $(function () {

            $.ajax({
                type: "GET",
                url: api,
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
                    $("#products .container").html("<p class='line gray center'>没有找到一条HIT产品信息</p>")
                }
            });

            $("#products .more").click(function() {
                $.ajax({
                    type: "GET",
                    url: api,
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

    <div id="products">
        <div class="container"></div>

        <div class="line big_buttons one_click_buttons hidden">
            <a href="#more" class="more">更多HIT产品</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <input class="mini_search tip_search" value="查询HIT产品" action="/Product/Search?api=/Api/Products?Title="  title="Enter直接查询">
</asp:Content>
