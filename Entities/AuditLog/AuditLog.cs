using System;
using System.Collections.Generic;
using System.Text;

namespace Entities.AuditLog
{
    public class AuditLog
    {
        public long AuditLogId { get; set; }
        public long RefId { get; set; }
        public Guid RefType { get; set; }
        public string ActionDesc { get; set; }
        public string Comments { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
    }
}