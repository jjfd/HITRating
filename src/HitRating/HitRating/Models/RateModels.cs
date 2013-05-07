using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace HitRating.Models
{
    public class RateSearchModel : Rate
    {
        public int IdUpper { get; set; }
        public int IdLower { get; set; }
        public int? StarsGt { get; set; }
        public int? StarsLt { get; set; }
    }
}