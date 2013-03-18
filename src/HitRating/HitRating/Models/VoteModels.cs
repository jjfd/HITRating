using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace HitRating.Models
{
    public class VoteSearchModel : Vote
    {
        public int IdUpper { get; set; }
        public int IdLower { get; set; }
    }
}