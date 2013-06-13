<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查看HIT产品信息
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        #the_review .tbox
        {
            border-bottom: 0;    
        }
         #the_review .tbox > aside
         {
            float: right;
            width: 3.5em;
            margin-right: 0;
            margin-left: .5em;   
         }
         #the_review .tbox > aside img
         {
            width: 3.3em;
            height: 3.3em;    
         }
        #the_review .tbox > article
        {
            margin-left: 0;
        }
        #the_review .tbox > article .toggle
        {
            display: none;    
        }
        #the_review .tbox > article > h3
        {
            font-size: 20px; 
        }
    </style>
    <script type="text/javascript">
        var reviewId = "<%: ViewData["Id"] %>";

        $(function () {
            $.ajax({
                type: "GET",
                url: "/Api/News/" + reviewId,
                dataType: "json",
                success: function(data) {
                    $("#the_review").html($.renderNews(data.Entity));
                    $("#the_review .toggle_read .toggle").click();

                    $("#the_review nav").remove();

                    $("body > aside");
                },
                error: function() {
                    $.miniErrorAjaxResult("#" + reviewId + " 产品评价不存在");
                }
            });

            $.ajax({
                type: "GET",
                url: "/Api/Comments?ReviewId=" + reviewId,
                dataType: "json",
                success: function(data) {
                    var entities = data.Entities;

                    for (var i=0; i<entities.length; i++) {
                        $("#comments .container").append($.renderComment(entities[i]));
                    }

                    if (entities.length >= 20) {
                        $("#comments .more").show();
                    }
                },
                error: function() {
                    $("#comments .container").html("<p class='line gray center'>还没有一条评论，<span class='green'>发布你的观点和意见</span></p>")
                }
            });

            $("#comments .more").click(function() {
                $.ajax({
                    type: "GET",
                    url: "/Api/Comments?ReviewId=" + reviewId,
                    data: { IdLower: $("#comments .container .comment_instant:last").attr("object_id") },
                    dataType: "json",
                    success: function(data) {
                        var entities = data.Entities;

                        for (var i=0; i<entities.length; i++) {
                            $("#comments .container").append($.renderComment(entities[i]));
                        }

                        if (entities.length < 20) {
                            $("#comments .more").hide();
                        }

                        $.enableButtons($("#comments .more").parent());
                    },
                    error: function() {
                        $("#comments .container").append("<p class='line gray center'>没有更多了</p>");
                        $("#comments .more").hide();
                    }
                });
            })
        })
    </script>

    <div id="the_review"></div>

    <div id="comments">
        <% if (Page.User.Identity.IsAuthenticated)
           { %>
        <p class="buttons float_right">
            <a href="#comment" class="taction" object="Comment" object_id="<%: ViewData["Id"] %>" taction_type="1" taction_id="Create_Comment" method="POST" api="/Api/Comments?ReviewId=<%: ViewData["Id"] %>" title="发表评论">你的意见</a>
        </p>
        <% } %>
        <p class="gray_background">评论</p>
        <br />
        <div class="container"></div>

        <div class="more line big_buttons one_click_buttons hidden">
            <a href="#more">更多</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <input class="mini_search tip_search" value="查询其它HIT产品" action="/Product/Search?api=/Api/Products?Title=" title="Enter直接查询">
</asp:Content>
