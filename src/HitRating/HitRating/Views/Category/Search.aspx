<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查询HIT产品类别信息
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
                        $("#categories .container").append($.renderCategory(entities[i]));
                    }

                    if (entities.length >= 20) {
                        $("#categories .more").show();
                    }
                },
                error: function() {
                    $("#categories .container").html("<p class='line gray center'>没有找到一条HIT产品类别信息</p>")
                }
            });

            $("#categories .more").click(function() {
                $.ajax({
                    type: "GET",
                    url: api,
                    data: { IdLower: $("#categories .container .category_instant:last").attr("object_id") },
                    dataType: "json",
                    success: function(data) {
                        var entities = data.Entities;

                        for (var i=0; i<entities.length; i++) {
                            $("#categories .container").append($.renderCategory(entities[i]));
                        }

                        if (entities.length < 20) {
                            $("#categories .more").hide();
                        }

                        $.enableButtons($("#categories .more").parent());
                    },
                    error: function() {
                        $("#categories .container").append("<p class='line gray center'>没有更多了</p>")
                        $("#categories .more").hide();
                    }
                });
            })
        })
    </script>

    <div id="categories">
        <div class="container"></div>

        <div class="line big_buttons one_click_buttons hidden">
            <a href="#more" class="more">更多HIT产品类别</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <input class="mini_search tip_search" value="查询HIT产品类别" action="/Category/Search?api=/Api/Categories?Title="  title="Enter直接查询">
</asp:Content>
