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
    public class RestfulCategoryController : Controller
    {
        private RestfulModels.Category RestfulCategory { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulCategory = new RestfulModels.Category();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.CategorySearchModel conditions, int count = 20)
        {
            try
            {
                var cats = RestfulCategory.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (cats == null || cats.Count() < 1) {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Category.List(cats, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult MiniList(Models.CategorySearchModel conditions, int count = 20)
        {
            try
            {
                var cats = RestfulCategory.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (cats == null || cats.Count() < 1)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Category.MiniList(cats, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var cat = RestfulCategory.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (cat == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Category.Single(cat, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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

        [HttpGet]
        public ActionResult MiniRead(int id)
        {
            try
            {
                var cat = RestfulCategory.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (cat == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Category.MiniSingle(cat)
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
        public ActionResult Create(Models.Category data)
        {
            try
            {
                if (!string.IsNullOrEmpty(data.Description))
                {
                    data.Description = Utilities.StringUtility.EscapeXml(System.Web.HttpUtility.HtmlDecode(data.Description));
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Category.Single(RestfulCategory.Create(data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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

        [HttpPut]
        public ActionResult Edit(int id, Models.Category data)
        {
            try
            {
                if (!string.IsNullOrEmpty(data.Description))
                {
                    data.Description = Utilities.StringUtility.EscapeXml(System.Web.HttpUtility.HtmlDecode(data.Description));
                }
                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Category.Single(RestfulCategory.Update(id, data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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

        [HttpDelete]
        public ActionResult Delete(int id)
        {
            try
            {
                if (RestfulCategory.Delete(id, User.Identity.IsAuthenticated ? User.Identity.Name : null))
                {
                    Response.StatusCode = 200;
                    return null;
                }
                else
                {
                    Response.StatusCode = 401;
                    return null;
                }
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