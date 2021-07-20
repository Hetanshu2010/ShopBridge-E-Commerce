using System;
using System.Collections.Generic;
using System.Text;

namespace Entities.Inventory
{
    public class ItemDetail : Inventory
    {
        public string ItemTypeDesc { get; set; }
        public string CategoryName { get; set; }
    }
}