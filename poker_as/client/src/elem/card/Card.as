package client.src.elem.card {
import client.src.constant.PokerConst;
import client.src.manager.PokerToolManager;

import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Image;

public class Card extends Sprite{
    public var cardImg:Image;
    public var cardColor:String;
    public var cardValue:Number;
    public var cardSelect:Boolean=false;

    private var cardIndex:Number;//牌组位置
    private var cardPosX:Number;
    private var cardPosY:Number;

    public function Card() {
    }

    public function init():void
    {
        if(!cardColor && !cardValue){
            throw new Error("card value undefined");
        }
        cardImg||=new Image();
        cardImg.skin=PokerToolManager.instance.getCardSkin(cardValue,cardColor);
        this.addChild(cardImg);
        initEvent();
    }

    private function initEvent():void
    {
        cardImg.on(Event.MOUSE_DOWN,this,chooseCard);
    }
    private function chooseCard():void
    {
        cardSelect=!cardSelect;
        if(cardSelect){
            this.y-=20;
        }else{
            this.y+=20;
        }
    }

    public function updateIndex(index:Number):void
    {
        cardIndex=index;
    }
    public function updatePos(dx:Number,dy:Number):void
    {
        cardPosX=dx;
        cardPosY=dy;
    }



}
}
