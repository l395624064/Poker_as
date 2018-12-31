package client.src.view.loadview {
import client.src.constant.GameEvent;
import client.src.manager.GameEventDisPatch;

import laya.events.Event;
import laya.net.Loader;
import laya.utils.Handler;

import ui.LoadviewUI;

public class Loadview extends LoadviewUI{
    private static var _instance:Loadview;
    public function Loadview() {
    }
    public static function get instance():Loadview
    {
        return _instance||=new Loadview();
    }


    private var _resArr:Array=[
        {url:"res/atlas/poker.atlas",              type:Loader.ATLAS},
        {url:"res/atlas/comp.atlas",               type:Loader.ATLAS},
        {url:"res/atlas/view/player.atlas",        type:Loader.ATLAS},

        {url:"sence/BG0.png",        type:Loader.IMAGE},
        {url:"sence/BG2.png",        type:Loader.IMAGE},
        {url:"sence/BG3.png",        type:Loader.IMAGE},
        {url:"sence/BG4.png",        type:Loader.IMAGE},
        {url:"sence/BG5.png",        type:Loader.IMAGE}
    ];

    public function openPanel():void
    {
        bar.width=0;

        startBtn.visible=false;
        startBtn.on(Event.MOUSE_DOWN,this,closePanel);

        Laya.loader.load(_resArr,Handler.create(this,loadCom),Handler.create(this,loadPro,null,false));
    }

    private function loadCom():void
    {
        startBtn.visible=true;
    }

    private const maxW:Number=360;
    private function loadPro(val:Number):void
    {
        bar.width=val*maxW;
    }

    private function closePanel():void
    {
        this.offAll();
        this.removeSelf();
        GameEventDisPatch.instance.event(GameEvent.GAME_LOBBY);
    }
}
}
