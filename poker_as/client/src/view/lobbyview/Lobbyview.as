package client.src.view.lobbyview {
import client.src.constant.GameEvent;
import client.src.manager.GameEventDisPatch;

import laya.events.Event;

import ui.GamelobbyUI;

public class Lobbyview extends GamelobbyUI{
    private static var _instance:Lobbyview;
    public function Lobbyview(){
    }
    public static function get instance():Lobbyview
    {
        return _instance||=new Lobbyview();
    }

    public function openPanel():void
    {
        singleGame_btn.on(Event.MOUSE_DOWN,this,enterlocalGame);



    }

    private function enterlocalGame():void
    {
        closePanel();
        GameEventDisPatch.instance.event(GameEvent.ENTER_ROOM);
    }

    public function closePanel():void
    {
        this.removeSelf();
        this.offAll();
    }
}
}
