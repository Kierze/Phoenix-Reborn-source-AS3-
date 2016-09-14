using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using db;
using MySql.Data.MySqlClient;

namespace server.account
{
    [HttpUrlRequest("/account/changePassword")]
    internal class changePassword : RequestHandler
    {
        protected override void HandleRequest()
        {
            using (var db = new Database(Program.Settings.GetValue("conn")))
            {
                var acc = db.Verify(Guid, Password);
                if (acc == null)
                    WriteError("Account credentials not valid");
                else
                {
                    var cmd = db.CreateQuery();
                    cmd.CommandText = "UPDATE accounts SET password=SHA1(@password) WHERE id=@accId;";
                    cmd.Parameters.AddWithValue("@accId", acc.AccountId);
                    cmd.Parameters.AddWithValue("@password", Query["newPassword"]);
                    if (cmd.ExecuteNonQuery() > 0)
                        Write("<Success />");
                    else
                        WriteError("Internal error");
                }
            }
        }
    }
}