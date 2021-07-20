using CommonFramework;
using Entities.Inventory;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace Business.Items
{
    internal class DataItem
    {
        #region Manage
        internal bool CreateItem(Inventory inv)
        {
            try
            {
                using (SqlConnection cn = DataConnection.State.Connection)
                {
                    var cmd = new SqlCommand("Item_Create", cn) { CommandType = CommandType.StoredProcedure };
                    cmd.Parameters.Add("@itemName", SqlDbType.VarChar, 200).Value = inv.ItemName;
                    cmd.Parameters.Add("@itemDesc", SqlDbType.VarChar, 2000).Value = inv.ItemDesc;             
                    cmd.Parameters.Add("@remarks", SqlDbType.VarChar, 1000).Value = inv.Remarks;
                    if (inv.AuditDetail != null)
                    {
                        cmd.Parameters.Add("@createdBy", SqlDbType.VarChar, 200).Value = inv.AuditDetail.CreatedBy;
                    }
                    return cmd.ExecuteAndValidateNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        internal bool UpdateItem(Inventory inv)
        {
            try
            {
                using (SqlConnection cn = DataConnection.State.Connection)
                {
                    var cmd = new SqlCommand("Item_Update", cn) { CommandType = CommandType.StoredProcedure };
                    cmd.Parameters.Add("@itemId", SqlDbType.BigInt).Value = inv.ItemId;
                    cmd.Parameters.Add("@itemName", SqlDbType.VarChar, 200).Value = inv.ItemName;
                    cmd.Parameters.Add("@itemDesc", SqlDbType.VarChar, 2000).Value = inv.ItemDesc;                                     
                    cmd.Parameters.Add("@remarks", SqlDbType.VarChar, 1000).Value = inv.Remarks;

                    if (inv.AuditDetail != null)
                    {
                        cmd.Parameters.Add("@modifiedBy", SqlDbType.VarChar, 50).Value = inv.AuditDetail.ModifiedBy;
                    }

                    return cmd.ExecuteAndValidateNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }      

        internal bool DeleteItem(Inventory inv)
        {
            try
            {
                using (SqlConnection cn = DataConnection.State.Connection)
                {
                    var cmd = new SqlCommand("Item_Delete", cn) { CommandType = CommandType.StoredProcedure };
                    cmd.Parameters.Add("@itemId", SqlDbType.BigInt).Value = inv.ItemId;
                    cmd.Parameters.Add("@remarks", SqlDbType.NVarChar, 1000).Value = inv.Remarks;

                    if (inv.AuditDetail != null)
                    {
                        cmd.Parameters.Add("@deletedBy", SqlDbType.VarChar, 50).Value = inv.AuditDetail.DeletedBy;
                    }
                    return cmd.ExecuteAndValidateNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        internal Inventory GetItemById(long itemId)
        {
            Inventory itemRequest = null;
            try
            {
                using (SqlConnection cn = DataConnection.State.Connection)
                {
                    var cmd = new SqlCommand("Item_ById", cn) { CommandType = CommandType.StoredProcedure };

                    cmd.Parameters.Add("@itemId", SqlDbType.BigInt).Value = itemId;

                    cmd.Connection = cn;
                    using (var rs = cmd.ExecuteReader())
                    {
                        while (rs.Read())
                        {
                            itemRequest = ReadItem(rs);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            return itemRequest;
        }

        internal Inventory GetItemAll()
        {
            Inventory itemRequest = null;
            try
            {
                using (SqlConnection cn = DataConnection.State.Connection)
                {
                    var cmd = new SqlCommand("Item_Getall", cn) { CommandType = CommandType.StoredProcedure };                 
                    cmd.Connection = cn;
                    using (var rs = cmd.ExecuteReader())
                    {
                        while (rs.Read())
                        {
                            itemRequest = ReadItem(rs);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            return itemRequest;
        }

        private static ItemDetail ReadItem(SqlDataReader reader)
        {
            var itemId = reader.IsDBNull(0) ? 0 : reader.GetInt64(0);
            var itemCode = reader.IsDBNull(1) ? string.Empty : reader.GetString(1);
            var itemName = reader.IsDBNull(2) ? string.Empty : reader.GetString(2);
            var itemDesc = reader.IsDBNull(3) ? string.Empty : reader.GetString(3);
            var remarks = reader.IsDBNull(4) ? string.Empty : reader.GetString(4);
            var createdBy = reader.IsDBNull(5) ? string.Empty : reader.GetString(5);
            var createdOn = reader.IsDBNull(6) ? DateTime.MinValue : reader.GetDateTime(6);
            var modifiedBy = reader.IsDBNull(7) ? string.Empty : reader.GetString(7);
            var modifiedOn = reader.IsDBNull(8) ? DateTime.MinValue : reader.GetDateTime(8);

            var requestInfo = new ItemDetail
            {
                ItemId = itemId,
                ItemCode = itemCode,
                ItemName = itemName,
                ItemDesc = itemDesc,
                Remarks = remarks,
                AuditDetail = new Entities.Common.Audit.AuditInfo
                {
                    CreatedBy = createdBy,
                    CreatedOn = createdOn,
                    ModifiedBy = modifiedBy,
                    ModifiedOn = modifiedOn
                }
            };
            return requestInfo;
        }
        #endregion Manage


    }
}
