using Entities.Inventory;
using System;
using System.Collections.Generic;
using System.Text;

namespace Business.Items
{
    public class ManageItem : IManageItem
    {
        #region Manage
        bool IManageItem.CreateItem(Inventory inv)
        {
            try
            {
                var data = new DataItem();
                return data.CreateItem(inv);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        bool IManageItem.UpdateItem(Inventory inv)
        {
            try
            {
                var data = new DataItem();
                return data.UpdateItem(inv);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        bool IManageItem.DeleteItem(Inventory inv)
        {
            try
            {
                var data = new DataItem();
                return data.DeleteItem(inv);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        Inventory IManageItem.GetItemById(long itemId)
        {
            try
            {
                var data = new DataItem();
                return data.GetItemById(itemId);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }

        Inventory IManageItem.GetItemAll()
        {
            try
            {
                var data = new DataItem();
                return data.GetItemAll();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
        }
        #endregion Manage

    }
}
