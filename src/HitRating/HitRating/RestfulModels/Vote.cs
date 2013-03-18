using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class Vote
    {
        private RestfulVote RestfulVote;

        public Vote()
        {
            RestfulVote = new RestfulVote();
        }

        public Models.Vote Create(Models.Vote entity, string userName)
        {
            try
            {
                if (!VoteAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulVote.Create(entity);
            }
            catch
            {
                throw;
            }
        }

        public Models.Vote Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulVote.Read(id);

                if (!VoteAccessControl.Pass(RestfulAction.Read, entity, userName))
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
                var entity = RestfulVote.Read(id);

                if (!VoteAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulVote.Delete(id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Vote First(Models.VoteSearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulVote.First(conditions);

                if (!VoteAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public IEnumerable<Models.Vote> Search(Models.VoteSearchModel conditions = null, int start = 0, int count = 0, string userName = null)
        {
            try
            {
                return RestfulVote.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulVote
    {
        private Entities DbEntities;

        public RestfulVote() 
        {
            DbEntities = new Entities();
        }

        public Models.Vote Create(Models.Vote entity) 
        {
            try
            {
                entity = VoteDataProccessor.ValidationAndProcess(entity);

                if (((new RestfulModels.Vote()).Search(new Models.VoteSearchModel() { ReviewId = entity.ReviewId, Creator = entity.Creator })).Count() > 0)
                {
                    var e = new RestfulModels.ValidationException();
                    e.ValidationErrors.Add("已经存在");

                    throw e;
                }

                DbEntities.Votes.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                return entity;
            }
            catch
            {
                throw;
            }
        }

        public Models.Vote Read(int id) {
            try
            {
                return DbEntities.Votes.First(m => m.Id == id);
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
                var entity = DbEntities.Votes.First(m => m.Id == id);

                DbEntities.DeleteObject(entity);
                DbEntities.SaveChanges();

                return true;
            }
            catch
            {
                throw;
            }
        }

        public Models.Vote First(Models.VoteSearchModel conditions = null) {
            try
            {
                return Search(conditions, 0, 1).First();
            }
            catch
            {
                return null;
            }
        }

        public IEnumerable<Models.Vote> Search(Models.VoteSearchModel conditions = null, int start = 0, int count = -1)
        {
            try
            {
                IEnumerable<Models.Vote> fs =
                (
                    from vote in
                        DbEntities.Votes.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : vote.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : vote.Id > conditions.IdUpper)
                        && ((conditions.ReviewId == null || conditions.ReviewId < 1) ? true : vote.ReviewId == conditions.ReviewId)
                        && ((conditions.Supportive == null) ? true : vote.Supportive == conditions.Supportive)
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : vote.Creator == conditions.Creator)
                    )
                    select vote
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

    public static class VoteAccessControl
    {
        public static bool Pass(byte action, Models.Vote Vote, string accessor = null)
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
                    if (!string.IsNullOrEmpty(accessor) && accessor == Vote.Creator)
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

    public static class VoteDataProccessor
    {
        public static Models.Vote ValidationAndProcess(Models.Vote data)
        {
            try
            {
                ValidationException validationException = new ValidationException();

                try
                {
                    if (data.ReviewId == null || (data.ReviewId < 1) || (new RestfulModels.Review()).Read((int)data.ReviewId) == null)
                    {
                        validationException.ValidationErrors.Add("产品评价为空");
                    }
                }
                catch
                {
                    validationException.ValidationErrors.Add("产品评价为空");
                }

                if (data.Supportive != true) {
                    data.Supportive = false;
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