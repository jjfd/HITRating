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
    public class RestfulRateController : Controller
    {
        private RestfulModels.Rate RestfulRate { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulRate = new RestfulModels.Rate();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.RateSearchModel conditions, int count = 20)
        {
            try
            {
                var votes = RestfulRate.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (votes == null || votes.Count() < 1) {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Rate.List(votes, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var rate = RestfulRate.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (rate == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Rate.Single(rate, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult Create(Models.Rate data)
        {
            try
            {
                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Rate.Single(RestfulRate.Create(data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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