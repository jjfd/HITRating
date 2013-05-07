using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class Aspect
    {
        public static object List(IEnumerable<Models.Aspect> data, string userName)
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

        public static object Single(Models.Aspect data, string userName) 
        {
            return DataProcess(data, userName);
        }

        private static object DataProcess(Models.Aspect data, string userName)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    CategoryId = data.CategoryId,
                    Title = data.Title,
                    RatedTimes = data.RatedTimes,
                    Creator = RestfulJsonProccessor.Account.MiniSingle(data.Creator),
                    Created = data.Created.ToString(),

                    Options = ControlProcess(data, userName)
                };
            }
            catch
            {
                throw;
            }
        }

        public static IList<RestfulJsonProccessor.RestfulOption> ControlProcess(Models.Aspect data, string userName)
        {
            try
            {
                return null;
            }
            catch {
                return null;
            }
        }
    }
}