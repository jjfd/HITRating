using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class Category
    {
        public static object List(IEnumerable<Models.Category> data, string userName)
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

        public static object MiniList(IEnumerable<Models.Category> data, string userName)
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

        public static object Single(Models.Category data, string userName) 
        {
            return DataProcess(data, userName);
        }

        public static object MiniSingle(Models.Category data)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    Title = data.Abbreviation
                };
            }
            catch
            {
                return null;
            }
        }

        private static object DataProcess(Models.Category data, string userName)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    Title = data.Title,
                    Abbreviation = data.Abbreviation,
                    ChineseTitle = data.ChineseTitle,
                    Description = data.Description,
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

        public static IList<RestfulJsonProccessor.RestfulOption> ControlProcess(Models.Category data, string userName)
        {
            try
            {
                if ((new Models.AccountMembershipService()).IsAdmin(userName))
                {
                    var options = new List<RestfulJsonProccessor.RestfulOption>();

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption() 
                        { 
                            Object = "Category",
                            ObjectId = data.Id,
                            ActionId = "Edit_Category",
                            ActionName = "修改",
                            ActionDefinition = "修改产品类别信息",
                            ActionType = Models.RestfulAction.Update,
                            HttpMethod = "PUT",
                            Uri = Models.ApplicationConfig.Domain + "Api/Category/" + data.Id
                        }
                    );

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption()
                        {
                            Object = "Category",
                            ObjectId = data.Id,
                            ActionId = "Delete_Category",
                            ActionName = "删除",
                            ActionDefinition = "删除产品类别信息",
                            ActionType = Models.RestfulAction.Delete,
                            HttpMethod = "DELETE",
                            Uri = Models.ApplicationConfig.Domain + "Api/Category/" + data.Id
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