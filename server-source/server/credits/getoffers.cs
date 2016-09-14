using System.Collections.Generic;
using System.Net;
using System.Text;
using System.Xml;
using db;

namespace server.credits
{
    [HttpUrlRequest("/credits/getoffers")]
    internal class getoffers : RequestHandler
    {
        protected override void HandleRequest()
        {
            var doc = new XmlDocument();
            var offers = doc.CreateElement("Offers");
            doc.AppendChild(offers);
            var tok = doc.CreateElement("Tok");
            tok.InnerText = "WUT";
            var exp = doc.CreateElement("Exp");
            exp.InnerText = "STH";

            offers.AppendChild(tok);
            offers.AppendChild(exp);

            foreach (var o in Offer.Offers)
            {
                var oNode = doc.CreateElement("Offer");
                var id = doc.CreateElement("Id");
                id.InnerText = o.Id.ToString();

                var price = doc.CreateElement("Price");
                price.InnerText = o.Price.ToString();

                var realmGold = doc.CreateElement("RealmGold");
                realmGold.InnerText = o.RealmGold.ToString();

                var checkoutJWT = doc.CreateElement("CheckoutJWT");
                checkoutJWT.InnerText = o.CheckoutJWT.ToString();

                var data = doc.CreateElement("Data");
                data.InnerText = o.Data;

                var currency = doc.CreateElement("Currency");
                currency.InnerText = o.Currency;

                oNode.AppendChild(id);
                oNode.AppendChild(price);
                oNode.AppendChild(realmGold);
                oNode.AppendChild(checkoutJWT);
                oNode.AppendChild(data);
                oNode.AppendChild(currency);
                offers.AppendChild(oNode);
            }

            doc.Save(Context.Response.OutputStream);
        }

        public class Offer
        {
            public static List<Offer> Offers { get; }

            static Offer()
            {
                Offers = new List<Offer>();
                using (var db = new Database(Program.Settings.GetValue<string>("conn")))
                {
                    var cmd = db.CreateQuery();
                    cmd.CommandText = "SELECT * FROM offers";
                    using (var rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            Offers.Add(new Offer
                            {
                                Id = rdr.GetInt32("id"),
                                Price = rdr.GetInt32("price"),
                                CheckoutJWT = rdr.GetInt32("gold"),
                                RealmGold = rdr.GetInt32("gold"),
                                Currency = "EUR",
                                Data = "MyFrend"
                            });
                        }
                    }
                }
            }

            public int Id { get; set; }
            public int Price { get; set; }
            public int RealmGold { get; set; }
            public int CheckoutJWT { get; set; }
            public string Data { get; set; }
            public string Currency { get; set; }
        }
    }
}