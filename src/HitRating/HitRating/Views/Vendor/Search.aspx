<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	查询HIT供应商信息
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
                        $("#vendors .container").append($.renderVendor(entities[i]));
                    }

                    if (entities.length >= 20) {
                        $("#vendors .more").show();
                    }
                },
                error: function() {
                    $("#vendors .container").html("<p class='line gray center'>没有找到一条HIT供应商信息</p>")
                }
            });

            $("#vendors .more").click(function() {
                $.ajax({
                    type: "GET",
                    url: api,
                    data: { IdLower: $("#vendors .container .vendor_instant:last").attr("object_id") },
                    dataType: "json",
                    success: function(data) {
                        var entities = data.Entities;

                        for (var i=0; i<entities.length; i++) {
                            $("#vendors .container").append($.renderVendor(entities[i]));
                        }

                        if (entities.length < 20) {
                            $("#vendors .more").hide();
                        }

                        $.enableButtons($("#vendors .more").parent());
                    },
                    error: function() {
                        $("#vendors .container").append("<p class='line gray center'>没有更多了</p>")
                        $("#vendors .more").hide();
                    }
                });
            })
        })
    </script>

    <div id="vendors">
        <div class="container"></div>

        <div class="line big_buttons one_click_buttons hidden">
            <a href="#more" class="more">更多HIT供应商</a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="AsideContent" runat="server">
    <input class="mini_search tip_search" value="查询HIT供应商" action="/Vendor/Search?api=/Api/Vendors?Title="  title="Enter直接查询">
</asp:Content>
