using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class Category
    {
        private RestfulCategory RestfulCategory;

        public Category()
        {
            RestfulCategory = new RestfulCategory();
        }

        public Models.Category Create(Models.Category entity, string userName)
        {
            try
            {
                if (!CategoryAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulCategory.Create(entity);
            }
            catch
            {
                throw;
            }
        }

        public Models.Category Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulCategory.Read(id);

                if (!CategoryAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public Models.Category Update(int id, Models.Category entity, string userName)
        {
            try
            {
                var old = RestfulCategory.Read(id);

                if (!CategoryAccessControl.Pass(RestfulAction.Update, old, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Title = old.Title;
                entity.Creator = userName;
                entity.Created = old.Created;
                entity.Updated = DateTime.Now;

                return RestfulCategory.Update(id, entity);
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
                var entity = RestfulCategory.Read(id);

                if (!CategoryAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulCategory.Delete(id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Category First(Models.CategorySearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulCategory.First(conditions);

                if (!CategoryAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public IEnumerable<Models.Category> Search(Models.CategorySearchModel conditions = null, int start = 0, int count = 0, string userName = null)
        {
            try
            {
                return RestfulCategory.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulCategory
    {
        private Entities DbEntities;

        public RestfulCategory() 
        {
            DbEntities = new Entities();
        }

        public Models.Category Create(Models.Category entity) 
        {
            try
            {
                entity = CategoryDataProccessor.ValidationAndProcess(entity);

                if (((new RestfulModels.Category()).Search(new Models.CategorySearchModel() { Title = entity.Title })).Count() > 0)
                {
                    var e = new RestfulModels.ValidationException();
                    e.ValidationErrors.Add("已经存在");

                    throw e;
                }

                DbEntities.Categories.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                return entity;
            }
            catch
            {
                throw;
            }
        }

        public Models.Category Update(int id, Models.Category entity)
        {
            try
            {
                entity = CategoryDataProccessor.ValidationAndProcess(entity);
                entity.Id = id;

                DbEntities.ApplyCurrentValues("Categories", entity);
                DbEntities.SaveChanges();

                return entity;
            }
            catch 
            {
                throw;    
            }
        }

        public Models.Category Read(int id) {
            try
            {
                return DbEntities.Categories.First(m => m.Id == id);
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
                var entity = DbEntities.Categories.First(m => m.Id == id);

                DbEntities.DeleteObject(entity);
                DbEntities.SaveChanges();

                return true;
            }
            catch
            {
                throw;
            }
        }

        public Models.Category First(Models.CategorySearchModel conditions = null) {
            try
            {
                return Search(conditions, 0, 1).First();
            }
            catch
            {
                return null;
            }
        }

        public IEnumerable<Models.Category> Search(Models.CategorySearchModel conditions = null, int start = 0, int count = -1)
        {
            try
            {
                IEnumerable<Models.Category> fs =
                (
                    from Category in
                        DbEntities.Categories.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : Category.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : Category.Id > conditions.IdUpper)
                        && (string.IsNullOrEmpty(conditions.Title) ? true : Category.Title.Contains(conditions.Title))
                        && (string.IsNullOrEmpty(conditions.Abbreviation) ? true : Category.Abbreviation.Contains(conditions.Abbreviation))
                        && (string.IsNullOrEmpty(conditions.ChineseTitle) ? true : Category.ChineseTitle.Contains(conditions.ChineseTitle))
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : Category.Creator == conditions.Creator)
                    )
                    select Category
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

    public static class CategoryAccessControl
    {
        public static bool Pass(byte action, Models.Category Category, string accessor = null)
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

    public static class CategoryDataProccessor
    {
        public static Models.Category ValidationAndProcess(Models.Category data)
        {
            try
            {
                ValidationException validationException = new ValidationException();

                //Categoryer
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