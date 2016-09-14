using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Schema;
using System.Xml.Serialization;

namespace server.app
{
    [HttpUrlRequest("/app/init")]
    public class init : RequestHandler
    {
        protected override void HandleRequest()
        {
            //var buff = File.ReadAllBytes("app/AppEngineSettings.xml");
            //Context.Response.OutputStream.Write(buff, 0, buff.Length);
            var serializer = new XmlSerializer(typeof(AppEngineSettings));
            serializer.Serialize(Context.Response.OutputStream, AppEngineSettings.Instance);
        }
    }

    public class AppEngineSettings
    {
        [XmlIgnore]
        public static AppEngineSettings Instance { get; }

        static AppEngineSettings()
        {
            var serializer = new XmlSerializer(typeof(AppEngineSettings));
            using (var stm = File.OpenRead("app/AppEngineSettings.xml"))
                Instance = (AppEngineSettings)serializer.Deserialize(stm);
        }

        public int CharSlotCurrency { get; set; }
        public List<SoundPack> SoundPacks { get; set; } 

        public class SoundPack
        {
            [XmlAttribute("id")]
            public string Id { get; set; }
            [XmlAttribute("displayId")]
            public string DisplayId { get; set; }

            public string Description { get; set; }

            [XmlElement("Music")]
            public XmlBool ContainsMusic { get; set; }
            [XmlElement("Sounds")]
            public XmlBool ContainsSound { get; set; }

            public bool ShouldSerializeContainsMusic()
            {
                return ContainsMusic;
            }

            public bool ShouldSerializeContainsSound()
            {
                return ContainsSound;
            }
        }
    }
}
