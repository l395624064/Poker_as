package client.src.elem.card {
import client.src.constant.PokerConst;

import laya.display.Sprite;
import laya.events.Event;
import laya.ui.Image;

public class Card extends Sprite{
    public var cardImg:Image;
    public var cardColor:String;
    public var cardValue:Number;
    public var cardSelect:Boolean=false;

    private var cardIndex:Number;
    private var cardPosX:Number;
    private var cardPosY:Number;

    public function Card() {
    }

    public function init(color:String,value:Number):void
    {
        cardColor=color;
        cardValue=value;
        cardImg||=new Image();

        initSkin();
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
            this.y-=20;
        }
    }


    private function initSkin():void
    {
        if(cardValue=PokerConst.CARD_BJoker){
            cardImg.skin="poker/53.png";
        }else if(cardValue=PokerConst.CARD_SJoker){
            cardImg.skin="poker/54.png";
        }else if(cardColor==PokerConst.COLOR_NONE && cardValue==PokerConst.CARD_NONE){
            cardImg.skin="poker/CardBack.png";
        }
        return;

        //红 黑 梅 方
        var colorIndex:Number;
        if(cardColor==PokerConst.COLOR_HEART){
            colorIndex=1;
        }else if(cardColor==PokerConst.COLOR_SPADE){
            colorIndex=2;
        }else if(cardColor==PokerConst.COLOR_CLUDS){
            colorIndex=3;
        }
        else if(cardColor==PokerConst.COLOR_DIANMOND){
            colorIndex=4;
        }

        var skinIndex:Number=(cardValue>PokerConst.CARD_A)? 4*(cardValue-3)+colorIndex:48+colorIndex;
        cardImg.skin="poker/"+skinIndex+".png";
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
