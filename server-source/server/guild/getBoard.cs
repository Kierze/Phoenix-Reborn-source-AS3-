using System;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using db;

namespace server.guild
{
    [HttpUrlRequest("/guild/getBoard")]
    internal class getBoard : RequestHandler
    {
        protected override void HandleRequest()
        {
            using (var db = new Database(Program.Settings.GetValue("conn")))
            {
                Account acc = db.Verify(Guid, Password);
                byte[] status;
                if (acc == null)
                    status = Encoding.UTF8.GetBytes("<Error>Account credentials not valid</Error>");
                else
                {
                    try
                    {
                        status = Encoding.UTF8.GetBytes(db.GetGuildBoard(acc));
                    }
                    catch (Exception e)
                    {
                        status = Encoding.UTF8.GetBytes("<Error>" + e.Message + "</Error>");
                    }
                }
                Context.Response.OutputStream.Write(status, 0, status.Length);
            }
        }
    }
}