using System;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using db;

namespace server.guild
{
    [HttpUrlRequest("/guild/listMembers")]
    internal class listMembers : RequestHandler
    {
        protected override void HandleRequest()
        {
            using (var db = new Database(Program.Settings.GetValue("conn")))
            {
                Account acc = db.Verify(Guid, Password);
                int num = Convert.ToInt32(Query["num"]);
                int offset = Convert.ToInt32(Query["offset"]);
                if (num == 0)
                {
                    num = 50;
                }
                byte[] status;
                if (acc == null)
                    status = Encoding.UTF8.GetBytes("<Error>Account credentials not valid</Error>");
                else
                {
                    try
                    {
                        status = Encoding.UTF8.GetBytes(db.HttpGetGuildMembers(num, offset, acc));
                    }
                    catch
                    {
                        status = Encoding.UTF8.GetBytes("<Error>Guild member error</Error>");
                    }
                }
                Context.Response.OutputStream.Write(status, 0, status.Length);
            }
        }
    }
}