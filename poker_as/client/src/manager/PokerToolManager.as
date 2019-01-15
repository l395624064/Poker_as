package client.src.manager {
import client.src.constant.PokerConst;
import client.src.elem.card.Card;

import laya.utils.Browser;
import laya.utils.WeakObject;

public class PokerToolManager {
    private static var _instance:PokerToolManager;
    private var _pokerlist:Array=[];//牌库

    private var _splitlist:Array=[];//分堆
    public function get playerCardlist():Array{
        return _splitlist.shift();
    }

    private var _lordlist:Array=[];//地主牌
    public function get lordlist():Array{
        if(_lordlist && _lordlist.length==3) return _lordlist;
        throw new Error("PokerToolManager lordlist not found!");
    }


    public function PokerToolManager() {
    }
    public static function get instance():PokerToolManager{
        return _instance||=new PokerToolManager();
    }


    /*创建牌库*/
    public function createPokerslib():void
    {
        var color:String;
        var value:Number;
        var card:Card;
        //3-A
        for(var i:int=0;i<48;i++){
            if(i%4==0) color=PokerConst.COLOR_SPADE;
            else if(i%4==1) color=PokerConst.COLOR_HEART;
            else if(i%4==2) color=PokerConst.COLOR_CLUDS;
            else if(i%4==3) color=PokerConst.COLOR_DIANMOND;
            card=new Card();
            card.cardColor=color;
            card.cardValue=3+Math.floor(i/4);
            _pokerlist.push(card);
        }

        //2
        for(var k:int=0;k<4;k++){
            if(k%4==0) color=PokerConst.COLOR_SPADE;
            else if(k%4==1) color=PokerConst.COLOR_HEART;
            else if(k%4==2) color=PokerConst.COLOR_CLUDS;
            else if(k%4==3) color=PokerConst.COLOR_DIANMOND;
            card=new Card();
            card.cardColor=color;
            card.cardValue=PokerConst.CARD_TWO;
            _pokerlist.push(card);
        }

        //大小王
        card=new Card();
        card.cardColor=PokerConst.COLOR_NONE;
        card.cardValue=PokerConst.CARD_SJoker;
        _pokerlist.push(card);
        card=new Card();
        card.cardColor=PokerConst.COLOR_NONE;
        card.cardValue=PokerConst.CARD_BJoker;
        _pokerlist.push(card);

        _pokerlist=randomPokers(_pokerlist);
    }

    /*
    * 拆分成groupNum份,保留lastNum张数
    * */
    public function splitPokers(groupNum:Number=3,lastNum:Number=3):void
    {
        var list=_pokerlist;
        for(var k:int=0;k<groupNum;k++){
            var arr:Array=new Array();
            _splitlist.push(arr);
        }

        var maxNum:Number=list.length-lastNum;
        for(var i:int=0;i<maxNum;i+=groupNum){
            _splitlist[0].push(list[i]);
            _splitlist[1].push(list[i+1]);
            _splitlist[2].push(list[i+2]);
        }
        _lordlist.push(list[list.length-1]);
        _lordlist.push(list[list.length-2]);
        _lordlist.push(list[list.length-3]);

        console.log("-_lordlist:",_lordlist);
        console.log("-_splitlist:",_splitlist);
        sortPokers(_splitlist[0]);
        sortPokers(_splitlist[1]);
        sortPokers(_splitlist[2]);
    }


    /*
    * 牌型测试
    * */
    public function createPolersTest(numlist:Array):Array
    {
        var cardslist:Array=[];
        var card:Card;
        var value:Number;
        for(var i:int=0;i<numlist.length;i++){
            card=new Card();
            value=numlist[i];
            if(value==PokerConst.CARD_SJoker){
                card.cardColor=PokerConst.COLOR_NONE;
                card.cardValue=value;
            }
            else if(value==PokerConst.CARD_BJoker){
                card.cardColor=PokerConst.COLOR_NONE;
                card.cardValue=value;
            }else{
                card.cardColor=PokerConst.COLOR_HEART;
                card.cardValue=value;
            }
            cardslist.push(card);
        }
        return cardslist;
    }

    /*排序：小-大*/
    public function sortPokers(list:Array):void
    {
        list.sort(function (a,b):Number {
            return (a.cardValue>b.cardValue)? 1:-1;
        });
    }

    /*打乱*/
    public function randomPokers(list:Array):Array
    {
        const maxnum:Number=5000;
        var index:Number=0;
        var cardx:Card;
        for (var i:int=0;i<maxnum;i++){
            index=getRandomCard(list);
            cardx=list[index];
            list.splice(index,1);
            list.push(cardx);
        }
        return list;
    }

    //获取皮肤
    public function getCardSkin(cardValue:Number,cardColor:String):String
    {
        var skin:String;
        if(cardValue==PokerConst.CARD_BJoker){
            skin="poker/53.jpg";
            return skin;
        }else if(cardValue==PokerConst.CARD_SJoker){
            skin="poker/54.jpg";
            return skin;
        }else if(cardColor==PokerConst.COLOR_NONE && cardValue==PokerConst.CARD_NONE){
            skin="poker/CardBack.jpg";
            return skin;
        }


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

        var skinIndex:Number=(cardValue>PokerConst.CARD_A)? 48+colorIndex:4*(cardValue-3)+colorIndex;
        skin="poker/"+skinIndex+".jpg";

        return skin;
    }

    private function getRandomCard(list:Array):Number
    {
        return Math.max(0,Math.min(list.length-1,Math.floor(Math.random()*list.length)));
    }

    public function clearList():void
    {
        _pokerlist=[];
        _splitlist=[];
        _lordlist=[];
    }


}
}
