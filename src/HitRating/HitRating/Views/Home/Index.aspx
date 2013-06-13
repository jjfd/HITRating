<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	HitRating: 你的参与，你的决策
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        .tbox > article > h3
        {
        }
        .tbox > article > nav .taction,
        .tbox > article > nav .taction:link,
        .tbox > article > nav .taction:hover
        {
            display: none;
        }
        .tbox > article > nav .taction:last-child,
        .tbox > article > nav .taction:last-child:link,
        .tbox > article > nav .taction:last-child:hover
        {
            display: inline-block;
        }
        .tbox .toggle
        {
            position: absolute;
            top: 0;
            right: 0;  
        }
    </style>
    <script type="text/javascript">
        var api = "/Api/ProductInfoes";

        $(function () {
            $.ajax({
                type: "GET",
                url: api,
                dataType: "json",
                success: function(data) {
                    var entities = data.Entities;

                    for (var i=0; i<entities.length; i++) {
                        $("#infoes .container").append($.renderProductInfo(entities[i], 300));
                    }

                    if (entities.length >= 20) {
                        $("#infoes .more").show();
                    }
                },
                error: function() {
                    $("#infoes .container").html("<p class='line gray center'>没有找到一条HIT资讯</p>")
                }
            });

            $("#infoes .more").click(function () {
                $.ajax({
                    type: "GET",
                    url: api,
                    data: { IdLower: $("#infoes .container .review_instant:last").attr("object_id") },
                    dataType: "json",
                    success: function(data) {
                        var entities = data.Entities;

                        for (var i=0; i<entities.length; i++) {
                            $("#infoes .container").append($.renderProductInfo(entities[i], 300));
                        }

                        if (entities.length < 20) {
                            $("#infoes .more").hide();
                        }

                        $.enableButtons($("#infoes .more").parent());
                    },
                    error: function() {
                        $("#infoes .container").append("<p class='line gray center'>没有更多了</p>")
                        $("#infoes .more").hide();
                    }
                });
            })
        })
    </script>

    <div id="infoes">
        <div class="container"></div>

        <div class="more line big_buttons one_click_buttons hidden">
            <a href="#more">更多资讯</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <div id="slogan">
        <img src="<%: Html.ParseImageUrl("Images/logo.png") %>" alt="" style="width:100%;" />
    </div>
</asp:Content>
