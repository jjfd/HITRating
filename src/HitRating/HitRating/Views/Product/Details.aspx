<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查看HIT产品信息
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var productId = "<%: ViewData["Id"] %>";
        var avg_rate = 0;

        $(function () {
            $.ajax({
                type: "GET",
                url: "/Api/Product/" + productId,
                dataType: "json",
                success: function(data) {
                    $("#the_product").html($.renderProduct(data.Entity));

                    $("#the_product nav .taction:last").remove();

                    $("body > aside").append('<br /><br /><a href="#relative_products" class="taction small" object="Product" taction_type="5" taction_id="Search_Product_By_Vendor" method="GET" api="/Api/Vendor/' + data.Entity.Vendor.Id + '/Products" title="查询同一供应商下的HIT产品">同供应商下的HIT产品</a> ');
                    
                    if (data.Entity.Category != null) {                 
                        $("body > aside").append('<br /><br /><a href="#relative_products" class="taction small" object="Product" taction_type="5" taction_id="Search_Product_By_Vendor" method="GET" api="/Api/Products?CategoryId=' + data.Entity.Category.Id + '" title="查询同一类别下的HIT产品">同类别下的HIT产品</a>');   
                    }


                },
                error: function() {
                    $.miniErrorAjaxResult("#" + productId + " HIT产品信息不存在");
                }
            });

            $.ajax({
                type: "GET",
                url: "/Api/Reviews?ProductId=" + productId,
                dataType: "json",
                success: function(data) {
                    var entities = data.Entities;

                    for (var i=0; i<entities.length; i++) {
                        var reviewHtml = $.renderReview(entities[i]);
                        $(reviewHtml).find("nav .taction:first").remove();
                        $("#reviews .container").append(reviewHtml);
                        avg_rate += entities[i].Rate;
                    }

                    avg_rate = Math.round(avg_rate / entities.length);

                    $("#avg_rate .star_input").find(".star").eq(avg_rate - 1).mouseover();
                    $("#avg_rate .star_input").attr("disabled", "disabled");
                    $("#avg_rate .count").text(entities.length);


                    if (entities.length >= 20) {
                        $("#reviews .more").show();
                    }
                },
                error: function() {
                    $("#reviews .container").html("<p class='line gray center'>还没有一条评价，<span class='green'>发布你的观点和意见</span></p>")
                }
            });

            $("#reviews .more").click(function() {
                $.ajax({
                    type: "GET",
                    url: "/Api/Reviews?ProductId=" + productId,
                    data: { IdLower: $("#reviews .container .review_instant:last").attr("object_id") },
                    dataType: "json",
                    success: function(data) {
                        var entities = data.Entities;

                        for (var i=0; i<entities.length; i++) {
                            var reviewHtml = $.renderReview(entities[i]);
                            $(reviewHtml).find("nav .taction:first").remove();
                            $("#reviews .container").append(reviewHtml);
                        }

                        if (entities.length < 20) {
                            $("#reviews .more").hide();
                        }

                        $.enableButtons($("#reviews .more").parent());
                    },
                    error: function() {
                        $("#reviews .container").append("<p class='line gray center'>没有更多了</p>")
                        $("#reviews .more").hide();
                    }
                });
            })
        })
    </script>

    <div id="the_product"></div>

    <div id="reviews">
        <p class="buttons float_right">
            <a href="#review" class="taction" object="Review" object_id="<%: ViewData["Id"] %>" taction_type="1" taction_id="Create_Review" method="POST" api="/Api/Reviews?ProductId=<%: ViewData["Id"] %>" title="发表产品评价">你的观点</a>
        </p>
        <p class="gray_background">最新产品评价</p>
        <br />
        <div class="container"></div>

        <div class="line big_buttons one_click_buttons hidden">
            <a href="#more" class="more">更多产品评价</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <div id="avg_rate">
        <p class="star_input">
            <span class="stars">
                <span class="star">★</span>
                <span class="star">★</span>
                <span class="star">★</span>
                <span class="star">★</span>
                <span class="star">★</span>
            </span>
            <input type="hidden" name="" />
        </p>
        <p class="gray small">根据最近的 <span class='count red'></span> 条产品评价数据</p>
    </div>
    <br />
    <input class="mini_search tip_search" value="查询其它HIT产品" action="/Product/Search?api=/Api/Products?Title="  title="Enter直接查询">
    
</asp:Content>