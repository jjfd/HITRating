<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	管理员主页
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="module no_border">
        <div class="tabs small">
            <span class="tab_caption">管理HIT</span>
            <span class="tab" show="1">产品</span>
            <span class="tab" show="2">产品类别</span>
            <span class="tab" show="3">类别</span>
            <span class="tab" show="4">HIT资讯</span>
        </div>
        <div class="pages">
            <script type="text/javascript">
                $(function () {
                    var productSearchApi = null;

                    $("#manage_products .mini_ajax_search").keyup(function (e) {
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
            <div id="manage_products" class="page" page="1">
                <div>
                    <input class="mini_ajax_search tip_search" value="查询HIT产品" api="/Api/Products?Title=" title="回车直接查询" />
                    <p class="right line small">
                        <a href="#" class="taction" object="Product" taction_type="1" taction_id="Create_Product" method="POST" api="/Api/Products" title="创建HIT产品">创建</a>
                    </p>
                </div>
                <br />
                <div id="products">
                    <div class="container">
                        <p class="line gray small center">请通过查询获取HIT产品管理，或通过<a href="#" class="new_product" title="创建HIT产品">创建</a>按钮登记新的HIT产品信息。</p>
                    </div>
                    <div class="more line big_buttons one_click_buttons hidden">
                        <a href="#more">更多</a>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                $(function () {
                    var vendorSearchApi = null;

                    $("#manage_vendors .mini_ajax_search").keyup(function (e) {

                        $(this).removeClass("tip_search");

                        if (e.keyCode == 13) {
                            var api = $(this).attr("api");
                            var keyword = $(this).val();

                            vendorSearchApi = api + keyword;

                            $.ajax({
                                type: "GET",
                                url: api + keyword,
                                dataType: "json",
                                success: function (data) {
                                    var entities = data.Entities;

                                    $("#vendors .container").empty();
                                    for (var i = 0; i < entities.length; i++) {
                                        $("#vendors .container").append($.renderVendor(entities[i]));
                                    }

                                    if (entities.length >= 20) {
                                        $("#vendors .more").show();
                                    }
                                },
                                error: function () {
                                    $("#vendors .container").html("<p class='line gray center small'>没有找到一条HIT供应商信息</p>")
                                }
                            });
                        }
                    });

                    $("#vendors .more").click(function () {
                        $.ajax({
                            type: "GET",
                            url: vendorSearchApi,
                            data: { IdLower: $("#vendors .container .vendor_instant:last").attr("object_id") },
                            dataType: "json",
                            success: function (data) {
                                var entities = data.Entities;

                                for (var i = 0; i < entities.length; i++) {
                                    $("#vendors .container").append($.renderVendor(entities[i]));
                                }

                                if (entities.length < 20) {
                                    $("#vendors .more").hide();
                                }

                                $.enableButtons($("#vendors .more").parent());
                            },
                            error: function () {
                                $("#vendors .container").append("<p class='line gray center'>没有更多了</p>")
                                $("#vendors .more").hide();
                            }
                        });
                    })
                })
            </script>
            <div id="manage_vendors" class="page" page="2">
                <div>
                    <input class="mini_ajax_search tip_search" value="查询HIT供应商" api="/Api/Vendors?Title=" title="回车直接查询" />
                    <p class="right line small">
                        <a href="#" class="taction" object="Vendor" taction_type="1" taction_id="Create_Vendor" method="POST" api="/Api/Vendors" title="创建HIT供应商">创建</a>
                    </p>
                </div>
                <br />
                <div id="vendors">
                    <div class="container">
                        <p class="line gray small center">请通过查询获取HIT供应商管理，或通过<a href="#" class="new_vendor" title="创建HIT供应商">创建</a>按钮登记新的HIT供应商信息。</p>
                    </div>
                    <div class="more line big_buttons one_click_buttons hidden">
                        <a href="#more">更多</a>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                $(function () {
                    var categorySearchApi = null;

                    $("#manage_categories .mini_ajax_search").keyup(function (e) {

                        $(this).removeClass("tip_search");

                        if (e.keyCode == 13) {
                            var api = $(this).attr("api");
                            var keyword = $(this).val();

                            categorySearchApi = api + keyword;

                            $.ajax({
                                type: "GET",
                                url: api + keyword,
                                dataType: "json",
                                success: function (data) {
                                    var entities = data.Entities;

                                    $("#categories .container").empty();
                                    for (var i = 0; i < entities.length; i++) {
                                        $("#categories .container").append($.renderCategory(entities[i]));
                                    }

                                    if (entities.length >= 20) {
                                        $("#categories .more").show();
                                    }
                                },
                                error: function () {
                                    $("#categories .container").html("<p class='line gray center small'>没有找到一条HIT产品类别信息</p>")
                                }
                            });
                        }
                    });

                    $("#categories .more").click(function () {
                        $.ajax({
                            type: "GET",
                            url: categorySearchApi,
                            data: { IdLower: $("#categories .container .category_instant:last").attr("object_id") },
                            dataType: "json",
                            success: function (data) {
                                var entities = data.Entities;

                                for (var i = 0; i < entities.length; i++) {
                                    $("#categories .container").append($.renderCategory(entities[i]));
                                }

                                if (entities.length < 20) {
                                    $("#categories .more").hide();
                                }

                                $.enableButtons($("#categories .more").parent());
                            },
                            error: function () {
                                $("#categories .container").append("<p class='line gray center'>没有更多了</p>")
                                $("#categories .more").hide();
                            }
                        });
                    })
                })
            </script>
            <div id="manage_categories" class="page" page="3">
                <div>
                    <input class="mini_ajax_search tip_search" value="查询HIT产品类别" api="/Api/Categories?Abbreviation=" title="回车直接查询" />
                    <p class="right line small">
                        <a href="#" class="taction" object="Category" taction_type="1" taction_id="Create_Category" method="POST" api="/Api/Categories" title="创建HIT产品类别">创建</a>
                    </p>
                </div>
                <br />
                <div id="categories">
                    <div class="container">
                        <p class="line gray small center">请通过查询获取HIT产品类别管理，或通过<a href="#" class="new_category" title="创建HIT产品类别">创建</a>按钮登记新的HIT产品类别信息。</p>
                    </div>
                    <div class="more line big_buttons one_click_buttons hidden">
                        <a href="#more">更多</a>
                    </div>
                </div>
            </div>

            <script type="text/javascript">
                $(function () {
                    var newsSearchApi = "/Api/Newses";

                    $("#get_news").click(function (e) {
                        $.ajax({
                            type: "GET",
                            url: newsSearchApi,
                            dataType: "json",
                            success: function (data) {
                                var entities = data.Entities;

                                $("#reviews .container").empty();
                                for (var i = 0; i < entities.length; i++) {
                                    $("#reviews .container").append($.renderNews(entities[i]));
                                }

                                if (entities.length >= 20) {
                                    $("#reviews .more").show();
                                }
                            },
                            error: function () {
                                $("#reviews .container").html("<p class='line gray center small'>没有找到一条HIT资讯</p>")
                            }
                        });
                    });

                    $("#reviews .more").click(function () {
                        $.ajax({
                            type: "GET",
                            url: categorySearchApi,
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
            <div id="manage_product_news" class="page" page="4">
                <div>
                    <p class="right line small">
                        <a href="#" class="taction" object="News" taction_type="1" taction_id="Create_Product" method="POST" api="/Api/Newses" title="创建HIT资讯">创建</a>
                    </p>
                </div>
                <br />
                <div id="reviews">
                    <div class="container">
                        <p class="line gray small center">点击<a href="#" id="get_news">加载</a>，获取最新的HIT产品资讯</p>
                    </div>
                    <div class="more line big_buttons one_click_buttons hidden">
                        <a href="#more">更多</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <h2>管理员主页</h2>
</asp:Content>
