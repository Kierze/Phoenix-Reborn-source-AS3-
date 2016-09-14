using System.Text;
using db;

namespace server.credits
{
    [HttpUrlRequest("/credits/add")]
    internal class add : RequestHandler
    {
        protected override void HandleRequest()
        {
            string status;
            using (var db = new Database(Program.Settings.GetValue("conn")))
            {
                var cmd = db.CreateQuery();
                cmd.CommandText = "SELECT id FROM accounts WHERE uuid=@uuid";
                cmd.Parameters.AddWithValue("@uuid", Guid);
                var id = cmd.ExecuteScalar();

                if (id != null)
                {
                    Context.Response.Redirect($"http://fabianotesting.cloudapp.net/PayPal/member/createPayment.php?userId={id}&jwt={Query["jwt"]}");
                    return;
                }
                status = "Account not exists :(";
            }

            var res = Encoding.UTF8.GetBytes(
                @"<html>
    <head>
        <title>Ya...</title>
    </head>
    <body style='background: #333333'>
        <h1 style='color: #EEEEEE; text-align: center'>
            " + status + @"
        </h1>
    </body>
</html>");
            Context.Response.OutputStream.Write(res, 0, res.Length);
        }
    }
}