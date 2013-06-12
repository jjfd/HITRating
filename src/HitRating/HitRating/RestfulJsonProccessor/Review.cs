using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class Review
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

        public static object MiniList(IEnumerable<Models.Review> data, string userName)
        {
            try
            {
                IList<object> ts = new List<object>();
                foreach (var t in data)
                {
                    ts.Add(MiniSingle(t));
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
            return DataProcess(data, userName);
        }

        public static object MiniSingle(Models.Review data)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    Title = data.Creator + "@" + data.Product.Title + " " + data.Product.Version + "(" + data.Product.Vendor.Title + ")"
                };
            }
            catch
            {
                return null;
            }
        }

        private static object DataProcess(Models.Review data, string userName)
        {
            try
            {
                object voted = null;
                try
                {
                    if (!string.IsNullOrEmpty(userName))
                    {
                        var vote = (new RestfulModels.Vote()).First(new Models.VoteSearchModel() { Creator = userName, ReviewId = data.Id }, userName);
                        if (vote != null)
                        {
                            voted = RestfulJsonProccessor.Vote.Single(vote, userName);
                        }
                    }
                    else
                    {
                        voted = "not_allowed";
                    }
                }
                catch
                {
                    ;
                }

                IList<object> ratedAspects = new List<object>(); 
                try
                {
                    string[] aspects = Utilities.StringUtility.DeGroup(data.RatedAspects, ';');
                    for (int i = 0; i < aspects.Count(); i++) {
                        string[] aspectData = Utilities.StringUtility.DeGroup(aspects[i], '|');

                        ratedAspects.Add(new {
                           Id = int.Parse(aspectData[0]),
                           Title = aspectData[1],
                           Rate = int.Parse(aspectData[2])
                        });
                    }
                }
                catch
                {
                   ratedAspects = null;
                }

                return new
                {
                    Id = data.Id,
                    Product = RestfulJsonProccessor.Product.MiniSingle(data.Product),
                    Type = Models.ReviewType.Review,
                    Rate = data.Rate,
                    Details = data.Details,
                    Creator = RestfulJsonProccessor.Account.MiniSingle(data.Creator),
                    Created = data.Created.ToString(),
                    Updated = data.Updated.ToString(),
                    RatedAspects = ratedAspects,

                    Vote = voted,

                    Options = ControlProcess(data, userName)
                };
            }
            catch
            {
                throw;
            }
        }

        public static IList<RestfulJsonProccessor.RestfulOption> ControlProcess(Models.Review data, string userName)
        {
            try
            {
                if (userName == data.Creator)
                {
                    var options = new List<RestfulJsonProccessor.RestfulOption>();

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption() 
                        { 
                            Object = "Review",
                            ObjectId = data.Id,
                            ActionId = "Edit_Review",
                            ActionName = "修改",
                            ActionDefinition = "修改产品评价",
                            ActionType = Models.RestfulAction.Update,
                            HttpMethod = "PUT",
                            Uri = Models.ApplicationConfig.Domain + "Api/Review/" + data.Id
                        }
                    );

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption()
                        {
                            Object = "Review",
                            ObjectId = data.Id,
                            ActionId = "Delete_Review",
                            ActionName = "删除",
                            ActionDefinition = "删除产品评价",
                            ActionType = Models.RestfulAction.Delete,
                            HttpMethod = "DELETE",
                            Uri = Models.ApplicationConfig.Domain + "Api/Review/" + data.Id
                        }
                    );

                    return options;
                }
                else
                {
                    return null;
                }
            }
            catch {
                return null;
            }
        }
    }
}