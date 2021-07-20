using System;
using System.Collections.Generic;
using System.Text;
using Entities.Inventory;

namespace Business.Items
{
    public interface IManageItem
    {
        bool CreateItem(Inventory inv);
        bool UpdateItem(Inventory inv);
        bool DeleteItem(Inventory inv);
        Inventory GetItemById(long itemId);

        Inventory GetItemAll();
    }
}
