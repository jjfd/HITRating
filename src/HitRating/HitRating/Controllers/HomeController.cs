using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace HitRating.Controllers
{
    [HandleError]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Home", "Account");
            }

            return View();
        }

        public ActionResult About()
        {
            return View();
        }

        public ActionResult Find(string key = "") {
            ViewData["Key"] = key;

            return View();
        }

        public ActionResult Test()
        {
            return View();
        }
    }
}
