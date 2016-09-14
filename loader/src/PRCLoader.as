package {

    import com.company.versionedloader.VersionedLoader;

    [SWF(backgroundColor="#000000", width="1024", height="768", frameRate="60")]
    public class PRCLoader extends VersionedLoader
    {
        public function PRCLoader()
        {
            super("PhoenixRealmClient");
        }
    }
}
