﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HitRating.Controllers
{
    public class AccountController : Controller
    {
        public ActionResult Home()
        {
            if (!User.Identity.IsAuthenticated) {
                return RedirectToAction("Index", "Home");
            }

            if ((new Models.AccountMembershipService()).IsAdmin(User.Identity.Name)) {
                return View("AdminHome");
            }

            return View();
        }

        public ActionResult Manage() {
            if (!User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Home");
            }

            return View();
        }
    }
}
