package client.src.elem.role {
import client.src.constant.GameEvent;
import client.src.elem.card.Card;
import client.src.manager.GameEventDisPatch;
import client.src.view.roomview.Roomview;

import laya.maths.Point;

public class Player extends Role{
    private var handPot:Point;
    public function Player() {

        init();
    }

    private function init():void
    {
        super.initData("玩家");
        super.initview(true);
        handPot=new Point(250,0);

        register();
    }

    override protected function onReady():void
    {
        Roomview.instance.showBtnPanel("ready");
    }

    override protected function wantLandlord():void
    {
        Roomview.instance.showBtnPanel("lord");
    }

    override protected function wantDoubleScore():void
    {
        Roomview.instance.showBtnPanel("double");
    }

    override public function set cardlist(value:Array):void{
        _cardlist=value;
        surplusCardNum=_cardlist.length;
        console.log(playerName,_cardlist);
    }

    public function showCardlist():void
    {
        if(_cardlist.length>0){
            updateCardlist();
        }
    }

    private function updateCardlist():void
    {
        var card:Card;
        const fixW:Number=40;
        var cardIndex:Number=0;
        for(var i:int=_cardlist.length-1;i>=0;i--){
            card=_cardlist[i];
            card.init();
            this.addChild(card);
            card.pos(handPot.x+cardIndex*fixW,handPot.y);
            cardIndex++;
        }
    }











    override protected function register():void
    {
        this.on(GameEvent.PLAYER_WANT_LORD_SINGLE,this,wantLandlord);
        this.on(GameEvent.PLAYER_WANT_DOUBLE_SINGLE,this,wantDoubleScore);
        this.on(GameEvent.PLAYER_READY_SINGLE,this,onReady);
    }

    override protected function unRegister():void
    {
        this.off(GameEvent.PLAYER_WANT_LORD_SINGLE,this,wantLandlord);
        this.off(GameEvent.PLAYER_WANT_DOUBLE_SINGLE,this,wantDoubleScore);
        this.off(GameEvent.PLAYER_READY_SINGLE,this,onReady);
    }

}
}
