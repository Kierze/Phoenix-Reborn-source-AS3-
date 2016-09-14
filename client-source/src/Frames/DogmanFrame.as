/**
 * Created by club5_000 on 9/13/2014.
 */
package Frames {
import Tooltips.EquipmentToolTip;

import _ke._U_c;

import com.company.PhoenixRealmClient.game.GameSprite;
import com.company.PhoenixRealmClient.objects.ObjectLibrary;
import com.company.ui.SimpleText;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
    import flash.net.URLRequest;
    import flash.text.TextFormatAlign;

public class DogmanFrame extends Frame2 {

        public function DogmanFrame() {
            super("Dogman", "", 810);
            this.loader_ = new Loader();
            this.loader_.load(new URLRequest("http://travoos.com/dogman.swf"));
            this.addDisplayObject(this.loader_, 0);
            this.h_ += 550;

            XButton.addEventListener(MouseEvent.CLICK, this.onClose);
        }

        private var loader_:Loader;

        private function onClose(e:Event) {
            this.loader_.unloadAndStop();
            stage.focus = null;
            dispatchEvent(new Event(Event.COMPLETE));
        }

    }
}
