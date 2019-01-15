package client.src.control {
import client.src.constant.GameEvent;
import client.src.constant.GlobalConfig;
import client.src.constant.PokerConst;
import client.src.constant.RoleConst;
import client.src.elem.card.Card;
import client.src.elem.role.Role;
import client.src.manager.GameEventDisPatch;
import client.src.manager.RulersManager;
import client.src.view.loadview.Loadview;
import client.src.view.lobbyview.Lobbyview;
import client.src.view.roomview.Roomview;

import laya.net.Loader;
import laya.utils.Handler;

public class GameMainC {
    private static var _instance:GameMainC;
    public function GameMainC() {
        GameEventDisPatch.instance.on(GameEvent.GAME_LOAD,this,gameLoad);
        GameEventDisPatch.instance.on(GameEvent.GAME_LOBBY,this,gameLobby);
        GameEventDisPatch.instance.on(GameEvent.ENTER_ROOM,this,enterRoom);
    }

    public static function get instance():GameMainC
    {
        return _instance||=new GameMainC();
    }

    private function gameLoad():void
    {
        var loadviewRes:Array=[
            {url:"res/atlas/view/load.atlas",   type:Loader.ATLAS},
            {url:"sence/BG1.png",   type:Loader.IMAGE}
        ];
        Laya.loader.load(loadviewRes,Handler.create(this,function () {
            Laya.stage.addChild(Loadview.instance);
            Loadview.instance.openPanel();
        }));

        //
    }

    private function gameLobby():void
    {
        Laya.stage.addChild(Lobbyview.instance);
        Lobbyview.instance.openPanel();
    }

    private function enterRoom():void
    {
        Laya.stage.addChild(Roomview.instance);
        Roomview.instance.openPanel();
    }





}
}
