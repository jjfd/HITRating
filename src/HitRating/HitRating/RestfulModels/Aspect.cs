using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class Aspect
    {
        private RestfulAspect RestfulAspect;

        public Aspect()
        {
            RestfulAspect = new RestfulAspect();
        }

        public Models.Aspect Create(Models.Aspect entity, string userName)
        {
            try
            {
                if (!AspectAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulAspect.Create(entity);
            }
            catch
            {
                throw;
            }
        }

        public Models.Aspect Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulAspect.Read(id);

                if (!AspectAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public bool Delete(int id, string userName)
        {
            try
            {
                var entity = RestfulAspect.Read(id);

                if (!AspectAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulAspect.Delete(id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Aspect First(Models.AspectSearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulAspect.First(conditions);

                if (!AspectAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public IEnumerable<Models.Aspect> Search(Models.AspectSearchModel conditions = null, int start = 0, int count = 0, string userName = null)
        {
            try
            {
                return RestfulAspect.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulAspect
    {
        private Entities DbEntities;

        public RestfulAspect() 
        {
            DbEntities = new Entities();
        }

        public Models.Aspect Create(Models.Aspect entity) 
        {
            try
            {
                entity = AspectDataProccessor.ValidationAndProcess(entity);

                if (((new RestfulModels.Aspect()).Search(new Models.AspectSearchModel() { CategoryId = entity.CategoryId, Title = entity.Title })).Count() > 0)
                {
                    var e = new RestfulModels.ValidationException();
                    e.ValidationErrors.Add("已经存在");

                    throw e;
                }

                DbEntities.Aspects.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                return entity;
            }
            catch
            {
                throw;
            }
        }

        public Models.Aspect Read(int id) {
            try
            {
                return DbEntities.Aspects.First(m => m.Id == id);
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
                var entity = DbEntities.Aspects.First(m => m.Id == id);

                DbEntities.DeleteObject(entity);
                DbEntities.SaveChanges();

                return true;
            }
            catch
            {
                throw;
            }
        }

        public Models.Aspect First(Models.AspectSearchModel conditions = null) {
            try
            {
                return Search(conditions, 0, 1).First();
            }
            catch
            {
                return null;
            }
        }

        public IEnumerable<Models.Aspect> Search(Models.AspectSearchModel conditions = null, int start = 0, int count = -1)
        {
            try
            {
                IEnumerable<Models.Aspect> fs =
                (
                    from aspect in
                        DbEntities.Aspects.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : aspect.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : aspect.Id > conditions.IdUpper)
                        && ((conditions.CategoryId == null || conditions.CategoryId < 1) ? true : aspect.CategoryId == conditions.CategoryId)
                        && (!string.IsNullOrEmpty(conditions.Title) ? true : aspect.Title.Contains(conditions.Title))
                        && ((conditions.RatedTimesLt == null || conditions.RatedTimesLt < 1) ? true : aspect.RatedTimes <= conditions.RatedTimesLt)
                        && ((conditions.RatedTimesGt == null || conditions.RatedTimesGt < 1) ? true : aspect.Id >= conditions.RatedTimesGt)
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : aspect.Creator == conditions.Creator)
                    )
                    select aspect
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

    public static class AspectAccessControl
    {
        public static bool Pass(byte action, Models.Aspect Aspect, string accessor = null)
        {
            try
            {
                if (action == RestfulAction.Create)
                {
                    if (!string.IsNullOrEmpty(accessor) && (new Models.AccountMembershipService()).Exist(accessor))
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
                    return true;
                }
                else if (action == RestfulAction.Delete)
                {
                    return false;
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

    public static class AspectDataProccessor
    {
        public static Models.Aspect ValidationAndProcess(Models.Aspect data)
        {
            try
            {
                ValidationException validationException = new ValidationException();

                try
                {
                    if (data.CategoryId == null || (data.CategoryId < 1) || (new RestfulModels.Category()).Read((int)data.CategoryId) == null)
                    {
                        validationException.ValidationErrors.Add("产品类别为空");
                    }
                }
                catch
                {
                    validationException.ValidationErrors.Add("产品类别为空");
                }

                if (string.IsNullOrEmpty(data.Title)) {
                    validationException.ValidationErrors.Add("评价内容为空");
                }

                if (data.RatedTimes == null || data.RatedTimes < 1) {
                    data.RatedTimes = 1;
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