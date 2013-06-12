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
                url: "/Api/Review/" + reviewId,
                dataType: "json",
                success: function(data) {
                    $("#the_review").html($.renderReview(data.Entity));
                    $("#the_review .toggle_read .toggle").click();

                    $("#the_review nav").remove();

                    $("body > aside").append('<br /><br /><a href="#product" class="taction small" object="Product" object_id="' + data.Entity.Product.Id + '" taction_type="2" taction_id="Read_Product" method="GET" api="/Api/Product/' + data.Entity.Product.Id + '" title="查询同一HIT产品的评价">同一HIT产品的评价</a>')
                                     .append('<br /><br /><span class="gray small">应用 </span><a href="/Category/Aspects/' + data.Entity.Product.Category.Id + '" class="small">' + data.Entity.Product.Category.Title + ' 标准评价集 >></a> ');
                    $.ajax({
                        type: "GET",
                        url: "/Api/Review/" + reviewId + "/Votes",
                        dataType: "json",
                        success: function(data) {
                            var votes = data.Entities;
                            if (votes.length > 0) {
                                var opposes = new Array();
                                var supports = new Array();
                                for (var i=0, oi=0, si=0; i<votes.length; i++) {
                                    if (votes[i].Supportive) {
                                        supports[si] = votes[i];
                                        si++;
                                    }
                                    else {
                                        opposes[oi] = votes[i];
                                        oi++;
                                    }
                                }
                                
                                var supportPercents = Math.round(supports.length * 100 / votes.length);
                                var opposePercents = 100 - supportPercents;
                            
                                var vsBar = $('<div class="vs"><p class="opposers float_right"></p><p class="supportors"></p><span class="support_side" style="width: ' + supportPercents + '%;"></span><span class="oppose_side"  style="width: ' + opposePercents + '%;"></span></div>');
                            
                                var sCount = supports.length < 3 ? supports.length : 3;
                                var oCount = opposes.length < 3 ? opposes.length : 3;

                                if (sCount > 0) {
                                    for (var i=0; i<sCount; i++) {
                                        vsBar.find(".supportors").append("<span class='voter'>" + supports[i].Creator.UserName + "</span>,");
                                    }

                                    if (supports.length > 3) {
                                        vsBar.find(".supportors").append("等");
                                    }

                                    vsBar.find(".support_side").html('&nbsp;< ' + supportPercents + '%');
                                }
                                else 
                                {
                                    vsBar.find(".supportors").append("目前无人");
                                }
                                vsBar.find(".supportors").append("支持");

                                if (oCount > 0) 
                                {
                                    for (var i=0; i<oCount; i++) {
                                        vsBar.find(".opposers").append("<span class='voter'>" + opposes[i].Creator.UserName + "</span>,");
                                    }

                                    if (opposes.length > 3) {
                                        vsBar.find(".opposers").append("等")
                                    }

                                    vsBar.find(".oppose_side").html('' + opposePercents + '% > &nbsp;');
                                }
                                else
                                {
                                    vsBar.find(".opposers").append("目前无人");
                                }
                                vsBar.find(".opposers").append("反对");

                                vsBar.append("<p class='line small gray'>根据最新的 <span class='blue'>" + votes.length + "</span> 次投票</p>")
                            }

                            $("body > aside").prepend("<br />").prepend(vsBar);
                        },
                        error: function() {
                            $("body > aside").prepend("<br />").prepend('<p class="gray small">尚未有人做出投票!</p>');
                        }
                    });
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
        <p class="buttons float_right">
            <a href="#comment" class="taction" object="Comment" object_id="<%: ViewData["Id"] %>" taction_type="1" taction_id="Create_Comment" method="POST" api="/Api/Comments?ReviewId=<%: ViewData["Id"] %>" title="发表评论">你的意见</a>
        </p>
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
