﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HitRating.Controllers
{
    public class ReviewController : Controller
    {
        public ActionResult Details(int id) {
            ViewData["Id"] = id;
            return View();
        }

        public ActionResult Search(string api = null) {
            if (string.IsNullOrEmpty(api)) {
                api = "/Api/Reviews";
            }

            ViewData["Api"] = api;
            return View();
        }
    }
}
