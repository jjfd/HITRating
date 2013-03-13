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
    public class RestfulVendorController : Controller
    {
        private RestfulModels.Vendor RestfulVendor { get; set; }

        protected override void Initialize(RequestContext requestContext)
        {
            RestfulVendor = new RestfulModels.Vendor();
            base.Initialize(requestContext);
        }

        [HttpGet]
        public ActionResult List(Models.VendorSearchModel conditions, int count = 20)
        {
            try
            {
                var vendors = RestfulVendor.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (vendors == null || vendors.Count() < 1) {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Vendor.List(vendors, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult MiniList(Models.VendorSearchModel conditions, int count = 20)
        {
            try
            {
                var vendors = RestfulVendor.Search(conditions, 0, count, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (vendors == null || vendors.Count() < 1)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entities = RestfulJsonProccessor.Vendor.MiniList(vendors, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var vendor = RestfulVendor.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (vendor == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Vendor.Single(vendor, User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                var vendor = RestfulVendor.Read(id, User.Identity.IsAuthenticated ? User.Identity.Name : null);

                if (vendor == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = RestfulJsonProccessor.Vendor.MiniSingle(vendor)
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
        public ActionResult Create(Models.Vendor data)
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
                        Entity = RestfulJsonProccessor.Vendor.Single(RestfulVendor.Create(data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
        public ActionResult Edit(int id, Models.Vendor data)
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
                        Entity = RestfulJsonProccessor.Vendor.Single(RestfulVendor.Update(id, data, User.Identity.IsAuthenticated ? User.Identity.Name : null), User.Identity.IsAuthenticated ? User.Identity.Name : null)
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
                if (RestfulVendor.Delete(id, User.Identity.IsAuthenticated ? User.Identity.Name : null))
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