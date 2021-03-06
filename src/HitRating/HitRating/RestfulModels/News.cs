﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class News
    {
        private RestfulNews RestfulNews;

        public News()
        {
            RestfulNews = new RestfulNews();
        }

        public Models.Review Create(Models.Review entity, string userName)
        {
            try
            {
                if (!NewsAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulNews.Create(entity);
            }
            catch
            {
                throw;
            }
        }

        public Models.Review Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulNews.Read(id);

                if (!NewsAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public Models.Review Update(int id, Models.Review entity, string userName)
        {
            try
            {
                var old = RestfulNews.Read(id);

                if (!NewsAccessControl.Pass(RestfulAction.Update, old, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.ProductId = old.ProductId;
                entity.Creator = userName;
                entity.Created = old.Created;
                entity.Updated = DateTime.Now;

                return RestfulNews.Update(id, entity);
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
                var entity = RestfulNews.Read(id);

                if (!NewsAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulNews.Delete(id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Review First(Models.ReviewSearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulNews.First(conditions);

                if (!NewsAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public IEnumerable<Models.Review> Search(Models.ReviewSearchModel conditions = null, int start = 0, int count = 0, string userName = null)
        {
            try
            {
                return RestfulNews.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulNews
    {
        private Entities DbEntities;

        public RestfulNews() 
        {
            DbEntities = new Entities();
        }

        public Models.Review Create(Models.Review entity) 
        {
            try
            {
                entity = NewsDataProccessor.ValidationAndProcess(entity);

                DbEntities.Reviews.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                return Read(entity.Id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Review Update(int id, Models.Review entity)
        {
            try
            {
                entity = NewsDataProccessor.ValidationAndProcess(entity);
                entity.Id = id;

                string oldRatedAspects = entity.RatedAspects;

                DbEntities.ApplyCurrentValues("Reviews", entity);
                DbEntities.SaveChanges();

                return Read(entity.Id);
            }
            catch 
            {
                throw;    
            }
        }

        public Models.Review Read(int id)
        {
            try
            {
                var t = DbEntities.Reviews.First(m => m.Id == id);
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
                var entity = DbEntities.Reviews.First(m => m.Id == id);

                DbEntities.DeleteObject(entity);
                DbEntities.SaveChanges();

                return true;
            }
            catch
            {
                throw;
            }
        }

        public Models.Review First(Models.ReviewSearchModel conditions = null)
        {
            try
            {
                return Search(conditions, 0, 1).First();
            }
            catch
            {
                return null;
            }
        }

        public IEnumerable<Models.Review> Search(Models.ReviewSearchModel conditions = null, int start = 0, int count = -1)
        {
            try
            {
                IEnumerable<Models.Review> fs =
                (
                    from news in
                        DbEntities.Reviews.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : news.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : news.Id > conditions.IdUpper)
                        && ((conditions.ProductId == null || conditions.ProductId < 1) ? true : news.ProductId == conditions.ProductId)
                        && (
                            (conditions.Rate == null || conditions.Rate < 1 || conditions.Rate > 5) 
                            ? 
                            (
                                ((conditions.RateGT == null || conditions.RateGT < 1 || conditions.RateGT > 5) ? true : news.Rate >= conditions.RateGT)
                                &&
                                ((conditions.RateLT == null || conditions.RateLT < 1 || conditions.RateLT > 5) ? true : news.Rate >= conditions.RateLT)
                            )
                            : 
                            news.Rate == conditions.Rate
                           )
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : news.Creator == conditions.Creator)
                        && (news.Type == Models.ReviewType.News)
                    )
                    select news
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

        private void GetFullEntity(ref Models.Review entity)
        {
            try
            {
                var productId = (int)(entity.ProductId);
                entity.Product = (new RestfulModels.RestfulProduct()).Read(productId);
            }
            catch
            {
                ;
            }
        }
    }

    public static class NewsAccessControl
    {
        public static bool Pass(byte action, Models.Review News, string accessor = null)
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
                    if (!string.IsNullOrEmpty(accessor) && News.Creator == accessor)
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
                    if (!string.IsNullOrEmpty(accessor) && News.Creator == accessor)
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

    public static class NewsDataProccessor
    {
        public static Models.Review ValidationAndProcess(Models.Review data)
        {
            try
            {
                ValidationException validationException = new ValidationException();

                data.Type = Models.ReviewType.News;
                data.Rate = null;
                data.RatedAspects = null;

                if (data.ProductId != null && (data.ProductId > 0) && (new RestfulModels.Product()).Read((int)data.ProductId) == null)
                {
                    validationException.ValidationErrors.Add("HIT产品为空");
                }

                if (string.IsNullOrEmpty(data.Details))
                {
                    validationException.ValidationErrors.Add("评价内容为空");
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