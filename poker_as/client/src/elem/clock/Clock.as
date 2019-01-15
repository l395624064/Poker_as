package client.src.elem.clock {
import client.src.constant.GameEvent;
import client.src.manager.GameEventDisPatch;

import laya.display.Sprite;
import laya.display.Text;
import laya.maths.Point;
import laya.ui.Image;

public class Clock extends Sprite{

    private var _img:Image;
    private var text:Text;
    private const maxTime:Number=30;
    private var nowTime:Number;
    public function Clock() {
    }

    public function init(url:String,pot:Point):void
    {
        _img||=new Image();
        _img.skin="common/clock.png";
        _img.size(110,120);
        this.addChild(_img);

        text||=new Text();
        text.fontSize=30;
        text.valign="middle";
        text.size(110,120);
        this.addChild(text);

        this.pos(pot.x,pot.y);
    }

    public function startTime():void
    {
        nowTime=maxTime;
        text.text=nowTime+"";
        Laya.timer.loop(1000,this,onLoop);
    }

    private function onLoop():void
    {
        nowTime--;
        if(nowTime<0){
            overTime();
        }
        text.text=nowTime+"";
    }

    private function overTime():void
    {
        nowTime=0;
        Laya.timer.clear(this,onLoop);
        GameEventDisPatch.instance.event(GameEvent.ROUND_TIME_OVER);
    }
}
}
