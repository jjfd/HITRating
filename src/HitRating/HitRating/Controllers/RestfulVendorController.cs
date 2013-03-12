﻿using System;
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
                Response.StatusCode = 400;
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

        [HttpPost]
        public ActionResult Create(Models.RegisterModel data)
        {
            try
            {
                try
                {
                    MembershipCreateStatus createStatus = MembershipService.CreateUser(data.UserName, data.Password, data.Email);

                    FormsService.SignIn(data.UserName, true);

                    Response.StatusCode = 200;
                    return RedirectToAction("Read", new { userName = data.UserName });
                }
                catch (Exception e)
                {
                    ModelState.AddModelError("", e.Message);
                }

                Response.StatusCode = 406;
                return null;
            }
            catch
            {
                Response.StatusCode = 500;
                return null;
            }
        }

        [HttpDelete]
        public ActionResult Delete(string userName) {
            try
            {
                if ((!User.Identity.IsAuthenticated) || (userName != User.Identity.Name))
                {
                    throw new RestfulModels.NoAccessException();
                }

                (new Models.AccountMembershipService()).DeleteUser(userName);

                return null;
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
        public ActionResult LogOn(Models.LogOnModel data)
        {
            try
            {
                if (data.UserName.Contains("@"))
                {
                    if ((data.UserName = MembershipService.GetUserNameByEmail(data.UserName)) == null)
                    {
                        ModelState.AddModelError("", "用户名 或 密码不正确");

                        Response.StatusCode = 406;
                        return null;
                    }
                }

                if (MembershipService.ValidateUser(data.UserName, data.Password))
                {
                    FormsService.SignIn(data.UserName, data.RememberMe);

                    Response.StatusCode = 200;
                    return null;
                }
                else
                {
                    ModelState.AddModelError("", "用户名 或 密码不正确");
                }

                Response.StatusCode = 406;
                return null;
            }
            catch
            {
                Response.StatusCode = 500;
                return null;
            }
        }

        [HttpDelete]
        public ActionResult LogOut()
        {
            try
            {
                FormsService.SignOut();

                Response.StatusCode = 200;
                return null;
            }
            catch
            {
                Response.StatusCode = 500;
                return null;
            }
        }

        [HttpGet]
        public ActionResult Email(string userName)
        {
            try
            {
                if ((!User.Identity.IsAuthenticated) || (userName != User.Identity.Name))
                {
                    throw new RestfulModels.NoAccessException();
                }
                
                string email = (new Models.AccountMembershipService()).GetEmail(userName);
                return Json
                (
                    new
                    {
                        Entity = new { Email = email, Options = "" }
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
        public ActionResult Photo(string userName)
        {
            try
            {
                var t = (new Models.Entities()).aspnet_Users.First(m => m.UserName == userName);

                if (t == null)
                {
                    throw new Exception("NO FOUND");
                }

                return Json
                (
                    new
                    {
                        Entity = new { Photo = t.PhotoUrl, Options = "" }
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

        [HttpPut]
        public ActionResult SetEmail(string userName, string email)
        {
            try
            {
                if ((!User.Identity.IsAuthenticated) || (userName != User.Identity.Name))
                {
                    throw new RestfulModels.NoAccessException();
                }

                (new Models.AccountMembershipService()).SetEmail(userName, email);
                return null;
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

        [HttpPut]
        public ActionResult SetPhoto(string userName, string photo)
        {
            try
            {
                if ((!User.Identity.IsAuthenticated) || (userName != User.Identity.Name))
                {
                    throw new RestfulModels.NoAccessException();
                }

                (new Models.AccountMembershipService()).SetPhotoUrl(userName, photo);
                return Json
                (
                    new
                    {
                        Entity = new { Photo = photo, Options = "" }
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

        [HttpPut]
        public ActionResult ChangePassword(string userName, Models.ChangePasswordModel model)
        {
            try
            {
                if ((!User.Identity.IsAuthenticated) || (userName != User.Identity.Name))
                {
                    throw new RestfulModels.NoAccessException();
                }

                if (MembershipService.ChangePassword(User.Identity.Name, model.OldPassword, model.NewPassword))
                {
                    Response.StatusCode = 200;
                    return null;
                }
                else
                {
                    throw new Exception();
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

        [HttpGet]
        public ActionResult IsLogged() {
            if (User.Identity.IsAuthenticated)
            {
                Response.StatusCode = 200;
                return null;
            }
            else
            {
                Response.StatusCode = 404;
                return null;
            }
        }
    }
}