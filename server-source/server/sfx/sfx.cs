using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Xml.Linq;
using System.Xml.XPath;

namespace server.sfx
{
    [HttpUrlRequest("/sfx/*")]
    [HttpUrlRequest("/music/*")]
    internal class sfx : RequestHandler
    {
        protected override void HandleRequest()
        {
            if (!RunPreCheck())
                return;
            ProcessRequest();
        }

        private bool RunPreCheck()
        {
            var parameters = Context.Request.Url.LocalPath.Split(new [] { '/' }, StringSplitOptions.RemoveEmptyEntries);
            if (parameters.Length < 3)
            {
                WriteError("Invalid url length.");
                return false;
            }

            IsMusic = parameters[0].ToLower() == "music";
            PackName = parameters[1];
            RequestedFile = String.Join("/", parameters.Skip(2));
            return true;
        }

        private bool IsMusic { get; set; }
        private string PackName { get; set; }
        private string RequestedFile { get; set; }

        private void ProcessRequest()
        {
            var soundpack = SoundPack.Get(PackName);
            string soundPackPath;
            string collectionPath;
            var file = (IsMusic ? soundpack.Music : soundpack.Sound).GetSound(RequestedFile, out collectionPath, out soundPackPath);
            if (file == null)
            {
                WriteError("File not found.");
                return;
            }
            WriteFile(soundPackPath + collectionPath + file.Path);
        }

        protected void WriteFile(string path)
        {
            using (var fs = File.OpenRead(path))
            {
                Context.Response.ContentLength64 = fs.Length;
                Context.Response.SendChunked = false;
                Context.Response.ContentType = "audio/mpeg";

                var buffer = new byte[fs.Length];
                using (var bw = new BinaryWriter(Context.Response.OutputStream))
                {
                    int read;
                    while ((read = fs.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        try
                        {
                            bw.Write(buffer, 0, read);
                            bw.Flush(); //seems to have no effect
                        }
                        catch (Exception)
                        {
                            // ignored
                        }
                        
                    }

                    bw.Close();
                }
            }
        }

        public class SoundPack
        {
            private static readonly Dictionary<string, SoundPack> m_packs = new Dictionary<string, SoundPack>();

            private readonly XElement elem;

            public SoundCollection Music { get; private set; }
            public SoundCollection Sound { get; private set; }

            public string Name { get; }
            public string FolderLocation { get; }
            public bool Initialized => Music != null;

            public SoundPack(XElement elem)
            {
                this.elem = elem;
                Name = elem.Attribute("name").Value;
                FolderLocation = elem.Attribute("folderPath").Value;
            }

            public static void LoadSoundPacks()
            {
                var xmls = Directory.EnumerateFiles("sfx\\packs", "*.xml", SearchOption.AllDirectories).ToArray();
                for (var i = 0; i < xmls.Length; i++)
                {
                    log.InfoFormat("Loading Soundpack '{0}'({1}/{2})...", xmls[i], i + 1, xmls.Length);
                    using (Stream stream = File.OpenRead(xmls[i]))
                    {
                        var pack = new SoundPack(XElement.Load(stream));
                        m_packs.Add(pack.Name, pack);
                    }
                }

                foreach (var kvp in m_packs.Where(_ => !_.Value.Initialized))
                    kvp.Value.Initialize();
            }

            public static SoundPack Get(string name)
            {
                SoundPack pack;
                if (!m_packs.TryGetValue(name, out pack))
                    return null;
                if (!pack.Initialized)
                    pack.Initialize();
                return pack;
            }

            private void Initialize()
            {
                if (Initialized) return;
                log.InfoFormat("Initializing Soundpack '{0}'...", Name);
                Music = new SoundCollection(elem.Element("MusicList"), this);
                Sound = new SoundCollection(elem.Element("SoundList"), this);
            }
        }

        public class SoundObject
        {
            public string Name { get; }
            public string Path { get; }

            public SoundObject(XElement elem)
            {
                Name = elem.Attribute("name").Value;
                Path = elem.Attribute("path").Value.Replace("{SameAsName}", Name);
            }

            public SoundObject(string path)
            {
                Path = path;
                Name = (path.StartsWith("\\") || path.StartsWith("/") ? path.Remove(0, 1) : path).Replace(".mp3", String.Empty).Replace("\\", "/");
            }
        }

        public class SoundCollection
        {
            private readonly SoundPack parent;

            public SoundCollection SoundInherits { get; }
            public List<SoundObject> Sounds { get; }
            public bool Inherits { get; }
            public string FolderPath { get; }

            public SoundCollection(XElement root, SoundPack parent)
            {
                this.parent = parent;
                Sounds = new List<SoundObject>();
                Inherits = root.Attribute("inheritFrom") != null;
                if (Inherits)
                    SoundInherits = (root.Name == "MusicList" ? SoundPack.Get(root.Attribute("inheritFrom").Value).Music : SoundPack.Get(root.Attribute("inheritFrom").Value).Sound);
                FolderPath = root.Attribute("folderPath")?.Value ?? String.Empty;

                var pathInformation = root.Attribute("pathInformation")?.Value;
                
                switch (pathInformation)
                {
                    case "%allfiles%":
                        var files = Directory.GetFiles(parent.FolderLocation + FolderPath, "*", SearchOption.AllDirectories);
                        foreach (var file in files)
                            Sounds.Add(new SoundObject(file.Remove(0, file.IndexOf(FolderPath, StringComparison.InvariantCulture) + FolderPath.Length)));
                        break;
                }

                if (root.Name == "MusicList")
                    foreach (var elem in root.XPathSelectElements("//Music"))
                        Sounds.Add(new SoundObject(elem));
                else
                    foreach (var elem in root.XPathSelectElements("//Sound"))
                        Sounds.Add(new SoundObject(elem));
            }

            public SoundObject GetSound(string name, out string path, out string soundPackPath)
            {
                var sp = parent.FolderLocation;
                var p = FolderPath;
                SoundObject sound;
                if (name == "MainTheme.mp3")
                {
                    var sounds = Sounds.Where(_ => _.Name.StartsWith("MainTheme")).ToList();
                    if (!sounds.Any() && Inherits)
                        sound = SoundInherits.GetSound(name, out p, out sp);
                    else
                    {
                        sounds.Shuffle();
                        sound = sounds[0];
                    }
                }
                else
                    sound = Sounds.FirstOrDefault(_ => _.Name == name.Replace(".mp3", String.Empty)) ??
                            (Inherits ? SoundInherits.GetSound(name, out p, out sp) : null);
                soundPackPath = sp;
                path = p;
                return sound;
            }
        }
    }
}
