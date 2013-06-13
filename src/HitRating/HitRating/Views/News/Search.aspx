<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查询HIT资讯
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
        var api = "<%: ViewData["Api"] %>";

        $(function () {
            $.ajax({
                type: "GET",
                url: api,
                dataType: "json",
                success: function(data) {
                    var entities = data.Entities;

                    for (var i=0; i<entities.length; i++) {
                        $("#reviews .container").append($.renderNews(entities[i]));
                    }

                    if (entities.length >= 20) {
                        $("#reviews .more").show();
                    }
                },
                error: function() {
                    $("#reviews .container").html("<p class='line gray center'>没有找到一条HIT资讯</p>")
                }
            });

            $("#reviews .more").click(function() {
                $.ajax({
                    type: "GET",
                    url: api,
                    data: { IdLower: $("#reviews .container .review_instant:last").attr("object_id") },
                    dataType: "json",
                    success: function(data) {
                        var entities = data.Entities;

                        for (var i=0; i<entities.length; i++) {
                            $("#reviews .container").append($.renderNews(entities[i]));
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

    <div id="reviews">
        <div class="container"></div>

        <div class="line big_buttons one_click_buttons hidden">
            <a href="#more" class="more">更多</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <input class="mini_search tip_search" value="查询HIT产品及其资讯与评价" action="/Product/Search?api=/Api/Products?Title="  title="Enter直接查询">
</asp:Content>
