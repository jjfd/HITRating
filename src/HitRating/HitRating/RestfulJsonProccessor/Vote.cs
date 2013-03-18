using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class Vote
    {
        public static object List(IEnumerable<Models.Vote> data, string userName)
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

        public static object Single(Models.Vote data, string userName) 
        {
            return DataProcess(data, userName);
        }

        private static object DataProcess(Models.Vote data, string userName)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    ReviewId = data.ReviewId,
                    Supportive = data.Supportive,
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

        public static IList<RestfulJsonProccessor.RestfulOption> ControlProcess(Models.Vote data, string userName)
        {
            try
            {
                if ((new Models.AccountMembershipService()).IsAdmin(userName))
                {
                    var options = new List<RestfulJsonProccessor.RestfulOption>();

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption()
                        {
                            Object = "Vote",
                            ObjectId = data.Id,
                            ActionId = "Delete_Vote",
                            ActionName = "删除",
                            ActionDefinition = "删除投票",
                            ActionType = Models.RestfulAction.Delete,
                            HttpMethod = "DELETE",
                            Uri = Models.ApplicationConfig.Domain + "Api/Vote/" + data.Id
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