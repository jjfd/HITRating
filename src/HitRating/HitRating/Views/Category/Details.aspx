<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查看HIT产品类别信息
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
         #the_category .tbox > aside
         {
            display: none;  
         }
        #the_category .tbox > article
        {
            margin-left: 0;
        }
        #the_category .tbox > article .toggle
        {
            display: none;    
        }
        #the_category .tbox > article > h3
        {
            font-size: 20px; 
        }
        #the_category .tbox > article label
        {
            display: none;    
        }
        #the_category .tbox > article .toggle_read .toggle_content > p
        {
            display: inline-block;
            padding-right: 1em;
            font-size: 12px;   
            color: #999; 
        }
    </style>
    <script type="text/javascript">
        var categoryId = "<%: ViewData["Id"] %>";

        $(function () {
            $.ajax({
                type: "GET",
                url: "/Api/Category/" + categoryId,
                dataType: "json",
                success: function(data) {
                    $("#the_category").html($.renderCategory(data.Entity));
                    $("#the_category .toggle").click().remove();

                    $("body > aside").append('<br /><br /><span class="gray small"></span><a href="/Category/Aspects/' + data.Entity.Id + '" class="small">' + data.Entity.Abbreviation + ' (' + data.Entity.Title　+ ') 标准评价集 >></a> ');

                    $("#the_category nav .taction:last").remove();
                },
                error: function() {
                    $.miniErrorAjaxResult("#" + categoryId + " HIT产品类别不存在");
                }
            });

            $.ajax({
                type: "GET",
                url: "/Api/Products?CategoryId=" + categoryId,
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
                    $("#products .container").html("<p class='line gray center'>还没有一条评价，<span class='green'>发布你的观点和意见</span></p>")
                }
            });

            $("#products .more").click(function() {
                $.ajax({
                    type: "GET",
                    url: "/Api/Products?VendorId=" + categoryId,
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

    <div id="the_category"></div>

    <div id="products">
        <p class="gray_background">HIT产品信息</p>
        <br />
        <div class="container"></div>

        <div class="more line big_buttons one_click_buttons hidden">
            <a href="#more">更多</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <input class="mini_search tip_search" value="查询HIT产品类别" action="/Category/Search?api=/Api/Categories?Title="  title="Enter直接查询">
</asp:Content>
