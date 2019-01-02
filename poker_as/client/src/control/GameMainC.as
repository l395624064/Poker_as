package client.src.control {
import client.src.constant.GameEvent;
import client.src.constant.PokerConst;
import client.src.elem.card.Card;
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

        pokerTest();
    }

    private function pokerTest():void
    {
        var carda:Card=new Card();
        carda.cardValue=PokerConst.CARD_three;
        var cardb:Card=new Card();
        cardb.cardValue=PokerConst.CARD_three;

        var cardc:Card=new Card();
        cardc.cardValue=PokerConst.CARD_four;
        var cardd:Card=new Card();
        cardd.cardValue=PokerConst.CARD_four;

        var carde:Card=new Card();
        carde.cardValue=PokerConst.CARD_three;
        var cardf:Card=new Card();
        cardf.cardValue=PokerConst.CARD_four;

        var cardh:Card=new Card();
        cardh.cardValue=PokerConst.CARD_five;

        var cardlist:Array=[carda,cardb,carde,cardc,cardd,cardf,cardh];
        var bo:Boolean=RulersManager.instance.calcThreeGroupCards(cardlist,2,true,true);
        console.log("-bo:",bo);
    }


}
}
