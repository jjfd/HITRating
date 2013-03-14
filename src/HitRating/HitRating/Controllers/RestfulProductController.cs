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
    public class RestfulProductController : Controller
    {
        private RestfulModels.Product RestfulProduct { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulProduct = new RestfulModels.Product();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.ProductSearchModel conditions, int count = 20)
        {
            try
            {
                var products = RestfulProduct.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (products == null || products.Count() < 1) {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Product.List(products, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult MiniList(Models.ProductSearchModel conditions, int count = 20)
        {
            try
            {
                var products = RestfulProduct.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (products == null || products.Count() < 1)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Product.MiniList(products, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var product = RestfulProduct.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (product == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Product.Single(product, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var product = RestfulProduct.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (product == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Product.MiniSingle(product)
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
        public ActionResult Create(Models.Product data)
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
                        Entity = RestfulJsonProccessor.Product.Single(RestfulProduct.Create(data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult Edit(int id, Models.Product data)
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
                        Entity = RestfulJsonProccessor.Product.Single(RestfulProduct.Update(id, data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                if (RestfulProduct.Delete(id, User.Identity.IsAuthenticated ? User.Identity.Name : null))
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