package GameAssets.EmbedDatas {
import mx.core.*;

[Embed(source="Player/PlayerClass.dat", mimeType="application/octet-stream")]
public class PlayerClass extends ByteArrayAsset {
    public function PlayerClass() {
        super();
    }
}
}