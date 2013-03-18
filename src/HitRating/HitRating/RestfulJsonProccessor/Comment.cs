using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class Comment
    {
        public static object List(IEnumerable<Models.Comment> data, string userName)
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

        public static object Single(Models.Comment data, string userName) 
        {
            return DataProcess(data, userName);
        }

        private static object DataProcess(Models.Comment data, string userName)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    ReviewId = data.ReviewId,
                    Details = data.Details,
                    Creator = RestfulJsonProccessor.Account.MiniSingle(data.Creator),
                    Created = data.Created.ToString(),
                    Updated = data.Updated.ToString(),

                    Options = ControlProcess(data, userName)
                };
            }
            catch
            {
                throw;
            }
        }

        public static IList<RestfulJsonProccessor.RestfulOption> ControlProcess(Models.Comment data, string userName)
        {
            try
            {
                if ((new Models.AccountMembershipService()).IsAdmin(userName))
                {
                    var options = new List<RestfulJsonProccessor.RestfulOption>();

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption() 
                        { 
                            Object = "Comment",
                            ObjectId = data.Id,
                            ActionId = "Edit_Comment",
                            ActionName = "修改",
                            ActionDefinition = "修改评论",
                            ActionType = Models.RestfulAction.Update,
                            HttpMethod = "PUT",
                            Uri = Models.ApplicationConfig.Domain + "Api/Comment/" + data.Id
                        }
                    );

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption()
                        {
                            Object = "Comment",
                            ObjectId = data.Id,
                            ActionId = "Delete_Comment",
                            ActionName = "删除",
                            ActionDefinition = "删除修改评论",
                            ActionType = Models.RestfulAction.Delete,
                            HttpMethod = "DELETE",
                            Uri = Models.ApplicationConfig.Domain + "Api/Comment/" + data.Id
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