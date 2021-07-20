using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ShopBridgeAPI.Utilities
{
    public static class ErrorMessages
    {
        public static class Item
        {
            // 1051 - 1060
            public static class CategoryNotFound
            {
                public const int Code = 1017;
                public const string Message = "Category not found";
            }
            public static class CreatedByNotFound
            {
                public const int Code = 1018;
                public const string Message = "Authorization Failed! Request can not processed";
            }
            public static class InvalidItemId
            {
                public const int Code = 1019;
                public const string Message = "Item id is not valid!";
            }
            public static class ItemIdNotFound
            {
                public const int Code = 1020;
                public const string Message = "Item is not found!";
            }
            public static class ItemAlreadyClosed
            {
                public const int Code = 1021;
                public const string Message = "Item already deleted!";
            }
            public static class InvalidOperation
            {
                public const int Code = 1022;
                public const string Message = "The operation cannot be performed because the request is locked!";
            }
            public static class ItemAlreadyRejected
            {
                public const int Code = 1023;
                public const string Message = "Item already rejected!";
            }
            public static class UnableToProcess
            {
                public const int Code = 1024;
                public const string Message = "Due to some technical problem we are unable to process your request currently!";
            }
            public static class ItemNameIsrequired
            {
                public const int Code = 1025;
                public const string Message = "Item name is mandatory!";
            }
        }
    }
}
