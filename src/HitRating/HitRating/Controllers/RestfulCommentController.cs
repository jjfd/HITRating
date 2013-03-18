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
    public class RestfulCommentController : Controller
    {
        private RestfulModels.Comment RestfulComment { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulComment = new RestfulModels.Comment();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.CommentSearchModel conditions, int count = 20)
        {
            try
            {
                var comments = RestfulComment.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (comments == null || comments.Count() < 1) {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Comment.List(comments, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var comment = RestfulComment.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (comment == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Comment.Single(comment, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult Create(Models.Comment data)
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
                        Entity = RestfulJsonProccessor.Comment.Single(RestfulComment.Create(data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult Edit(int id, Models.Comment data)
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
                        Entity = RestfulJsonProccessor.Comment.Single(RestfulComment.Update(id, data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                if (RestfulComment.Delete(id, User.Identity.IsAuthenticated ? User.Identity.Name : null))
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