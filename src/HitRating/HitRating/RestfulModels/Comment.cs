using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using HitRating.Models;

namespace HitRating.RestfulModels
{
    public class Comment
    {
        private RestfulComment RestfulComment;

        public Comment()
        {
            RestfulComment = new RestfulComment();
        }

        public Models.Comment Create(Models.Comment entity, string userName)
        {
            try
            {
                if (!CommentAccessControl.Pass(RestfulAction.Create, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.Creator = userName;
                entity.Created = DateTime.Now;

                return RestfulComment.Create(entity);
            }
            catch
            {
                throw;
            }
        }

        public Models.Comment Read(int id, string userName = null)
        {
            try
            {
                var entity = RestfulComment.Read(id);

                if (!CommentAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public Models.Comment Update(int id, Models.Comment entity, string userName)
        {
            try
            {
                var old = RestfulComment.Read(id);

                if (!CommentAccessControl.Pass(RestfulAction.Update, old, userName))
                {
                    throw new NoAccessException("No Access");
                }

                entity.ReviewId = old.ReviewId;
                entity.Created = old.Created;
                entity.Updated = DateTime.Now;

                return RestfulComment.Update(id, entity);
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
                var entity = RestfulComment.Read(id);

                if (!CommentAccessControl.Pass(RestfulAction.Delete, entity, userName))
                {
                    throw new NoAccessException("No Access");
                }

                return RestfulComment.Delete(id);
            }
            catch
            {
                throw;
            }
        }

        public Models.Comment First(Models.CommentSearchModel conditions = null, string userName = null)
        {
            try
            {
                var entity = RestfulComment.First(conditions);

                if (!CommentAccessControl.Pass(RestfulAction.Read, entity, userName))
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

        public IEnumerable<Models.Comment> Search(Models.CommentSearchModel conditions = null, int start = 0, int count = 0, string userName = null)
        {
            try
            {
                return RestfulComment.Search(conditions, start, count);
            }
            catch
            {
                throw;
            }
        }
    }

    public class RestfulComment
    {
        private Entities DbEntities;

        public RestfulComment() 
        {
            DbEntities = new Entities();
        }

        public Models.Comment Create(Models.Comment entity) 
        {
            try
            {
                entity = CommentDataProccessor.ValidationAndProcess(entity);

                DbEntities.Comments.AddObject(entity);
                DbEntities.SaveChanges();
                DbEntities.Refresh(System.Data.Objects.RefreshMode.StoreWins, entity);

                return entity;
            }
            catch
            {
                throw;
            }
        }

        public Models.Comment Update(int id, Models.Comment entity)
        {
            try
            {
                entity = CommentDataProccessor.ValidationAndProcess(entity);
                entity.Id = id;

                DbEntities.ApplyCurrentValues("Comments", entity);
                DbEntities.SaveChanges();

                return entity;
            }
            catch 
            {
                throw;    
            }
        }

        public Models.Comment Read(int id) {
            try
            {
                return DbEntities.Comments.First(m => m.Id == id);
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
                var entity = DbEntities.Comments.First(m => m.Id == id);

                DbEntities.DeleteObject(entity);
                DbEntities.SaveChanges();

                return true;
            }
            catch
            {
                throw;
            }
        }

        public Models.Comment First(Models.CommentSearchModel conditions = null) {
            try
            {
                return Search(conditions, 0, 1).First();
            }
            catch
            {
                return null;
            }
        }

        public IEnumerable<Models.Comment> Search(Models.CommentSearchModel conditions = null, int start = 0, int count = -1)
        {
            try
            {
                IEnumerable<Models.Comment> fs =
                (
                    from comment in
                        DbEntities.Comments.OrderByDescending(m => m.Id)
                    where
                    (
                        ((conditions.IdLower == null || conditions.IdLower < 1) ? true : comment.Id < conditions.IdLower)
                        && ((conditions.IdUpper == null || conditions.IdUpper < 1) ? true : comment.Id > conditions.IdUpper)
                        && ((conditions.ReviewId == null || conditions.ReviewId < 1) ? true : comment.ReviewId == conditions.ReviewId)
                        && (string.IsNullOrEmpty(conditions.Creator) ? true : comment.Creator == conditions.Creator)
                    )
                    select comment
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

    public static class CommentAccessControl
    {
        public static bool Pass(byte action, Models.Comment Comment, string accessor = null)
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
                    if (!string.IsNullOrEmpty(accessor) && Comment.Creator == accessor)
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
                    if (!string.IsNullOrEmpty(accessor) && Comment.Creator == accessor)
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

    public static class CommentDataProccessor
    {
        public static Models.Comment ValidationAndProcess(Models.Comment data)
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

                //Commenter
                if (string.IsNullOrEmpty(data.Details))
                {
                    validationException.ValidationErrors.Add("评论内容为空");
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