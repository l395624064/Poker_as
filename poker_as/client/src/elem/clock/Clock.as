package client.src.elem.clock {
import client.src.constant.GameEvent;
import client.src.manager.GameEventDisPatch;

import laya.display.Sprite;
import laya.display.Text;
import laya.maths.Point;
import laya.ui.Image;

public class Clock extends Sprite{

    private var _img:Image;
    private var _text:Text;
    private const maxTime:Number=15;
    private var nowTime:Number;
    private var _owner:*;//持有者
    private var _overEvent:String;
    public function Clock() {
        init();
    }

    public function init():void
    {
        _img||=new Image();
        _img.skin="view/common/clock.png";
        _img.size(110,120);
        _img.pos(-40,-5);

        _text||=new Text();
        _text.fontSize=30;
        _text.valign="middle";
        _text.size(110,120);
    }

    public function startTime(owner:*=null,overEvent:String=null):void
    {
        if(owner)_owner=owner;
        if(overEvent)_overEvent=overEvent;

        this.addChild(_img);
        this.addChild(_text);
        nowTime=maxTime;
        _text.text=nowTime+"";
        Laya.timer.loop(1000,this,onLoop);
    }

    private function onLoop():void
    {
        nowTime--;
        if(nowTime<0){
            overTime();
            if(_owner) overEvent();
        }
        _text.text=nowTime+"";
    }

    private function overEvent():void
    {
        if(_overEvent==GameEvent.PLAYER_ROUNDTIMEOVER_SINGLE){
            _owner.event(GameEvent.PLAYER_ROUNDTIMEOVER_SINGLE);
        }
        else if(_overEvent==GameEvent.PLAYER_LORDTIMEOVER_SINGLE){
            _owner.event(GameEvent.PLAYER_LORDTIMEOVER_SINGLE);
        }
        else if(_overEvent==GameEvent.PLAYER_ROBLORDTIMEOVER_SINGLE){
            _owner.event(GameEvent.PLAYER_ROBLORDTIMEOVER_SINGLE);
        }
        else if(_overEvent==GameEvent.PLAYER_ROBSCORETIMEOVER_SINGLE){
            _owner.event(GameEvent.PLAYER_ROBSCORETIMEOVER_SINGLE);
        }
    }


    public function overTime():void
    {
        _img.removeSelf();
        _text.removeSelf();
        nowTime=0;
        Laya.timer.clear(this,onLoop);
    }
}
}
