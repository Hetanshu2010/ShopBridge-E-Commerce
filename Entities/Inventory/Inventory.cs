using System;
using Entities.Common.Audit;
using System.Collections.Generic;
using System.Text;

namespace Entities.Inventory
{
    public class Inventory
    {
        public long ItemId { get; set; }
        public string ItemCode { get; set; }
        public string ItemName { get; set; }
        public string ItemDesc { get; set; }      
        public string Remarks { get; set; }

        public AuditInfo AuditDetail { get; set; }
    }
}
