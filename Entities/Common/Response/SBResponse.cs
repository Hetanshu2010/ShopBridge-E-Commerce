using System;
using System.Collections.Generic;
using System.Text;

namespace Entities.Common.Response
{
    public class SBResponse
    {
        public SBDataResponse Response { get; set; }
    }

    public class SBDataResponse
    {
        public int Status { get; set; }
        public object Data { get; set; }
        public string Message { get; set; }
        public dynamic TotalRowCount { get; set; }
    }
}
