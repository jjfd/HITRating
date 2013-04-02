<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Welcome to HitRating, <%: Page.User.Identity.Name %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="module no_border">
        <div class="tabs small">
            <span class="tab" show="1">最新HIT产品评价</span>
            <span class="tab" show="2">最新HIT产品资讯</span>
            <span class="tab" show="3">我的HIT观点</span>
        </div>

        <div class="pages">
            <script type="text/javascript">
                $(function () {
                    var reviewSearchApi = "/Api/Reviews"

                    $.ajax({
                        type: "GET",
                        url: reviewSearchApi,
                        dataType: "json",
                        success: function (data) {
                            var entities = data.Entities;

                            $("#reviews .container").empty();
                            for (var i = 0; i < entities.length; i++) {
                                $("#reviews .container").append($.renderReview(entities[i]));
                            }

                            if (entities.length >= 20) {
                                $("#reviews .more").show();
                            }
                        },
                        error: function () {
                            $("#reviews .container").html("<p class='line gray center small'>没有找到一条HIT产品评价</p>")
                        }
                    });

                    /*
                    $("#latest_reviews .mini_ajax_search").keyup(function (e) {
                        $(this).removeClass("tip_search");

                        if (e.keyCode == 13) {
                            var api = $(this).attr("api");
                            var keyword = $(this).val();

                            reviewSearchApi = api + keyword;

                            $.ajax({
                                type: "GET",
                                url: reviewSearchApi,
                                dataType: "json",
                                success: function (data) {
                                    var entities = data.Entities;

                                    $("#reviews .container").empty();
                                    for (var i = 0; i < entities.length; i++) {
                                        $("#reviews .container").append($.renderReview(entities[i]));
                                    }

                                    if (entities.length >= 20) {
                                        $("#reviews .more").show();
                                    }
                                },
                                error: function () {
                                    $("#reviews .container").html("<p class='line gray center small'>没有找到一条HIT产品评价</p>")
                                }
                            });
                        }
                    });
                    */

                    $("#reviews .more").click(function () {
                        $.ajax({
                            type: "GET",
                            url: reviewSearchApi,
                            data: { IdLower: $("#reviews .container .review_instant:last").attr("object_id") },
                            dataType: "json",
                            success: function (data) {
                                var entities = data.Entities;

                                for (var i = 0; i < entities.length; i++) {
                                    $("#reviews .container").append($.renderReview(entities[i]));
                                }

                                if (entities.length < 20) {
                                    $("#reviews .more").hide();
                                }

                                $.enableButtons($("#reviews .more").parent());
                            },
                            error: function () {
                                $("#reviews .container").append("<p class='line gray center'>没有更多了</p>")
                                $("#reviews .more").hide();
                            }
                        });
                    })
                })
            </script>
            <div id="latest_reviews" class="page" page="1">
                <!--
                <div class="right">
                    <input class="mini_ajax_search tip_search" value="查询HIT产品的评价" api="/Api/Reviews?Title=" title="回车直接查询" />
                </div>
                <br />
                -->
                <div id="reviews">
                    <div class="container">
                        <p class="line gray small center">loading</p>
                    </div>
                    <div class="line big_buttons one_click_buttons hidden">
                        <a href="#more" class="more">更多</a>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                $(function () {
                    var productSearchApi = "/Api/Products";

                    $.ajax({
                        type: "GET",
                        url: productSearchApi,
                        dataType: "json",
                        success: function (data) {
                            var entities = data.Entities;

                            $("#products .container").empty();
                            for (var i = 0; i < entities.length; i++) {
                                $("#products .container").append($.renderProduct(entities[i]));
                            }

                            if (entities.length >= 20) {
                                $("#products .more").show();
                            }
                        },
                        error: function () {
                            $("#products .container").html("<p class='line gray center small'>没有找到一条HIT产品信息</p>")
                        }
                    });

                    $("#latest_products .mini_ajax_search").keyup(function (e) {
                        $(this).removeClass("tip_search");

                        if (e.keyCode == 13) {
                            var api = $(this).attr("api");
                            var keyword = $(this).val();

                            productSearchApi = api + keyword;

                            $.ajax({
                                type: "GET",
                                url: api + keyword,
                                dataType: "json",
                                success: function (data) {
                                    var entities = data.Entities;

                                    $("#products .container").empty();
                                    for (var i = 0; i < entities.length; i++) {
                                        $("#products .container").append($.renderProduct(entities[i]));
                                    }

                                    if (entities.length >= 20) {
                                        $("#products .more").show();
                                    }
                                },
                                error: function () {
                                    $("#products .container").html("<p class='line gray center small'>没有找到一条HIT产品信息</p>")
                                }
                            });
                        }
                    });

                    $("#products .more").click(function () {
                        $.ajax({
                            type: "GET",
                            url: productSearchApi,
                            data: { IdLower: $("#products .container .product_instant:last").attr("object_id") },
                            dataType: "json",
                            success: function (data) {
                                var entities = data.Entities;

                                for (var i = 0; i < entities.length; i++) {
                                    $("#products .container").append($.renderProduct(entities[i]));
                                }

                                if (entities.length < 20) {
                                    $("#products .more").hide();
                                }

                                $.enableButtons($("#products .more").parent());
                            },
                            error: function () {
                                $("#products .container").append("<p class='line gray center'>没有更多了</p>")
                                $("#products .more").hide();
                            }
                        });
                    })
                })
            </script>
            <div id="latest_products" class="page" page="2">
                <div class="right">
                    <input class="mini_ajax_search tip_search" value="查询HIT产品" api="/Api/Products?Title=" title="回车直接查询" />
                </div>
                <br />
                <div id="products">
                    <div class="container">
                        <p class="line gray small center">请通过查询获取HIT产品管理，或通过<a href="#" class="new_product" title="创建HIT产品">创建</a>按钮登记新的HIT产品信息。</p>
                    </div>
                    <div class="line big_buttons one_click_buttons hidden">
                        <a href="#more" class="more">更多</a>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                $(function () {
                    var myReviewSearchApi = "/Api/Reviews?Creator=" + "<%: Page.User.Identity.Name %>";

                    $.ajax({
                        type: "GET",
                        url: myReviewSearchApi,
                        dataType: "json",
                        success: function (data) {
                            var entities = data.Entities;

                            $("#my_reviews .container").empty();
                            for (var i = 0; i < entities.length; i++) {
                                $("#my_reviews .container").append($.renderReview(entities[i]));
                            }

                            if (entities.length >= 20) {
                                $("#my_reviews .more").show();
                            }
                        },
                        error: function () {
                            $("#my_reviews .container").html("<p class='line gray center small'>你还没有发布过任何的HIT产品评价和观点。</p>")
                        }
                    });

                    $("#my_reviews .more").click(function () {
                        $.ajax({
                            type: "GET",
                            url: myReviewSearchApi,
                            data: { IdLower: $("#my_reviews .container .review_instant:last").attr("object_id") },
                            dataType: "json",
                            success: function (data) {
                                var entities = data.Entities;

                                for (var i = 0; i < entities.length; i++) {
                                    $("#my_reviews .container").append($.renderReview(entities[i]));
                                }

                                if (entities.length < 20) {
                                    $("#my_reviews .more").hide();
                                }

                                $.enableButtons($("#my_reviews .more").parent());
                            },
                            error: function () {
                                $("#my_reviews .container").append("<p class='line gray center'>没有更多了</p>")
                                $("#my_reviews .more").hide();
                            }
                        });
                    })
                })
            </script>
            <div id="my_opinions" class="page" page="3">
                <div id="my_reviews">
                    <div class="container">
                        <p class="line gray small center">loading</p>
                    </div>
                    <div class="line big_buttons one_click_buttons hidden">
                        <a href="#more" class="more">更多</a>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <p class="right">Welcome! <span class="green"><%: Page.User.Identity.Name %></span></p>
    <br />

</asp:Content>
