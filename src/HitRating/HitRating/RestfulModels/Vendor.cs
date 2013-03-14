using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class Vendor
    {
        private RestfulVendor RestfulVendor;

        public Vendor()
        {
            RestfulVendor = new RestfulVendor();
        }

        public Models.Vendor Create(Models.Vendor entity, string userName)
        {
            try
            {
                if (!VendorAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulVendor.Create(entity);
            }
            catch
            {
                throw;
            }
        }

        public Models.Vendor Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulVendor.Read(id);

                if (!VendorAccessControl.Pass(RestfulAction.Read, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return entity;
            }
            catch
            {
                throw;
            }
        }

        public Models.Vendor Update(int id, Models.Vendor entity, string userName)
        {
            try
            {
                var old = RestfulVendor.Read(id);

                if (!VendorAccessControl.Pass(RestfulAction.Update, old, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Title = old.Title;
                entity.Created = old.Created;
                entity.Updated = DateTime.Now;

                return RestfulVendor.Update(id, entity);
            }
            catch
            {
                throw;
            }
        }

        public bool Delete(int id, string userName)
        {
            try
            {
                var entity = RestfulVendor.Read(id);

                if (!VendorAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulVendor.Delete(id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Vendor First(Models.VendorSearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulVendor.First(conditions);

                if (!VendorAccessControl.Pass(RestfulAction.Read, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return entity;
            }
            catch
            {
                throw;
            }
        }

        public IEnumerable<Models.Vendor> Search(Models.VendorSearchModel conditions = null, int start = 0, int count = 0, string userName = null)
        {
            try
            {
                return RestfulVendor.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulVendor
    {
        private Entities DbEntities;

        public RestfulVendor() 
        {
            DbEntities = new Entities();
        }

        public Models.Vendor Create(Models.Vendor entity) 
        {
            try
            {
                entity = VendorDataProccessor.ValidationAndProcess(entity);

                if (((new RestfulModels.Vendor()).Search(new Models.VendorSearchModel() { Title = entity.Title })).Count() > 0)
                {
                    var e = new RestfulModels.ValidationException();
                    e.ValidationErrors.Add("已经存在");

                    throw e;
                }

                DbEntities.Vendors.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                return entity;
            }
            catch
            {
                throw;
            }
        }

        public Models.Vendor Update(int id, Models.Vendor entity)
        {
            try
            {
                entity = VendorDataProccessor.ValidationAndProcess(entity);
                entity.Id = id;

                DbEntities.ApplyCurrentValues("Vendors", entity);
                DbEntities.SaveChanges();

                return entity;
            }
            catch 
            {
                throw;    
            }
        }

        public Models.Vendor Read(int id) {
            try
            {
                return DbEntities.Vendors.First(m => m.Id == id);
            }
            catch
            {
                throw;
            }
        }
        
        public bool Delete(int id)
        {
            try
            {
                var entity = DbEntities.Vendors.First(m => m.Id == id);

                DbEntities.DeleteObject(entity);
                DbEntities.SaveChanges();

                return true;
            }
            catch
            {
                throw;
            }
        }

        public Models.Vendor First(Models.VendorSearchModel conditions = null) {
            try
            {
                return Search(conditions, 0, 1).First();
            }
            catch
            {
                return null;
            }
        }

        public IEnumerable<Models.Vendor> Search(Models.VendorSearchModel conditions = null, int start = 0, int count = -1)
        {
            try
            {
                IEnumerable<Models.Vendor> fs =
                (
                    from vendor in
                        DbEntities.Vendors.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : vendor.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : vendor.Id > conditions.IdUpper)
                        && (string.IsNullOrEmpty(conditions.Title) ? true : vendor.Title.Contains(conditions.Title))
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : vendor.Creator == conditions.Creator)
                    )
                    select vendor
                ).AsEnumerable();

                if (start > 0)
                {
                    fs = fs.Skip(start);
                }

                if (count > 0)
                {
                    fs = fs.Take(count);
                }

                return fs;
            }
            catch
            {
                return null;
            }
        }
    }

    public static class VendorAccessControl
    {
        public static bool Pass(byte action, Models.Vendor Vendor, string accessor = null)
        {
            try
            {
                if (action == RestfulAction.Create)
                {
                    if (!string.IsNullOrEmpty(accessor) && (new Models.AccountMembershipService()).IsAdmin(accessor))
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else if (action == RestfulAction.Read)
                {
                    return true;
                }
                else if (action == RestfulAction.Update)
                {
                    if (!string.IsNullOrEmpty(accessor) && (new Models.AccountMembershipService()).IsAdmin(accessor))
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else if (action == RestfulAction.Delete)
                {
                    if (!string.IsNullOrEmpty(accessor) && (new Models.AccountMembershipService()).IsAdmin(accessor))
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                else
                {
                    return false;
                }
            }
            catch
            {
                return false;
            }
        }
    }

    public static class VendorDataProccessor
    {
        public static Models.Vendor ValidationAndProcess(Models.Vendor data)
        {
            try
            {
                ValidationException validationException = new ValidationException();

                //Vendorer
                if (string.IsNullOrEmpty(data.Title))
                {
                    validationException.ValidationErrors.Add("供应商名称为空");
                }

                //created
                if (data.Created == null)
                {
                    data.Created = DateTime.Now;
                }

                if (validationException.ValidationErrors.Count() > 0)
                {
                    throw validationException;
                }
                else
                {
                    return data;
                }
            }
            catch
            {
                throw;
            }
        }
    }
}