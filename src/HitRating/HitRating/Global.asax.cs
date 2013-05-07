using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Tword
{
    // 注意: 有关启用 IIS6 或 IIS7 经典模式的说明，
    // 请访问 http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            //Apies of Account
            routes.MapRoute(
                "AccountSearch",
                "Api/Accounts",
                new { controller = "RestfulAccount", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "AccountRead",
                "Api/Account/{userName}",
                new { controller = "RestfulAccount", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "AccountCreate",
                "Api/Accounts",
                new { controller = "RestfulAccount", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "AccountDelete",
                "Api/Account/{userName}",
                new { controller = "RestfulAccount", action = "Delete" },
                new { Grendal = new HttpMethodConstraint("DELETE") }
            );

            routes.MapRoute(
                "AccountLogOn",
                "Api/Account/{userName}/Session",
                new { controller = "RestfulAccount", action = "LogOn" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "AccountLogOut",
                "Api/Account/{userName}/Session",
                new { controller = "RestfulAccount", action = "LogOut" },
                new { Grendal = new HttpMethodConstraint("DELETE") }
            );

            routes.MapRoute(
                "AccountLogStatusCheck",
                "Api/Account/{userName}/Session",
                new { controller = "RestfulAccount", action = "IsLogged" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "AccountEmailRead",
                "Api/Account/{userName}/Email",
                new { controller = "RestfulAccount", action = "Email" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "AccountPhotoRead",
                "Api/Account/{userName}/Photo",
                new { controller = "RestfulAccount", action = "Photo" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "AccountEmailEdit",
                "Api/Account/{userName}/Email",
                new { controller = "RestfulAccount", action = "SetEmail" },
                new { Grendal = new HttpMethodConstraint("PUT") }
            );

            routes.MapRoute(
                "AccountPhotoEdit",
                "Api/Account/{userName}/Photo",
                new { controller = "RestfulAccount", action = "SetPhoto" },
                new { Grendal = new HttpMethodConstraint("PUT") }
            );

            routes.MapRoute(
                "AccountChangePassword",
                "Api/Account/{userName}/Password",
                new { controller = "RestfulAccount", action = "ChangePassword" },
                new { Grendal = new HttpMethodConstraint("PUT") }
            );

            //apies of verdor
            routes.MapRoute(
                "VendorSearch",
                "Api/Vendors",
                new { controller = "RestfulVendor", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "MiniVendorSearch",
                "Api/MiniVendors",
                new { controller = "RestfulVendor", action = "MiniList" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "VendorRead",
                "Api/Vendor/{id}",
                new { controller = "RestfulVendor", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "MiniVendorRead",
                "Api/MiniVendor/{id}",
                new { controller = "RestfulVendor", action = "MiniRead" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "VendorCreate",
                "Api/Vendors",
                new { controller = "RestfulVendor", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "VendorEdit",
                "Api/Vendor/{id}",
                new { controller = "RestfulVendor", action = "Edit" },
                new { Grendal = new HttpMethodConstraint("PUT") }
            );

            routes.MapRoute(
                "VendorDelete",
                "Api/Vendor/{id}",
                new { controller = "RestfulVendor", action = "Delete" },
                new { Grendal = new HttpMethodConstraint("DELETE") }
            );

            //apies of category
            routes.MapRoute(
                "CategorySearch",
                "Api/Categories",
                new { controller = "RestfulCategory", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "MiniCategorySearch",
                "Api/MiniCategories",
                new { controller = "RestfulCategory", action = "MiniList" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "CategoryRead",
                "Api/Category/{id}",
                new { controller = "RestfulCategory", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "MiniCategoryRead",
                "Api/MiniCategory/{id}",
                new { controller = "RestfulCategory", action = "MiniRead" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "CategoryCreate",
                "Api/Categories",
                new { controller = "RestfulCategory", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "CategoryEdit",
                "Api/Category/{id}",
                new { controller = "RestfulCategory", action = "Edit" },
                new { Grendal = new HttpMethodConstraint("PUT") }
            );

            routes.MapRoute(
                "CategoryDelete",
                "Api/Category/{id}",
                new { controller = "RestfulCategory", action = "Delete" },
                new { Grendal = new HttpMethodConstraint("DELETE") }
            );

            //apies of product
            routes.MapRoute(
                "ProductSearch",
                "Api/Products",
                new { controller = "RestfulProduct", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "ProductSearchOfVendor",
                "Api/Vendor/{vendorId}/Products",
                new { controller = "RestfulProduct", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "ProductSearchOfCategory",
                "Api/Category/{categoryId}/Products",
                new { controller = "RestfulProduct", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "ProductSearchOfVendorOfCategory",
                "Api/Vendor/{vendorId}/Category/{categoryId}/Products",
                new { controller = "RestfulProduct", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "MiniProductSearch",
                "Api/MiniProducts",
                new { controller = "RestfulProduct", action = "MiniList" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "ProductRead",
                "Api/Product/{id}",
                new { controller = "RestfulProduct", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "MiniProductRead",
                "Api/MiniProduct/{id}",
                new { controller = "RestfulProduct", action = "MiniRead" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "ProductCreate",
                "Api/Products",
                new { controller = "RestfulProduct", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "ProductEdit",
                "Api/Product/{id}",
                new { controller = "RestfulProduct", action = "Edit" },
                new { Grendal = new HttpMethodConstraint("PUT") }
            );

            routes.MapRoute(
                "ProductDelete",
                "Api/Product/{id}",
                new { controller = "RestfulProduct", action = "Delete" },
                new { Grendal = new HttpMethodConstraint("DELETE") }
            );

            //apies of review
            routes.MapRoute(
                "ReviewSearch",
                "Api/Reviews",
                new { controller = "RestfulReview", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "ReviewSearchOfProduct",
                "Api/Product/{productId}/Reviews",
                new { controller = "RestfulReview", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "MiniReviewSearch",
                "Api/MiniReviews",
                new { controller = "RestfulReview", action = "MiniList" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "ReviewRead",
                "Api/Review/{id}",
                new { controller = "RestfulReview", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "MiniReviewRead",
                "Api/MiniReview/{id}",
                new { controller = "RestfulReview", action = "MiniRead" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "ReviewCreate",
                "Api/Reviews",
                new { controller = "RestfulReview", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "ReviewEdit",
                "Api/Review/{id}",
                new { controller = "RestfulReview", action = "Edit" },
                new { Grendal = new HttpMethodConstraint("PUT") }
            );

            routes.MapRoute(
                "ReviewDelete",
                "Api/Review/{id}",
                new { controller = "RestfulReview", action = "Delete" },
                new { Grendal = new HttpMethodConstraint("DELETE") }
            );

            //apies of comment
            routes.MapRoute(
                "CommentSearch",
                "Api/Comments",
                new { controller = "RestfulComment", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "CommentSearchOfReview",
                "Api/Review/{reviewId}/Comments",
                new { controller = "RestfulComment", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "CommentRead",
                "Api/Comment/{id}",
                new { controller = "RestfulComment", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "CommentCreate",
                "Api/Comments",
                new { controller = "RestfulComment", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "CommentEdit",
                "Api/Comment/{id}",
                new { controller = "RestfulComment", action = "Edit" },
                new { Grendal = new HttpMethodConstraint("PUT") }
            );

            routes.MapRoute(
                "CommentDelete",
                "Api/Comment/{id}",
                new { controller = "RestfulComment", action = "Delete" },
                new { Grendal = new HttpMethodConstraint("DELETE") }
            );

            //apies of vote
            routes.MapRoute(
                "VoteSearch",
                "Api/Votes",
                new { controller = "RestfulVote", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "VoteSearchOfReview",
                "Api/Review/{reviewId}/Votes",
                new { controller = "RestfulVote", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "VoteRead",
                "Api/Vote/{id}",
                new { controller = "RestfulVote", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "VoteCreate",
                "Api/Votes",
                new { controller = "RestfulVote", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "VoteDelete",
                "Api/Vote/{id}",
                new { controller = "RestfulVote", action = "Delete" },
                new { Grendal = new HttpMethodConstraint("DELETE") }
            );

            //apies of aspect
            routes.MapRoute(
                "AspectSearch",
                "Api/Aspects",
                new { controller = "RestfulAspect", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "AspectSearchOfCategory",
                "Api/Category/{categoryId}/Aspects",
                new { controller = "RestfulAspect", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "AspectRead",
                "Api/Aspect/{id}",
                new { controller = "RestfulAspect", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "AspectCreate",
                "Api/Aspects",
                new { controller = "RestfulAspect", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            //apies of rate
            routes.MapRoute(
                "RateSearch",
                "Api/Rate",
                new { controller = "RestfulRate", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "RateSearchOfCategory",
                "Api/Aspect/{AspectId}/Rates",
                new { controller = "RestfulRate", action = "List" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "RateRead",
                "Api/Rate/{id}",
                new { controller = "RestfulRate", action = "Read" },
                new { Grendal = new HttpMethodConstraint("GET") }
            );

            routes.MapRoute(
                "RateCreate",
                "Api/Rates",
                new { controller = "RestfulRate", action = "Create" },
                new { Grendal = new HttpMethodConstraint("POST") }
            );

            routes.MapRoute(
                "Default", // 路由名称
                "{controller}/{action}/{id}", // 带有参数的 URL
                new { controller = "Home", action = "Index", id = UrlParameter.Optional } // 参数默认值
            );
        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);
        }
    }
}