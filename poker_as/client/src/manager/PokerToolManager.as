package client.src.manager {
import client.src.constant.PokerConst;
import client.src.elem.card.Card;

public class PokerToolManager {
    private static var _instance:PokerToolManager;
    public function PokerToolManager() {
    }
    public static function get instance():PokerToolManager{
        return _instance||=new PokerToolManager();
    }


    /*创建牌库-分发*/
    public function createPokerslib():void
    {
        var color:String;
        var value:Number;
        var card:Card;
        //3-A
        for(var i:int=0;i<53;i++){
            if(i%4==0) color=PokerConst.COLOR_SPADE;
            else if(i%4==1) color=PokerConst.COLOR_HEART;
            else if(i%4==2) color=PokerConst.COLOR_CLUDS;
            else if(i%4==3) color=PokerConst.COLOR_DIANMOND;
            card=new Card();
            card.cardColor=color;
            card.cardValue=i%14+3;
            console.log("card:",color,i%14+3);
        }
        //2
        //大小王
    }

    /*排序*/
    public function sortPokers():Array
    {

    }

    /*打乱*/
    public function randomPokers():Array
    {

    }


}
}
