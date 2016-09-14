/**
 * Created by Fabian on 14.09.2015.
 */
package OptionsStuff {
import flash.display.Sprite;
import flash.errors.IllegalOperationError;

public class DialogOption extends Sprite {

    public var optionsKey:String;

    public function DialogOption(optionsKey:String) {
        this.optionsKey = optionsKey;
    }

    public function value():* {
        throw new IllegalOperationError("Override this method");
    }
}
}
