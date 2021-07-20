using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Text;
using System.Xml;

namespace CommonFramework
{
    public static class Utility
    {
        public static bool ExecuteAndValidateNonQuery(this SqlCommand cmd)
        {
            var returnParam = new SqlParameter(@"RETURN_VALUE", SqlDbType.Int)
            {
                Direction = ParameterDirection.ReturnValue
            };
            cmd.Parameters.Add(returnParam);
            cmd.ExecuteNonQuery();

            if ((int)returnParam.Value == 0) return true; // Success

            throw new Exception(string.Format("Command='{0}', Code={1}", cmd.CommandText, (int)returnParam.Value));
        }

        public static int ExecuteAndValidateNonQueryWithReturn(this SqlCommand cmd)
        {
            var returnParam = new SqlParameter(@"RETURN_VALUE", SqlDbType.Int)
            {
                Direction = ParameterDirection.ReturnValue
            };
            cmd.Parameters.Add(returnParam);
            cmd.ExecuteNonQuery();

            var iRet = (int)returnParam.Value;
            if (iRet != 2)
                return iRet;

            throw new Exception(string.Format("Command='{0}', Code={1}", cmd.CommandText, (int)returnParam.Value));
        }

        public static bool ExecuteAndValidateNonQueryExtension(this SqlCommand cmd)
        {
            var returnParam = new SqlParameter(@"RETURN_VALUE", SqlDbType.Int)
            {
                Direction = ParameterDirection.ReturnValue
            };
            cmd.Parameters.Add(returnParam);
            cmd.ExecuteNonQuery();

            if ((int)returnParam.Value == 0)
                return true; // Success
            if ((int)returnParam.Value == 1)
                return false; // Success

            throw new Exception(string.Format("Command='{0}', Code={1}", cmd.CommandText, (int)returnParam.Value));
        }

        public static string ExecuteAndValidateNonQuery(this SqlCommand cmd, string returnParameter)
        {
            try
            {
                var outputParam = new SqlParameter("@" + returnParameter, SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                cmd.Parameters.Add(outputParam);

                cmd.ExecuteNonQuery();

                return outputParam.Value.ToString();
            }
            catch (Exception ex)
            {
                return "Error : " + ex.Message;
            }
        }

        public static int ExecuteAndValidateNonQueryWithCode(this SqlCommand cmd)
        {
            var returnParam = new SqlParameter(@"RETURN_VALUE", SqlDbType.Int)
            {
                Direction = ParameterDirection.ReturnValue
            };
            cmd.Parameters.Add(returnParam);
            cmd.ExecuteNonQuery();

            return (int)returnParam.Value; // Success

            //throw new Exception(String.Format("Command='{0}', Code={1}", cmd.CommandText, (int)returnParam.Value));
        }

        public static string GetBase64StringFromImageUrl(string imagePath)
        {
            using (Image image = Image.FromFile(imagePath))
            {
                using (MemoryStream m = new MemoryStream())
                {
                    image.Save(m, image.RawFormat);

                    return Convert.ToBase64String(m.ToArray());
                }
            }
        }

        public static string GetXmlForIds(List<long> ids)
        {
            var sw = new StringWriter();
            using (XmlWriter writer = new XmlTextWriter(sw))
            {
                writer.WriteStartElement("Items");
                foreach (var id in ids)
                {
                    writer.WriteStartElement("Item");
                    writer.WriteAttributeString("value", id.ToString());
                    writer.WriteEndElement();
                }
                writer.WriteEndElement();
            }

            return sw.ToString();
        }

        public static string GetXmlForIds(List<int> ids)
        {
            var sw = new StringWriter();
            using (XmlWriter writer = new XmlTextWriter(sw))
            {
                writer.WriteStartElement("Items");
                foreach (var id in ids)
                {
                    writer.WriteStartElement("Item");
                    writer.WriteAttributeString("value", id.ToString());
                    writer.WriteEndElement();
                }
                writer.WriteEndElement();
            }

            return sw.ToString();
        }

        public static string GetEnumDescription(Enum value)
        {
            var type = value.GetType();
            var fieldIInfo = type.GetField(Enum.GetName(type, value));
            if (fieldIInfo != null)
            {
                var attribute =
                    (System.ComponentModel.DescriptionAttribute)
                        Attribute.GetCustomAttribute(fieldIInfo, typeof(System.ComponentModel.DescriptionAttribute));
                return attribute != null ? attribute.Description : value.ToString();
            }
            return string.Empty;
        }
    }
}
