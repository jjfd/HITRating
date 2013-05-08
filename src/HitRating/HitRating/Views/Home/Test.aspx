<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Welcome to HitRating, <%: Page.User.Identity.Name %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Welcome to HitRating.TestPanels, <%: Page.User.Identity.Name %></h2>

    <div id="test_vendor">
        <a href="#create_vendor" class="taction" object="Vendor" taction_type="1" taction_id="Create_Vendor" method="POST" api="/Api/Vendors" title="创建供应商信息">创建供应商信息</a>
        <a href="#read_vendor" class="taction" object="Vendor" object_id="5" taction_type="2" taction_id="Read_Vendor" method="GET" api="/Api/Vendor/5" title="查看供应商信息">查看供应商信息</a>
        <a href="#edit_vendor" class="taction" object="Vendor" object_id="5" taction_type="3" taction_id="Edit_Vendor" method="PUT" api="/Api/Vendor/5" title="修改供应商信息">修改供应商信息</a>
        <a href="#search_vendor" class="taction" object="Vendor" taction_type="5" taction_id="Search_Vendor" method="GET" api="/Api/Vendors" title="查询供应商信息">查询供应商信息</a>
        <div id="vendor_5">
            <script type="text/javascript">
                $(function () {
                    $.ajax({
                        type: "GET",
                        url: "/Api/Vendor/" + 5,
                        dataType: "json",
                        success: function (data) {
                            $("#vendor_5").append($.renderVendor(data.Entity));
                        }
                    })
                })
            </script>
        </div>
    </div>

    <div id="test_category">
        <a href="#create_category" class="taction" object="Category" taction_type="1" taction_id="Create_Category" method="POST" api="/Api/Categories" title="创建HIT产品类别">创建HIT产品类别</a>
        <a href="#read_category" class="taction" object="Category" object_id="3" taction_type="2" taction_id="Read_Category" method="GET" api="/Api/Category/3" title="查看HIT产品类别">查看HIT产品类别</a>
        <a href="#edit_category" class="taction" object="Category" object_id="3" taction_type="3" taction_id="Edit_Category" method="PUT" api="/Api/Category/3" title="修改HIT产品类别">修改HIT产品类别</a>
        <a href="#search_category" class="taction" object="Category" taction_type="5" taction_id="Search_Category" method="GET" api="/Api/Categories" title="查询HIT产品类别">查询HIT产品类别</a>
    
        <div id="category_3">
            <script type="text/javascript">
                $(function () {
                    $.ajax({
                        type: "GET",
                        url: "/Api/Category/" + 3,
                        dataType: "json",
                        success: function (data) {
                            $("#category_3").append($.renderCategory(data.Entity));
                        }
                    })
                })
            </script>
        </div>
    </div>

    <div id="test_product">
        <a href="#create_product" class="taction" object="Product" taction_type="1" taction_id="Create_Product" method="POST" api="/Api/Products" title="创建HIT产品">创建HIT产品</a>
        <a href="#read_product" class="taction" object="Product" object_id="2" taction_type="2" taction_id="Read_Product" method="GET" api="/Api/Product/2" title="查看HIT产品">查看HIT产品</a>
        <a href="#edit_product" class="taction" object="Product" object_id="2" taction_type="3" taction_id="Edit_Product" method="PUT" api="/Api/Product/2" title="修改HIT产品">修改HIT产品</a>
        <a href="#search_product" class="taction" object="Product" taction_type="5" taction_id="Search_Product" method="GET" api="/Api/Products" title="查询HIT产品">查询HIT产品</a>
        
        <div id="product_2">
            <script type="text/javascript">
                $(function () {
                    $.ajax({
                        type: "GET",
                        url: "/Api/Product/" + 2,
                        dataType: "json",
                        success: function (data) {
                            $("#product_2").append($.renderProduct(data.Entity));
                        }
                    })
                })
            </script>
        </div>
    </div>

    <div id="test_review">
        <script type="text/javascript">
            $(function () {
                $("#test_review .star_input").find(".star").eq(1).mouseover();
                $("#test_review .star_input").attr("disabled", "disabled");
            })
        </script>
        <label>5_star</label>
        <span class="star_input">
            <span class="stars">
                <span class="star">★</span>
                <span class="star">★</span>
                <span class="star">★</span>
                <span class="star">★</span>
                <span class="star">★</span>
            </span>
            <input type="hidden" name="" />
        </span>

        <a href="#create_review" class="taction" object="Review" taction_type="1" taction_id="Create_Review" method="POST" api="/Api/Reviews?ProductId=2" title="创建HIT产品评价">创建HIT产品评价</a>
        <a href="#read_review" class="taction" object="Review" object_id="8" taction_type="2" taction_id="Read_Review" method="GET" api="/Api/Review/8" title="查看HIT产品评价">查看HIT产品评价</a>
        <a href="#edit_review" class="taction" object="Review" object_id="8" taction_type="3" taction_id="Read_Review" method="PUT" api="/Api/Review/8" title="修改HIT产品评价">修改HIT产品评价</a>
        <a href="#search_review" class="taction" object="Review" taction_type="5" taction_id="Search_Review" method="GET" api="/Api/Reviews" title="查询HIT产品评价">查询HIT产品评价</a>
        
        <div id="review_7">
            <script type="text/javascript">
                $(function () {
                    $.ajax({
                        type: "GET",
                        url: "/Api/Review/" + 7,
                        dataType: "json",
                        success: function (data) {
                            $("#review_7").append($.renderReview(data.Entity));
                        }
                    })
                })
            </script>
        </div>
    </div>

    <div id="test_comment">
            <a href="#create_comment" class="taction" object="Comment" taction_type="1" taction_id="Create_Comment" method="POST" api="/Api/Comments?ReviewId=7" title="创建评论">创建评论</a>
            <a href="#read_comment" class="taction" object="Comment" object_id="3" taction_type="2" taction_id="Read_Comment" method="GET" api="/Api/Comment/3" title="查看评论">查看评论</a>
            <a href="#edit_comment" class="taction" object="Comment" object_id="3" taction_type="3" taction_id="Edit_Comment" method="PUT" api="/Api/Comment/3" title="修改评论">修改评论</a>
        
        <div id="comment_4">
            <script type="text/javascript">
                $(function () {
                    $.ajax({
                        type: "GET",
                        url: "/Api/Comment/" + 4,
                        dataType: "json",
                        success: function (data) {
                            $("#comment_4").append($.renderComment(data.Entity));
                        }
                    })
                })
            </script>
        </div>
    </div>

    <div id="test_vote">
        <p class="vote_message small">
            <span class="gray message">你觉得这条HIT产品评价</span>
            <span class="buttons one_click_buttons">
                <a href="#taction" class="taction" object="Vote" object_id="7" taction_type="1" taction_id="Support" method="POST" api="/Api/Votes?ReviewId=7&Supportive=true" title="有用">有用</a>
                <a href="#taction" class="taction" object="Vote" object_id="7" taction_type="1" taction_id="Oppose" method="POST" api="/Api/Votes?ReviewId=7&Supportive=false" title="没用">没用</a>
            </span>
        </p>
    </div>

    <br />
    <br />

    <div id="test_aspect">
        <script type="text/javascript">
            $(function () {
                $("#create_aspect a").click(function () {
                    $.ajax({
                        type: "POST",
                        url: "/Api/Aspects?CategoryId=3",
                        data: { "Title": $("#create_aspect input").val() },
                        dataType: "json",
                        success: function (data) {
                            alert(data.Entity.Title);
                        }
                    })
                })
            })
        </script>
        <div id="create_aspect">
            <input name="Title" />
            <a>Create_aspect</a>
        </div>
    </div>
</asp:Content>
