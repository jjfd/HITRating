using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class ProductInfo
    {
        private RestfulProductInfo RestfulProductInfo;

        public ProductInfo()
        {
            RestfulProductInfo = new RestfulProductInfo();
        }

        public Models.Review Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulProductInfo.Read(id);

                if (!ProductInfoAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public Models.Review First(Models.ReviewSearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulProductInfo.First(conditions);

                if (!ProductInfoAccessControl.Pass(RestfulAction.Read, entity, userName))
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
                return RestfulProductInfo.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulProductInfo
    {
        private Entities DbEntities;

        public RestfulProductInfo() 
        {
            DbEntities = new Entities();
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
                    from info in
                        DbEntities.Reviews.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : info.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : info.Id > conditions.IdUpper)
                        && ((conditions.ProductId == null || conditions.ProductId < 1) ? true : info.ProductId == conditions.ProductId)
                        && (
                            (conditions.Rate == null || conditions.Rate < 1 || conditions.Rate > 5) 
                            ? 
                            (
                                ((conditions.RateGT == null || conditions.RateGT < 1 || conditions.RateGT > 5) ? true : info.Rate >= conditions.RateGT)
                                &&
                                ((conditions.RateLT == null || conditions.RateLT < 1 || conditions.RateLT > 5) ? true : info.Rate >= conditions.RateLT)
                            )
                            : 
                            info.Rate == conditions.Rate
                           )
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : info.Creator == conditions.Creator)
                        && ((conditions.Type == null || conditions.Type < 1) ? true : info.Type == conditions.Type)
                    )
                    select info
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

    public static class ProductInfoAccessControl
    {
        public static bool Pass(byte action, Models.Review ProductInfo, string accessor = null)
        {
            return true;
        }
    }
}