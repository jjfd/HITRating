using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace HitRating.Models
{
    public partial class Product
    {
        public Models.Vendor Vendor { get; set; }
        public Models.Category Category { get; set; }
    }

    public class ProductSearchModel : Product
    {
        public int IdUpper { get; set; }
        public int IdLower { get; set; }
    }
}