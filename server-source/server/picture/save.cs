using db;
using db.utils;
using System;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Text;
using System.Web;

namespace server.picture
{
    [HttpUrlRequest("/picture/save")]
    internal class save : RequestHandler
    {
        private byte[] buff = new byte[0x10000];

        protected override void HandleRequest()
        {
            HttpMultipartParser parser = new HttpMultipartParser(Context.Request.InputStream, "data");

            if (parser.Success)
            {
                using (var db = new Database(Program.Settings.GetValue("conn")))
                {
                    Account acc = db.Verify(parser.Parameters["guid"], parser.Parameters["password"]);
                    var cmd = db.CreateQuery();
                    var guid = parser.Parameters["guid"];
                    if (guid == "Admin" && !acc.Admin)
                        guid = "Guest";
                    if (parser.Parameters["admin"] == "true" && acc.Admin)
                        guid = "Admin";

                    cmd.CommandText = "INSERT INTO sprites(guid, name, dataType, tags, data, fileSize) VALUES(@guid, @name, @dataType, @tags, @data, @fileSize)";
                    cmd.Parameters.AddWithValue("@guid", guid);
                    cmd.Parameters.AddWithValue("@name", parser.Parameters["name"]);
                    cmd.Parameters.AddWithValue("@dataType", parser.Parameters["datatype"]);
                    cmd.Parameters.AddWithValue("@tags", parser.Parameters["tags"].Replace(", ", ",").Replace(" ,", ",").Trim());
                    cmd.Parameters.AddWithValue("@data", parser.FileContents);
                    cmd.Parameters.AddWithValue("@fileSize", parser.FileContents.Length);

                    try
                    {
                        var status = Encoding.UTF8.GetBytes(cmd.ExecuteNonQuery() > 0 ? "<Success/>" : "<Error>Account credentials not valid</Error>");
                        Context.Response.OutputStream.Write(status, 0, status.Length);
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                    }
                }
            }
        }
    }
}