package client.src.manager {
import client.src.constant.PokerConst;
import client.src.elem.card.Card;
import client.src.model.DeskM;

public class RulersManager {
    private static var _instance:RulersManager;
    public function RulersManager() {
    }
    public static function get instance():RulersManager
    {
        return _instance||=new RulersManager();
    }


    /*
    * 能否出牌
    * 牌型 && 牌值Array<number>
    * */
    public function canTakeoutCard(cards:Array):Boolean
    {
        var handType:String=getCardsType(cards);
        var deskType:String=DeskM.instance.deskPokerType;

        //桌面王炸
        if(deskType ==PokerConst.TYPE_JokerBoom){
            return false;
        }
        //手上王炸
        if(handType ==PokerConst.TYPE_JokerBoom){
            return true;
        }
        //手上炸弹 桌上其他牌型
        if(handType==PokerConst.TYPE_Boom && deskType!=PokerConst.TYPE_Boom){
            return true;
        }

        //牌型匹配
        if(handType!=deskType && deskType!=PokerConst.TYPE_NONE){
            console.log("-pokertype not conform");
            return false;
        }
        //牌权值比较
        if(getCardsHeadvalue(cards,handType)<=DeskM.instance.deskHeadValue){
            console.log("-pokerHeadvalue not conform");
            return false;
        }

        return true;
    }


    public function getCardsHeadvalue(cards:Array,type:String):Number
    {
        var headCard:Card;
        if(type==PokerConst.TYPE_ThreeAndOne || type==PokerConst.TYPE_ThreeAndTwo){
            headCard=cards[2];//三带一  三带二
        }
        else if(type==PokerConst.TYPE_Airplane){
            headCard=calcHeadvalueFromGroup(cards,3);//飞机
        }else{
            headCard=cards[0];
        }

        return headCard.cardValue;
    }


    //牌型检测
    public function getCardsType(cards:Array):String
    {
        var leng:Number=cards.length;
        switch (leng){
            case 1:return PokerConst.TYPE_Single;
            case 2:{
                if(IsDouble(cards)) return PokerConst.TYPE_Double;
                else if(IsJokerBoom(cards)) return PokerConst.TYPE_JokerBoom;
            }
            case 3:{
                if(IsThree(cards)) return PokerConst.TYPE_Three;
            }
            case 4:{
                if(IsBoom(cards)) return PokerConst.TYPE_Boom;
                else if(IsThreeAndOne(cards)) return PokerConst.TYPE_ThreeAndOne;
            }
            case 5:{
                if(IsStraight(cards)) return PokerConst.TYPE_Straight;
                else if(IsThreeAndTwo(cards)) return PokerConst.TYPE_ThreeAndTwo;
            }
            case 6:{
                if(IsStraight(cards)) return PokerConst.TYPE_Straight;
                else if(IsDoubleStraight(cards)) return PokerConst.TYPE_DoubleStraight;
                else if(IsThreeStraight(cards)) return PokerConst.TYPE_ThreeStraight;
            }
            case 7:{
                if(IsStraight(cards)) return PokerConst.TYPE_Straight;
            }
            case 8:{
                if(IsStraight(cards)) return PokerConst.TYPE_Straight;
                else if(IsDoubleStraight(cards)) return PokerConst.TYPE_DoubleStraight;
                else if(IsAirplane(cards)) return PokerConst.TYPE_Airplane;
            }
            case 9:{
                if(IsStraight(cards)) return PokerConst.TYPE_Straight;
                else if(IsThreeStraight(cards)) return PokerConst.TYPE_ThreeStraight;
            }
            case 10:{
                if(IsStraight(cards)) return PokerConst.TYPE_Straight;
                else if(IsDoubleStraight(cards)) return PokerConst.TYPE_DoubleStraight;
            }
            case 11:{
                if(IsStraight(cards)) return PokerConst.TYPE_Straight;
            }
            case 12:{
                if(IsStraight(cards)) return PokerConst.TYPE_Straight;
                else if(IsDoubleStraight(cards)) return PokerConst.TYPE_DoubleStraight;
                else if(IsThreeStraight(cards)) return PokerConst.TYPE_ThreeStraight;
            }
            case 13:{
                return PokerConst.TYPE_NONE;
            }
            case 14:{
                if(IsDoubleStraight(cards)) return PokerConst.TYPE_DoubleStraight;
            }
            case 15:{
                if(IsThreeStraight(cards)) return PokerConst.TYPE_ThreeStraight;
            }
            case 16:{
                if(IsDoubleStraight(cards)) return PokerConst.TYPE_DoubleStraight;
            }
            case 17:{
                return PokerConst.TYPE_NONE;
            }
            case 18:{
                if(IsDoubleStraight(cards)) return PokerConst.TYPE_DoubleStraight;
                else if(IsThreeStraight(cards)) return PokerConst.TYPE_ThreeStraight;
            }
            case 19:{
                return PokerConst.TYPE_NONE;
            }
            case 20:{
                if(IsDoubleStraight(cards)) return PokerConst.TYPE_DoubleStraight;
            }
            default:{
                return PokerConst.TYPE_NONE;
            }
        }
    }




    private function checkHead(value:Number):Boolean{
        if(value < PokerConst.CARD_three) return false;
        return true;
    }
    private function checkTail(value:Number):Boolean{
        if(value > PokerConst.CARD_A) return false;
        return true;
    }
    /*
    * 是否包含num组的连对//33 44 55 66
    *布尔值检测首组值>=3,检测尾组值<=A
    * */
    public function calcTwoGroupCards(cards:Array,maxNum:Number,checkhead:Boolean=false,checktail:Boolean=false,maxleng:Number=2):Boolean
    {
        const maxlength:Number=maxleng;
        var grouplist:Array=[];
        var excludelist:Array=[];
        var card:Card;
        var objc:Object;
        var nowValue:Number=0;
        for(var i:int=0;i<cards.length;i++){
            card=cards[i];
            if(nowValue !=card.cardValue){
                nowValue=card.cardValue;
                var obj={value:nowValue,num:1};
                excludelist.push(obj);
            }else{
                objc=excludelist[excludelist.length-1];
                if(objc){
                    objc.num++;
                    if(objc.num==maxlength){
                        excludelist.splice(excludelist.length-1,1);
                        grouplist.push(objc);
                    }
                }else{
                    objc={value:nowValue,num:1};
                    excludelist.push(objc);
                }
            }
        }
        console.log("grouplist:",grouplist);

        if(checkhead && !checkHead(grouplist[0].value)) return false;
        if(checktail && !checkTail(grouplist[grouplist.length-1].value)) return false;
        if(grouplist.length != maxNum) return false;

        for(var k:int=0;k<grouplist.length-1;k++){
            if(grouplist[k].value+1 != grouplist[k+1].value){
                return false;
            }
        }
        return true;
    }

    /*
    * 是否包含num组的三连//333 444 555
    * */
    public function calcThreeGroupCards(cards:Array,maxNum:Number,checkhead:Boolean=false,checktail:Boolean=false):Boolean
    {
        var bo:Boolean=calcTwoGroupCards(cards,maxNum,checkhead,checktail,3);
        return bo;
    }

    public function checkHasCard(cards:Array,value:Number,color:String=null):Boolean
    {
        for(var i:int=0;i<cards.length;i++){
            if(value && value==cards[i].cardValue){
                if(!color) return true;
                else if(color && color==cards[i].cardColor) return true;
            }
        }
        return false;
    }

    /*
    * 相同牌值的最大数量
    * */
    public function calcMaxSameCardNum(cards:Array):Number
    {
        var maxNum:Number=1;
        var nowNum:Number=1;
        for(var i:int=0;i<cards.length-1;i++){
            if(cards[i].cardValue==cards[i+1].cardValue){
                nowNum++;
                if(nowNum>maxNum){
                    maxNum=nowNum;
                }
            }else{
                nowNum=1;
            }
        }
        return maxNum;
    }


    /*
    * 不同牌值的数量*/
    public function calcDiffCardNum(cards:Array):Number
    {
        var difNum:Number=1;
        for(var i:int=0;i<cards.length-1;i++){
            if(cards[i].cardValue!=cards[i+1].cardValue){
                difNum++;
            }
        }
        return difNum;
    }

    /*
    * 返回第一次出现num次得牌
    * */
    public function calcHeadvalueFromGroup(cards:Array,num:Number):Card
    {
        var nowNum:Number=1;
        for(var i:int=0;i<cards.length-1;i++){
            if(cards[i].cardValue==cards[i+1].cardValue){
                nowNum++;
                if(nowNum==num){
                    return cards[i];
                }
            }
        }
        throw new Error("calcHeadvalueFromGroup group undefiend");
    }

    //单
    public function IsSingle(cards:Array):Boolean
    {
        if(cards.length==1) return true;
        return false;
    }

    //对子
    public function IsDouble(cards:Array):Boolean
    {
        if(cards.length==2 && calcMaxSameCardNum(cards)==2){
            return true;
        }
        return false;
    }

    //三不带
    public function IsThree(cards:Array):Boolean
    {
        if(cards.length==3 && calcMaxSameCardNum(cards)==3){
            return true;
        }
        return false;
    }

    //三带一
    public function IsThreeAndOne(cards:Array):Boolean
    {
        if(cards.length==4 && calcMaxSameCardNum(cards)==3 && calcDiffCardNum(cards)==2){
            return true;
        }
        return false;
    }

    //三带二
    public function IsThreeAndTwo(cards:Array):Boolean
    {
        if(cards.length==5 && calcMaxSameCardNum(cards)==3 && calcDiffCardNum(cards)==2){
            return true;
        }
        return false;
    }

    //三连
    public function IsThreeStraight(cards:Array):Boolean
    {
        if(cards.length>=6 && cards.length%3==0){
            var groupNum:int=cards.length/3;
            if(calcThreeGroupCards(cards,groupNum,true,true)) return true;
        }
        return false;
    }

    //飞机
    public function IsAirplane(cards:Array):Boolean
    {
        if(cards.length==8){
            if(calcThreeGroupCards(cards,2,true,true)) return true;
        }
        return false;
    }

    //连对
    public function IsDoubleStraight(cards:Array):Boolean
    {
        if(cards.length>=6 && cards.length%2==0){
            var groupNum:int=cards.length/2;
            if(calcTwoGroupCards(cards,groupNum,true,true)) return true;
        }
        return false;
    }

    //顺子
    public function IsStraight(cards:Array):Boolean
    {
        if(cards.length>=4 && cards.length<=12){
            if(checkHead(cards[0].cardValue) && checkTail(cards[cards.length-1].cardValue)){
                for(var i:int=0;i<cards.length-1;i++){
                    if(cards[i].cardValue!=cards[i+1].cardValue-1){
                        return false;
                    }
                }
                return true;
            }
        }
        return false;
    }

    //炸弹
    public function IsBoom(cards:Array):Boolean
    {
        if(cards.length==4 && calcMaxSameCardNum(cards)==4) return true;
        return false;
    }

    //王炸
    public function IsJokerBoom(cards:Array):Boolean
    {
        if(cards.length==2 && checkHasCard(cards,30) && checkHasCard(cards,40)) return true;
        return false;
    }



}
}
