using System;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using db;
using MySql.Data.MySqlClient;

namespace server.picture
{
    [HttpUrlRequest("/picture/get")]
    internal class get : RequestHandler
    {
        private readonly byte[] buff = new byte[0x10000];

        protected override void HandleRequest()
        {
            //warning: maybe has hidden url injection
            string id = Query["id"];
            string instance = Query["instance"];

            byte[] status = Encoding.UTF8.GetBytes("<Error>Bad Request</Error>");
            
            //if (instance != "local" || instance != "production" || instance != "testing")
            //    status = Encoding.UTF8.GetBytes("<Error>Invalid Instance.</Error>");
            try
            {
                using (var db = new Database(Program.Settings.GetValue("conn")))
                {
                    var cmd = db.CreateQuery();

                    cmd.CommandText = "SELECT data, fileSize FROM sprites WHERE id=@id";
                    cmd.Parameters.AddWithValue("@id", Query["id"]);

                    using (MySqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (!rdr.HasRows) return;
                        rdr.Read();

                        Context.Response.ContentType = "image/png";
                        var fileSize = rdr.GetInt32(rdr.GetOrdinal("fileSize"));
                        var raw = new byte[fileSize];
                        var file = rdr.GetBytes(rdr.GetOrdinal("data"), 0, raw, 0, fileSize);
                        status = raw;
                    }
                }
                /*foreach (char i in id)
                {
                    if (char.IsLetter(i) || i == '_' || i == '-') continue;

                    status = Encoding.UTF8.GetBytes("<Error>Invalid ID.</Error>");
                    context.Response.OutputStream.Write(status, 0, status.Length);
                    return;
                }
                string path = Path.GetFullPath("texture/_" + id + ".png");
                if (!File.Exists(path))
                {
                    status = Encoding.UTF8.GetBytes("<Error>Invalid ID.</Error>");
                    context.Response.OutputStream.Write(status, 0, status.Length);
                    return;
                }

                context.Response.ContentType = "image/png";
                using (FileStream i = File.OpenRead(path))
                {
                    int c;
                    while ((c = i.Read(buff, 0, buff.Length)) > 0)
                        context.Response.OutputStream.Write(buff, 0, c);
                }*/
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
            Context.Response.OutputStream.Write(status, 0, status.Length);
        }
    }
}