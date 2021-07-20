using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ShopBridgeAPI.Controllers.Items
{
    public class ItemRoute
    {
        public const string Item = "api/item";
        public const string ItemById = "api/item/{id}";
        public const string ActivateItemById = "api/item/activate/{id}";
        public const string DeactivateItemById = "api/item/deactivate/{id}";
        public const string DeleteItemById = "api/item/delete/{id}";
    }
}
