package GameAssets.EmbedDatas {
import mx.core.*;

[Embed(source="Player/PlayerPet.dat", mimeType="application/octet-stream")]
public class PlayerPet extends ByteArrayAsset {
    public function PlayerPet() {
        super();
    }
}
}