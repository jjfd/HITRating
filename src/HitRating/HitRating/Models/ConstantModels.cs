using System;
using System.Collections.Generic;

namespace HitRating.Models
{
    public static class ApplicationConfig
    {
        public static string Domain = "/";
        public static string DefaultPassword = "666666";
        public static string ImagePath = AppDomain.CurrentDomain.BaseDirectory + "Uploads\\Images\\";
        public static string DefaultAccountPhotoUrl = Domain + "Images/default_photo.jpg";
    }

    public static class RestfulAction
    {
        public static byte Create = 1;
        public static byte Read = 2;
        public static byte Update = 3;
        public static byte Delete = 4;
        public static byte Search = 5;
    }

    public static class ReviewType
    {
        public static byte Review = 1;
        public static byte News = 2;
    }
}