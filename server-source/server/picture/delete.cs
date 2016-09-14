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
    [HttpUrlRequest("/picture/delete")]
    internal class delete : RequestHandler
    {
        protected override void HandleRequest()
        {
            using (var db = new Database(Program.Settings.GetValue("conn")))
            {
                var cmd = db.CreateQuery();

                string user = Guid;

                string owner = "";
                bool isOwner = false;

                cmd.CommandText = "SELECT guid FROM sprites WHERE id=@id LIMIT 1";
                cmd.Parameters.AddWithValue("@id", Query["id"]);

                using (MySqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (!rdr.HasRows) return;
                    rdr.Read();
                    
                    owner = rdr.GetString("guid");

                    if (user == owner)
                    {
                        isOwner = true;
                    }
                }
                byte[] status = Encoding.UTF8.GetBytes("<Error>You can't delete this sprite</Error>");
                if (isOwner)
                {
                    cmd = db.CreateQuery();
                    cmd.CommandText = "DELETE FROM sprites WHERE(id=@id AND guid=@guid) LIMIT 1";
                    cmd.Parameters.AddWithValue("@id", Query["id"]);
                    cmd.Parameters.AddWithValue("@guid", owner);

                    if (cmd.ExecuteNonQuery() > 0)
                    {
                        status = Encoding.UTF8.GetBytes("<Success/>");
                    }
                    Context.Response.OutputStream.Write(status, 0, status.Length);
                    return;
                }

                Context.Response.OutputStream.Write(status, 0, status.Length);
            }
        }
    }
}