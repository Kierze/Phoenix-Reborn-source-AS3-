/**
 * Created by Thelzar on 6/18/2014.
 */
package com.company.util
{
import _vf.MusicHandler;
import _vf._str434;

public class ReloadMainMusicTheme implements _str434
    {
        public function load():void
        {
            MusicHandler.reload("MainTheme");
        }
    }
}
