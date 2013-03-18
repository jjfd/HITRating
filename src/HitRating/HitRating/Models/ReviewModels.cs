using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace HitRating.Models
{
    public partial class ReviewModels
    {
        public Models.Product Product { get; set; }
    }

    public class ReviewSearchModel : ReviewModels
    {
        public int IdUpper { get; set; }
        public int IdLower { get; set; }
        public int? RateGT { get; set; } // Rate >=
        public int? RateLT { get; set; } // Rate <=
    }
}