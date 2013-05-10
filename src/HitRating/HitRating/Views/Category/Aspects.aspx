<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Aspect
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
                    var thisCate = data.Entity;
                    $("#the_category").html($.renderCategory(data.Entity));
                    $("#the_category .toggle").click().remove();

                    $.ajax({
                        type: "GET",
                        url: "/Api/Categories",
                        dataType: "json",
                        success: function(datas) {
                            for (var i=0; i<datas.Entities.length; i++) {
                                if (datas.Entities[i].Id != thisCate.Id) {
                                    $("#other_category_aspects").append("<p class='small line'><a href='/Category/Aspects/" + datas.Entities[i].Id + "'>" +　datas.Entities[i].Abbreviation + " (" + datas.Entities[i].Title　+ ") >></p>")
                                }
                            }
                        }
                    })

                    $("#the_category nav .taction:last").remove();
                },
                error: function() {
                    $.miniErrorAjaxResult("#" + categoryId + " HIT产品类别不存在");
                }
            });

            $.ajax({
                type: "GET",
                url: "/Api/Aspects?CategoryId=" + categoryId + "&Count=-1",
                dataType: "json",
                success: function(data) {
                    var entities = data.Entities;

                    for (var i=0; i<entities.length; i++) {
                        $("#aspects .container").append($.renderAspect(entities[i]));
                    }
                },
                error: function() {
                    $("#aspects .container").html("<p class='line gray center'>还没有一条评价标准信息!</p>")
                }
            });
        })
    </script>

    <div id="the_category"></div>

    <div id="aspects">
        <p class="gray_background"><span class="red small float_right">Alpha</span>评价标准集</p>
        <br />
        <div class="container"></div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <p class="small gray">其他标准评价集</p>
    <div id="other_category_aspects">
    
    </div>
</asp:Content>
