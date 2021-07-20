using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;
using System.Threading.Tasks;

namespace CommonFramework
{
    [Serializable]
    public sealed class DataConnection
    {
        private readonly String _connectionString;
        private SqlConnection _asyncConnection;
        private SqlConnection _connection;


        public DataConnection(String connectionString)
        {
            _connectionString = connectionString;
        }

        public static DataConnection State
        {
            get
            {
                if (!SystemConfiguration.Load())
                    throw new ApplicationException("Could not load system configuration");
                string connectionString = SystemConfiguration.ConnectionString;
                return Create(connectionString);
            }
        }

        public SqlConnection AsyncConnection
        {
            get
            {
                {
                    _asyncConnection = new SqlConnection(String.Format("{0}; {1}", _connectionString, "Asynchronous Processing=true;"));
                    _asyncConnection.Open();
                    return _asyncConnection;
                }
            }
        }

        public SqlConnection Connection
        {
            get
            {
                _connection = new SqlConnection(_connectionString);
                Task task = Task.Run(async () =>
                {
                    await _connection.OpenAsync();                    
                });
                task.Wait();
                return _connection;
            }
        }

        public string ConnectionState
        {
            get
            {
                return _connectionString;
            }
        }

        private static DataConnection Create(String connectionString)
        {
            return new DataConnection(connectionString);
        }
    }
}
