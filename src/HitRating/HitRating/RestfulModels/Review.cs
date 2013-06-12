using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class Review
    {
        private RestfulReview RestfulReview;

        public Review()
        {
            RestfulReview = new RestfulReview();
        }

        public Models.Review Create(Models.Review entity, string userName)
        {
            try
            {
                if (!ReviewAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulReview.Create(entity);
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
                var entity = RestfulReview.Read(id);

                if (!ReviewAccessControl.Pass(RestfulAction.Read, entity, userName))
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
                var old = RestfulReview.Read(id);

                if (!ReviewAccessControl.Pass(RestfulAction.Update, old, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.ProductId = old.ProductId;
                entity.Creator = userName;
                entity.Created = old.Created;
                entity.Updated = DateTime.Now;

                return RestfulReview.Update(id, entity);
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
                var entity = RestfulReview.Read(id);

                if (!ReviewAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulReview.Delete(id);
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
                var entity = RestfulReview.First(conditions);

                if (!ReviewAccessControl.Pass(RestfulAction.Read, entity, userName))
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
                return RestfulReview.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulReview
    {
        private Entities DbEntities;

        public RestfulReview() 
        {
            DbEntities = new Entities();
        }

        public Models.Review Create(Models.Review entity) 
        {
            try
            {
                entity = ReviewDataProccessor.ValidationAndProcess(entity);

                DbEntities.Reviews.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                try
                {
                    if (!string.IsNullOrEmpty(entity.RatedAspects))
                    {
                        string[] aspects = Utilities.StringUtility.DeGroup(entity.RatedAspects, ';');
                        for (int i = 0; i < aspects.Count(); i++)
                        {
                            string[] aspectData = Utilities.StringUtility.DeGroup(aspects[i], '|');

                            Models.Aspect theAspect = (new RestfulModels.Aspect()).Read(int.Parse(aspectData[0]), entity.Creator);
                            theAspect.RatedTimes++;
                            (new RestfulModels.Aspect()).Update(theAspect.Id, theAspect, theAspect.Creator);

                            (new RestfulModels.Rate()).Create(new Models.Rate()
                                {
                                    ReviewId = entity.Id,
                                    AspectId = theAspect.Id,
                                    AspectTitle = theAspect.Title,
                                    Stars = int.Parse(aspectData[2]),
                                    Creator = entity.Creator,
                                    Created = entity.Created
                                },
                                entity.Creator
                            );
                        }
                    }
                }
                catch
                {
                    ;
                }

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
                entity = ReviewDataProccessor.ValidationAndProcess(entity);
                entity.Id = id;

                string oldRatedAspects = entity.RatedAspects;

                DbEntities.ApplyCurrentValues("Reviews", entity);
                DbEntities.SaveChanges();

                try
                {
                    if (!string.IsNullOrEmpty(entity.RatedAspects))
                    {
                        string[] aspects = Utilities.StringUtility.DeGroup(entity.RatedAspects, ';');
                        for (int i = 0; i < aspects.Count(); i++)
                        {
                            string[] aspectData = Utilities.StringUtility.DeGroup(aspects[i], '|');

                            if ((";" + oldRatedAspects).IndexOf(";" + aspectData[0] + "|") < 0)
                            {
                                Models.Aspect theAspect = (new RestfulModels.Aspect()).Read(int.Parse(aspectData[0]), entity.Creator);
                                theAspect.RatedTimes++;
                                (new RestfulModels.Aspect()).Update(theAspect.Id, theAspect, theAspect.Creator);

                                (new RestfulModels.Rate()).Create(new Models.Rate()
                                {
                                    ReviewId = entity.Id,
                                    AspectId = theAspect.Id,
                                    AspectTitle = theAspect.Title,
                                    Stars = int.Parse(aspectData[2]),
                                    Creator = entity.Creator,
                                    Created = entity.Created
                                },
                                    entity.Creator
                                );
                            }
                            else {
                                Models.Rate theRate = (new RestfulModels.Rate()).First(new Models.RateSearchModel() { ReviewId = entity.Id, AspectId = int.Parse(aspectData[0]) }, entity.Creator);

                                (new RestfulModels.Rate()).Update(
                                    theRate.Id, 
                                    new Models.Rate()
                                    {
                                        Stars = int.Parse(aspectData[2]),
                                    },
                                    theRate.Creator
                                );
                            }
                        }
                    }
                }
                catch
                {
                    ;
                }

                return Read(entity.Id);
            }
            catch 
            {
                throw;    
            }
        }

        public Models.Review Read(int id) {
            try
            {
                var t =  DbEntities.Reviews.First(m => m.Id == id);
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

        public Models.Review First(Models.ReviewSearchModel conditions = null) {
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
                    from review in
                        DbEntities.Reviews.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : review.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : review.Id > conditions.IdUpper)
                        && ((conditions.ProductId == null || conditions.ProductId < 1) ? true : review.ProductId == conditions.ProductId)
                        && (
                            (conditions.Rate == null || conditions.Rate < 1 || conditions.Rate > 5) 
                            ? 
                            (
                                ((conditions.RateGT == null || conditions.RateGT < 1 || conditions.RateGT > 5) ? true : review.Rate >= conditions.RateGT)
                                &&
                                ((conditions.RateLT == null || conditions.RateLT < 1 || conditions.RateLT > 5) ? true : review.Rate >= conditions.RateLT)
                            )
                            : 
                            review.Rate == conditions.Rate
                           )
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : review.Creator == conditions.Creator)
                        && (review.Type == Models.ReviewType.Review)
                    )
                    select review
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

    public static class ReviewAccessControl
    {
        public static bool Pass(byte action, Models.Review Review, string accessor = null)
        {
            try
            {
                if (action == RestfulAction.Create)
                {
                    if (!string.IsNullOrEmpty(accessor) && (new AccountMembershipService()).Exist(accessor))
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
                    if (!string.IsNullOrEmpty(accessor) && Review.Creator == accessor)
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
                    if (!string.IsNullOrEmpty(accessor) && Review.Creator == accessor)
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

    public static class ReviewDataProccessor
    {
        public static Models.Review ValidationAndProcess(Models.Review data)
        {
            try
            {
                ValidationException validationException = new ValidationException();

                data.Type = Models.ReviewType.Review;

                try
                {
                    if (data.ProductId == null || (data.ProductId < 1) || (new RestfulModels.Product()).Read((int)data.ProductId) == null)
                    {
                        validationException.ValidationErrors.Add("HIT产品为空");
                    }
                }
                catch
                {
                    validationException.ValidationErrors.Add("HIT产品为空");
                }

                if (data.Rate == null || data.Rate < 1 || data.Rate > 5) {
                    validationException.ValidationErrors.Add("无效的评分");
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