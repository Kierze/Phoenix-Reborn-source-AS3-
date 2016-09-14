/**
 * Created by Proph on 1/9/2016.
 */
package Panels
{
import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.InteractNPC;

public class InteractNPCPanel extends TextPanel
    {
        public var GS:GameSprite;
        public var npc:InteractNPC;
        private var panelName:String;
        private var panelButtonName:String;

        public function InteractNPCPanel(param1:GameSprite, param2:InteractNPC)
        {
            this.GS = param1;
            this.npc = param2;
            if (this.npc.named)
            {
                panelName = this.npc.CharName + ", " + this.npc.CharTitle;
                panelButtonName = "Talk";
            }
            else
            {
                panelName = "Unnamed NPC";
                panelButtonName = "~";
            }
            super(this.GS, panelName, panelButtonName);
        }

    }
}
