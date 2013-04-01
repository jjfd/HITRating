﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查看HIT产品信息
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var reviewId = "<%: ViewData["Id"] %>";

        $(function () {
            $.ajax({
                type: "GET",
                url: "/Api/Review/" + reviewId,
                dataType: "json",
                success: function(data) {
                    $("#the_review").html($.renderReview(data.Entity));

                    $("#the_review nav .taction:last").remove();

                    $("body > aside").append('<br /><br /><a href="#product" class="taction small" object="Product" object_id="' + data.Entity.Product.Id + '" taction_type="2" taction_id="Read_Product" method="GET" api="/Api/Product/' + data.Entity.Product.Id + '" title="查询同一HIT产品的评价">同一HIT产品的评价</a>');
                
                    $.ajax({
                        type: "GET",
                        url: "/Api/Review/" + reviewId + "/Votes",
                        dataType: "json",
                        success: function(data) {
                            var votes = data.Entities;

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
                            
                            var vsBar = $('<div class="vs"><p class="supportors"></p><span class="support_side" style="width: ' + supportPercents + '%;">&nbsp;< ' + supportPercents + '%</span><span class="oppose_side"  style="width: ' + opposePercents + '%;">' + opposePercents + '% >&nbsp;</span><p class="opposers"></p></div>');
                            
                            var sCount = supports.length < 3 ? supports.length : 3;
                            var oCount = opposes.length < 3 ? opposes.length : 3;

                            for (var i=0; i<sCount; i++) {
                                vsBar.find(".supportors").append("<span class='voter'>" + supports[i].Creator.UserName + "</span>,");
                            }

                            if (supports.length > 3) {
                                vsBar.find(".supportors").append("等")
                            }

                            vsBar.find(".supportors").append("支持");

                            for (var i=0; i<oCount; i++) {
                                vsBar.find(".opposers").append("<span class='voter'>" + opposes[i].Creator.UserName + "</span>,");
                            }

                            if (opposes.length > 3) {
                                vsBar.find(".opposers").append("等")
                            }

                            vsBar.find(".opposers").append("反对");

                            $("body > aside").prepend("<br />").prepend(vsBar);
                        },
                        error: function() {
                        
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

        <div class="line big_buttons one_click_buttons hidden">
            <a href="#more" class="more">更多评论</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <input class="mini_search tip_search" value="查询其它HIT产品" action="/Product/Search?api=/Api/Products?Title=" title="Enter直接查询">
</asp:Content>
