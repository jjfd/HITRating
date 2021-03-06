﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class News
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
            return DataProcess(data, userName);
        }

        private static object DataProcess(Models.Review data, string userName)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    Product = RestfulJsonProccessor.Product.MiniSingle(data.Product),
                    Type = Models.ReviewType.News,
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
                            Object = "News",
                            ObjectId = data.Id,
                            ActionId = "Edit_News",
                            ActionName = "修改",
                            ActionDefinition = "修改资讯",
                            ActionType = Models.RestfulAction.Update,
                            HttpMethod = "PUT",
                            Uri = Models.ApplicationConfig.Domain + "Api/News/" + data.Id
                        }
                    );

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption()
                        {
                            Object = "News",
                            ObjectId = data.Id,
                            ActionId = "Delete_News",
                            ActionName = "删除",
                            ActionDefinition = "删除资讯",
                            ActionType = Models.RestfulAction.Delete,
                            HttpMethod = "DELETE",
                            Uri = Models.ApplicationConfig.Domain + "Api/News/" + data.Id
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