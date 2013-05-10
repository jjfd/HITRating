using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HitRating.RestfulJsonProccessor
{
    public static class Product
    {
        public static object List(IEnumerable<Models.Product> data, string userName)
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

        public static object MiniList(IEnumerable<Models.Product> data, string userName)
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

        public static object Single(Models.Product data, string userName) 
        {
            return DataProcess(data, userName);
        }

        public static object MiniSingle(Models.Product data)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    Title = data.Title + " " + data.Version + "(" + data.Vendor.Title + ")",
                    Category = new 
                    {
                        Id = data.Category.Id,
                        Title = data.Category.Abbreviation
                    }
                };
            }
            catch
            {
                return null;
            }
        }

        private static object DataProcess(Models.Product data, string userName)
        {
            try
            {
                return new
                {
                    Id = data.Id,
                    Vendor = RestfulJsonProccessor.Vendor.MiniSingle(data.Vendor),
                    Title = data.Title,
                    Logo = data.Logo,
                    Category = RestfulJsonProccessor.Category.MiniSingle(data.Category),
                    Version = data.Version,
                    Published = data.Published != null ? ((DateTime)data.Published).ToShortDateString() : null,
                    PreVersion = data.PreVersion,
                    PhonePreSale = data.PhonePreSale,
                    PhoneAfterSale = data.PhoneAfterSale,
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

        public static IList<RestfulJsonProccessor.RestfulOption> ControlProcess(Models.Product data, string userName)
        {
            try
            {
                if ((new Models.AccountMembershipService()).IsAdmin(userName))
                {
                    var options = new List<RestfulJsonProccessor.RestfulOption>();

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption() 
                        { 
                            Object = "Product",
                            ObjectId = data.Id,
                            ActionId = "Edit_Product",
                            ActionName = "修改",
                            ActionDefinition = "修改HIT产品信息",
                            ActionType = Models.RestfulAction.Update,
                            HttpMethod = "PUT",
                            Uri = Models.ApplicationConfig.Domain + "Api/Product/" + data.Id
                        }
                    );

                    options.Add(
                        new RestfulJsonProccessor.RestfulOption()
                        {
                            Object = "Product",
                            ObjectId = data.Id,
                            ActionId = "Delete_Product",
                            ActionName = "删除",
                            ActionDefinition = "删除HIT产品信息",
                            ActionType = Models.RestfulAction.Delete,
                            HttpMethod = "DELETE",
                            Uri = Models.ApplicationConfig.Domain + "Api/Product/" + data.Id
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