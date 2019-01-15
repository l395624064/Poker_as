package client.src.elem.AI {
import client.src.elem.AI.AITools;
import client.src.model.DeskM;

import laya.events.EventDispatcher;

import laya.utils.Byte;

public class AIelem extends EventDispatcher{

    private var Tool:AITools;
    private var Decision:DecisionTree;
    private var Evaluate:AIEvaluate;
    private var model:AIModel;

    private var _cardlist:Array=[];
    public function set cardlist(arr:Array):void{
        _cardlist=arr;
        Tool._tempArr=this.cardlist;//初始化的手牌
        Tool.splitCards();
    }
    public function get cardlist():Array{
        return _cardlist;
    }


    public function AIelem() {
    }
    public function init():void{
        model||=new AIModel();//数据
        Evaluate||=new AIEvaluate();//价值
        Tool||=new AITools();//技巧
        Decision||=new DecisionTree();//策略

        Decision.deskM=DeskM.instance;
        Decision.model=model;
        Tool.model=model;
        register();
    }




    /*
    * 主动出牌，不可以PASS
    * */
    public function showCardSelf(deskObj:Object):void
    {
        var cardlist:Array=Decision.baseSelfDecision();


        //更新桌面牌数量
        //更新桌面牌类型
        //更新桌面牌权值



    }


    /*
    * 被动出牌-接牌，可以PASS
    * */
    public function showCardPassive():void
    {
        var deskObj={pokerType:"",pokerLength:0,deskpokerMax:0};
        deskObj.pokerType=DeskM.instance.deskPokerType;
        deskObj.pokerLength=DeskM.instance.deskPokerList.length;
        deskObj.deskpokerMax=DeskM.instance.deskHeadValue;
        var cardlist:Array=Decision.baseFollowDecision(deskObj);

        if(cardlist && cardlist.length>0){
            //出牌

            //更新桌面牌数量
            //更新桌面牌类型
            //更新桌面牌权值

        }else{
            //pass
        }
    }







    //抢地主
    public function robLord():void
    {
        //

    }



    /*
    * 打出手牌
    * */
    public function checkoutCard():void
    {

    }


    private function register():void
    {
        this.on(AIEvent.ShowCard_Passive,this,showCardPassive);//被动接牌
        this.on(AIEvent.ShowCard_Self,this,showCardSelf);//主动出牌


        this.on(AIEvent.UPDATE_GameTurn,this,updateGameTurn);//游戏轮数更新
        this.on(AIEvent.UPDATE_CardNum,this,setCardNum);//玩家手牌数更新
        this.on(AIEvent.PROFESSION,this,setProfession);
        this.on(AIEvent.SEATID,this,seatId);

        //this.on(AIEvent.CARD_Checkout,this,checkoutCard);
    }
    private function unRegister():void
    {

    }

    /*
    * 计算手牌分数
    * 叫地主:计算分值-是否叫地主
    * 被动出牌:计算分数-是否接牌-接牌-方案选择
    * */
    private function get cardsSum():Number
    {
        Tool.splitCards();//拆分

        var sum:Number=0;//牌组sum分值
        sum+=Evaluate.getSingleArrValue(model.Straight);
        sum+=Evaluate.getBoomArrValue(model.BoomArr);
        sum+=Evaluate.getAirplaneArrValue(model.AirplaneArr);
        sum+=Evaluate.getStraightArrValue(model.Straight);
        sum+=Evaluate.getDoubleStraightArrValue(model.DoubleStraight);
        sum+=Evaluate.getThreeArrValue(model.Three);
        sum+=Evaluate.getDoubleArrValue(model.Double);

        //model.GameTurns 忽略大牌得轮次
        return Evaluate.getHandCardValue(sum,model.GameTurns,model.handGroupNum);
    }

    public function updateGameTurn(turns:Number):void{
        model.GameTurns=turns;//忽略大牌得轮次
    }
    public function seatId(seatid:Number):void{
        model.seatId=seatid;//座位号
    }



    /*
    * seatId: 1 2 3
    * 剩余手牌
    * */
    public function setCardNum(cardArr:Array):void
    {
        if(model.seatId==1){
            model.handNum=cardArr[0];
            model.nextHandNum=cardArr[1];
            model.prevHandNum=cardArr[2];
        }
        else if(model.seatId==2){
            model.handNum=cardArr[1];
            model.nextHandNum=cardArr[2];
            model.prevHandNum=cardArr[0];
        }
        else if(model.seatId==3){
            model.handNum=cardArr[2];
            model.nextHandNum=cardArr[0];
            model.prevHandNum=cardArr[1];
        }
    }
    /*
    * seatId: 1 2 3
    * 职业
    * */
    public function setProfession(seatArr:Array):void
    {
        if(model.seatId==1){
            model.profession=seatArr[0];
            model.nextProfession=seatArr[1];
            model.prevProfession=seatArr[2];
        }
        else if(model.seatId==2){
            model.profession=seatArr[1];
            model.nextProfession=seatArr[2];
            model.prevProfession=seatArr[0];
        }
        else if(model.seatId==3){
            model.profession=seatArr[2];
            model.nextProfession=seatArr[0];
            model.prevProfession=seatArr[1];
        }
    }



}
}
