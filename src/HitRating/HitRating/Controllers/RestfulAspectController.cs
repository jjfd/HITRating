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
    public class RestfulAspectController : Controller
    {
        private RestfulModels.Aspect RestfulAspect { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulAspect = new RestfulModels.Aspect();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.AspectSearchModel conditions, int count = 20)
        {
            try
            {
                var apsects = RestfulAspect.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (apsects == null || apsects.Count() < 1) {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Aspect.List(apsects, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var aspect = RestfulAspect.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (aspect == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Aspect.Single(aspect, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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

        [HttpPost]
        public ActionResult Create(Models.Aspect data)
        {
            try
            {
                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Aspect.Single(RestfulAspect.Create(data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
                    },
                    JsonRequestBehavior.AllowGet
                );
            }
            catch (RestfulModels.NoAccessException)
            {
                Response.StatusCode = 401;
                return null;
            }
            catch (RestfulModels.ValidationException e)
            {
                Response.StatusCode = 406;
                return Json
                (
                    new
                    {
                        ValidationErrors = e
                    },
                    JsonRequestBehavior.AllowGet
                );

            }
            catch
            {
                Response.StatusCode = 500;
                return null;
            }
        }
    }
}