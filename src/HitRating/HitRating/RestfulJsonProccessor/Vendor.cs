using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class Vendor
    {
        public static object List(IEnumerable<Models.Vendor> data, string userName)
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

        public static object MiniList(IEnumerable<Models.Vendor> data, string userName)
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

        public static object Single(Models.Vendor data, string userName) 
        {
            return DataProcess(data, userName);
        }

        public static object MiniSingle(Models.Vendor data)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    Title = data.Title
                };
            }
            catch
            {
                return null;
            }
        }

        private static object DataProcess(Models.Vendor data, string userName)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    Title = data.Title,
                    Logo = data.Logo,
                    HomePage = data.HomePage,
                    Phone = data.Phone,
                    Phone_400 = data.Phone_400,
                    Phone_800 = data.Phone_800,
                    Fax = data.Fax,
                    Email = data.Email,
                    Address = data.Address,
                    PostNo = data.PostNo,
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

        public static IList<RestfulJsonProccessor.RestfulOption> ControlProcess(Models.Vendor data, string userName)
        {
            try
            {
                if ((new Models.AccountMembershipService()).IsAdmin(userName))
                {
                    var options = new List<RestfulJsonProccessor.RestfulOption>();

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption() 
                        { 
                            Object = "Vendor",
                            ObjectId = data.Id,
                            ActionId = "Edit_Vendor",
                            ActionName = "修改",
                            ActionDefinition = "修改供应商信息",
                            ActionType = Models.RestfulAction.Update,
                            HttpMethod = "PUT",
                            Uri = Models.ApplicationConfig.Domain + "Api/Vendor/" + data.Id
                        }
                    );

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption()
                        {
                            Object = "Vendor",
                            ObjectId = data.Id,
                            ActionId = "Delete_Vendor",
                            ActionName = "删除",
                            ActionDefinition = "删除供应商信息",
                            ActionType = Models.RestfulAction.Delete,
                            HttpMethod = "DELETE",
                            Uri = Models.ApplicationConfig.Domain + "Api/Vendor/" + data.Id
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