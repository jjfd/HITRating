using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using System.Xml;

namespace HitRating.Controllers
{
    public class RestfulProductInfoController : Controller
    {
        private RestfulModels.ProductInfo RestfulProductInfo { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulProductInfo = new RestfulModels.ProductInfo();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.ReviewSearchModel conditions, int count = 20)
        {
            try
            {
                var newss = RestfulProductInfo.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (newss == null || newss.Count() < 1)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.ProductInfo.List(newss, User.Identity.IsAuthenticated ? User.Identity.Name : null)
                    },
                    JsonRequestBehavior.AllowGet
                );
            }
            catch
            {
                Response.StatusCode = 404;
                return null;
            }
        }

        [HttpGet]
        public ActionResult Read(int id)
        {
            try
            {
                var news = RestfulProductInfo.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (news == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.ProductInfo.Single(news, User.Identity.IsAuthenticated ? User.Identity.Name : null)
                    },
                    JsonRequestBehavior.AllowGet
                );
            }
            catch (RestfulModels.NoAccessException)
            {
                Response.StatusCode = 401;
                return null;
            }
            catch
            {
                Response.StatusCode = 404;
                return null;
            }
        }
    }
}