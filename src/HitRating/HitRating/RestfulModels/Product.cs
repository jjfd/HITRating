using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class Product
    {
        private RestfulProduct RestfulProduct;

        public Product()
        {
            RestfulProduct = new RestfulProduct();
        }

        public Models.Product Create(Models.Product entity, string userName)
        {
            try
            {
                if (!ProductAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulProduct.Create(entity);
            }
            catch
            {
                throw;
            }
        }

        public Models.Product Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulProduct.Read(id);

                if (!ProductAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public Models.Product Update(int id, Models.Product entity, string userName)
        {
            try
            {
                var old = RestfulProduct.Read(id);

                if (!ProductAccessControl.Pass(RestfulAction.Update, old, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.VendorId = old.VendorId;
                entity.Title = old.Title;
                entity.Version = old.Version;
                entity.Creator = userName;
                entity.Created = old.Created;
                entity.Updated = DateTime.Now;

                return RestfulProduct.Update(id, entity);
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
                var entity = RestfulProduct.Read(id);

                if (!ProductAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulProduct.Delete(id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Product First(Models.ProductSearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulProduct.First(conditions);

                if (!ProductAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public IEnumerable<Models.Product> Search(Models.ProductSearchModel conditions = null, int start = 0, int count = 0, string userName = null)
        {
            try
            {
                return RestfulProduct.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulProduct
    {
        private Entities DbEntities;

        public RestfulProduct() 
        {
            DbEntities = new Entities();
        }

        public Models.Product Create(Models.Product entity) 
        {
            try
            {
                entity = ProductDataProccessor.ValidationAndProcess(entity);

                if (((new RestfulModels.Product()).Search(new Models.ProductSearchModel() { VendorId = entity.VendorId, Title = entity.Title, Version = entity.Version })).Count() > 0)
                {
                    var e = new RestfulModels.ValidationException();
                    e.ValidationErrors.Add("已经存在");

                    throw e;
                }

                DbEntities.Products.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                return Read(entity.Id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Product Update(int id, Models.Product entity)
        {
            try
            {
                entity = ProductDataProccessor.ValidationAndProcess(entity);
                entity.Id = id;

                DbEntities.ApplyCurrentValues("Products", entity);
                DbEntities.SaveChanges();

                return Read(entity.Id);
            }
            catch 
            {
                throw;    
            }
        }

        public Models.Product Read(int id) {
            try
            {
                var t =  DbEntities.Products.First(m => m.Id == id);
                GetFullEntity(ref t);

                return t;
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
                var entity = DbEntities.Products.First(m => m.Id == id);

                DbEntities.DeleteObject(entity);
                DbEntities.SaveChanges();

                return true;
            }
            catch
            {
                throw;
            }
        }

        public Models.Product First(Models.ProductSearchModel conditions = null) {
            try
            {
                return Search(conditions, 0, 1).First();
            }
            catch
            {
                return null;
            }
        }

        public IEnumerable<Models.Product> Search(Models.ProductSearchModel conditions = null, int start = 0, int count = -1)
        {
            try
            {
                IEnumerable<Models.Product> fs =
                (
                    from product in
                        DbEntities.Products.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : product.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : product.Id > conditions.IdUpper)
                        && ((conditions.VendorId == null || conditions.VendorId < 1) ? true : product.VendorId == conditions.VendorId)
                        && (string.IsNullOrEmpty(conditions.Title) ? true : product.Title.Contains(conditions.Title))
                        && ((conditions.CategoryId == null || conditions.CategoryId < 1) ? true : product.CategoryId == conditions.CategoryId)
                        && (string.IsNullOrEmpty(conditions.Version) ? true : product.Version == conditions.Version)
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : product.Creator == conditions.Creator)
                    )
                    select product
                ).AsEnumerable();

                if (start > 0)
                {
                    fs = fs.Skip(start);
                }

                if (count > 0)
                {
                    fs = fs.Take(count);
                }

                for (int i = 0; i < fs.Count(); i++)
                {
                    var tempT = fs.ElementAt(i);

                    try
                    {
                        GetFullEntity(ref tempT);
                    }
                    catch
                    {
                        ;
                    }
                }

                return fs;
            }
            catch
            {
                return null;
            }
        }

        private void GetFullEntity(ref Models.Product entity)
        {
            try
            {
                var vendorId = (int)(entity.VendorId);
                entity.Vendor = DbEntities.Vendors.First(m => m.Id == vendorId);
            }
            catch
            {
                ;
            }

            try
            {
                var catId = (int)(entity.CategoryId);
                entity.Category = DbEntities.Categories.First(m => m.Id == catId);
            }
            catch
            {
                ;
            }
        }
    }

    public static class ProductAccessControl
    {
        public static bool Pass(byte action, Models.Product Product, string accessor = null)
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

    public static class ProductDataProccessor
    {
        public static Models.Product ValidationAndProcess(Models.Product data)
        {
            try
            {
                ValidationException validationException = new ValidationException();

                try
                {
                    if (data.VendorId == null || (data.VendorId < 1) || (new RestfulModels.Vendor()).Read((int)data.VendorId) == null)
                    {
                        validationException.ValidationErrors.Add("供应商为空");
                    }
                }
                catch
                {
                    validationException.ValidationErrors.Add("供应商为空");
                }

                if (string.IsNullOrEmpty(data.Title))
                {
                    validationException.ValidationErrors.Add("名称为空");
                }

                try
                {
                    if (data.CategoryId != null && (data.VendorId > 0) && (new RestfulModels.Category()).Read((int)data.CategoryId) == null)
                    {
                        validationException.ValidationErrors.Add("产品类别不存在");
                    }
                }
                catch
                {
                    validationException.ValidationErrors.Add("产品类别不存在");
                }

                if (string.IsNullOrEmpty(data.Version))
                {
                    validationException.ValidationErrors.Add("版本为空");
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