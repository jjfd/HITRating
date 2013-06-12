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
    public class RestfulNewsController : Controller
    {
        private RestfulModels.News RestfulNews { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulNews = new RestfulModels.News();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.ReviewSearchModel conditions, int count = 20)
        {
            try
            {
                var newss = RestfulNews.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (newss == null || newss.Count() < 1)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.News.List(newss, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var news = RestfulNews.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (news == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.News.Single(news, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult Create(Models.Review data)
        {
            try
            {
                if (!string.IsNullOrEmpty(data.Details))
                {
                    data.Details = Utilities.StringUtility.EscapeXml(System.Web.HttpUtility.HtmlDecode(data.Details));
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.News.Single(RestfulNews.Create(data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult Edit(int id, Models.Review data)
        {
            try
            {
                if (!string.IsNullOrEmpty(data.Details))
                {
                    data.Details = Utilities.StringUtility.EscapeXml(System.Web.HttpUtility.HtmlDecode(data.Details));
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.News.Single(RestfulNews.Update(id, data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                if (RestfulNews.Delete(id, User.Identity.IsAuthenticated ? User.Identity.Name : null))
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