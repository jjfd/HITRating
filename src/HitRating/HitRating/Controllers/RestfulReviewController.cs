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
    public class RestfulReviewController : Controller
    {
        private RestfulModels.Review RestfulReview { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulReview = new RestfulModels.Review();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.ReviewSearchModel conditions, int count = 20)
        {
            try
            {
                var reviews = RestfulReview.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (reviews == null || reviews.Count() < 1)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Review.List(reviews, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult MiniList(Models.ReviewSearchModel conditions, int count = 20)
        {
            try
            {
                var reviews = RestfulReview.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (reviews == null || reviews.Count() < 1)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Review.MiniList(reviews, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var review = RestfulReview.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (review == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Review.Single(review, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var review = RestfulReview.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (review == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Review.MiniSingle(review)
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
        public ActionResult Create(Models.ReviewModels data)
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
                        Entity = RestfulJsonProccessor.Review.Single(RestfulReview.Create(data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult Edit(int id, Models.ReviewModels data)
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
                        Entity = RestfulJsonProccessor.Review.Single(RestfulReview.Update(id, data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                if (RestfulReview.Delete(id, User.Identity.IsAuthenticated ? User.Identity.Name : null))
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