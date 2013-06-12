using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class ProductInfo
    {
        public static object List(IEnumerable<Models.Review> data, string userName)
        {
            try
            {
                IList<object> ts = new List<object>();
                foreach (var t in data)
                { 
                    ts.Add(Single(t, userName));
                }

                return ts;
            }
            catch
            {
                throw;
            }
        }

        public static object Single(Models.Review data, string userName) 
        {
            if (data.Type == Models.ReviewType.Review)
            {
                return Review.Single(data, userName);
            }
            else if (data.Type == Models.ReviewType.News)
            {
                return News.Single(data, userName);
            }
            else
            {
                return null;
            }
        }
    }
}