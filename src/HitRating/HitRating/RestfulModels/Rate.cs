using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class Rate
    {
        private RestfulRate RestfulRate;

        public Rate()
        {
            RestfulRate = new RestfulRate();
        }

        public Models.Rate Create(Models.Rate entity, string userName)
        {
            try
            {
                if (!RateAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulRate.Create(entity);
            }
            catch
            {
                throw;
            }
        }

        public Models.Rate Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulRate.Read(id);

                if (!RateAccessControl.Pass(RestfulAction.Read, entity, userName))
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
                var entity = RestfulRate.Read(id);

                if (!RateAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulRate.Delete(id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Rate First(Models.RateSearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulRate.First(conditions);

                if (!RateAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public IEnumerable<Models.Rate> Search(Models.RateSearchModel conditions = null, int start = 0, int count = 0, string userName = null)
        {
            try
            {
                return RestfulRate.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulRate
    {
        private Entities DbEntities;

        public RestfulRate() 
        {
            DbEntities = new Entities();
        }

        public Models.Rate Create(Models.Rate entity) 
        {
            try
            {
                entity = RateDataProccessor.ValidationAndProcess(entity);

                if (((new RestfulModels.Rate()).Search(new Models.RateSearchModel() { AspectId = entity.AspectId, Creator = entity.Creator })).Count() > 0)
                {
                    var e = new RestfulModels.ValidationException();
                    e.ValidationErrors.Add("已经存在");

                    throw e;
                }

                DbEntities.Rates.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                return entity;
            }
            catch
            {
                throw;
            }
        }

        public Models.Rate Read(int id) {
            try
            {
                return DbEntities.Rates.First(m => m.Id == id);
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
                var entity = DbEntities.Rates.First(m => m.Id == id);

                DbEntities.DeleteObject(entity);
                DbEntities.SaveChanges();

                return true;
            }
            catch
            {
                throw;
            }
        }

        public Models.Rate First(Models.RateSearchModel conditions = null) {
            try
            {
                return Search(conditions, 0, 1).First();
            }
            catch
            {
                return null;
            }
        }

        public IEnumerable<Models.Rate> Search(Models.RateSearchModel conditions = null, int start = 0, int count = -1)
        {
            try
            {
                IEnumerable<Models.Rate> fs =
                (
                    from rate in
                        DbEntities.Rates.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : rate.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : rate.Id > conditions.IdUpper)
                        && ((conditions.ReviewId == null || conditions.ReviewId < 1) ? true : rate.ReviewId == conditions.ReviewId)
                        && ((conditions.AspectId == null || conditions.AspectId < 1) ? true : rate.AspectId == conditions.AspectId)
                        && ((conditions.StarsGt == null || conditions.StarsGt < 1) ? true : rate.Stars >= conditions.StarsGt)
                        && ((conditions.StarsLt == null || conditions.StarsLt < 1) ? true : rate.Stars >= conditions.StarsLt)
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : rate.Creator == conditions.Creator)
                    )
                    select rate
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

    public static class RateAccessControl
    {
        public static bool Pass(byte action, Models.Rate Rate, string accessor = null)
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
                    return false;
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

    public static class RateDataProccessor
    {
        public static Models.Rate ValidationAndProcess(Models.Rate data)
        {
            try
            {
                ValidationException validationException = new ValidationException();

                try
                {
                    if (data.ReviewId != null && (data.ReviewId > 0) && (new RestfulModels.Review()).Read((int)data.ReviewId) == null)
                    {
                        validationException.ValidationErrors.Add("产品评价不存在");
                    }
                }
                catch
                {
                    validationException.ValidationErrors.Add("产品评价不存在");
                }

                try
                {
                    if (data.AspectId == null || (data.AspectId < 1))
                    {
                        validationException.ValidationErrors.Add("评价问题为空");
                    }
                    else
                    {
                        var aspect = (new RestfulModels.Aspect()).Read((int)data.AspectId);
                        data.AspectTitle = aspect.Title;
                    }
                }
                catch
                {
                    validationException.ValidationErrors.Add("评价问题不存在");
                }

                if (data.Stars < 1 || data.Stars > 5) {
                    validationException.ValidationErrors.Add("评分无效");
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