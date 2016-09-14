using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using db;
using MySql.Data.MySqlClient;

namespace server.account
{
    [HttpUrlRequest("/account/register")]
    internal class register : RequestHandler
    {
        public static bool IsUsername(string username)
        {
            string pattern;
            // start with a letter, allow letter or number, length between 6 to 12.
            pattern = @"^[a-zA-Z][a-zA-Z]{3,20}$";

            var regex = new Regex(pattern);
            return regex.IsMatch(username);
        }

        protected override void HandleRequest()
        {
            using (var db = new Database(Program.Settings.GetValue("conn")))
            {
                byte[] status;
                if (!IsUsername(Query["newGUID"]))
                    status = Encoding.UTF8.GetBytes("<Error>Invalid username</Error>");
                else
                {
                    if (db.HasUuid(Guid) &&
                        db.Verify(Guid, "") != null)
                    {
                        if (db.HasUuid(Query["newGUID"]))
                            status = Encoding.UTF8.GetBytes("<Error>Duplicate username</Error>");
                        else if (db.HasEmail(Query["email"]))
                            status = Encoding.UTF8.GetBytes("<Error>Duplicate email</Error>");
                        else
                        {
                            MySqlCommand cmd = db.CreateQuery();
                            cmd.CommandText =
                                "UPDATE accounts SET uuid=@newUuid, password=SHA1(@password), email=@email, guest=FALSE WHERE uuid=@uuid;";
                            cmd.Parameters.AddWithValue("@uuid", Guid);
                            cmd.Parameters.AddWithValue("@newUuid", Query["newGUID"]);
                            cmd.Parameters.AddWithValue("@password", Query["newPassword"]);
                            cmd.Parameters.AddWithValue("@email", Query["email"]);
                            if (cmd.ExecuteNonQuery() > 0)
                                status = Encoding.UTF8.GetBytes("<Success />");
                            else
                                status = Encoding.UTF8.GetBytes("<Error>Internal Error</Error>");
                        }
                    }
                    else
                    {
						if (db.HasUuid(Query["newGUID"])) {
							status = Encoding.UTF8.GetBytes("<Error>Duplicate username</Error>");
						} else if (db.HasEmail(Query["email"])) {
							status = Encoding.UTF8.GetBytes("<Error>Duplicate email</Error>");
						} else {
							if (db.Register(Query["newGUID"], Query["newPassword"], Query["email"], false, 1, 6) != null)
								status = Encoding.UTF8.GetBytes("<Success />");
							else
								status = Encoding.UTF8.GetBytes("<Error>Internal Error</Error>");
						}
                    }
                }
                Context.Response.OutputStream.Write(status, 0, status.Length);
            }
        }
    }
}