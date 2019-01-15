package client.src.elem.role {
import client.src.elem.card.Card;
import client.src.manager.PokerToolManager;
import client.src.view.playerview.Playerview;
import client.src.view.playerview.PlayerviewOther;

import laya.display.Sprite;

import laya.maths.Point;

public class Role extends Sprite{
    private var _playerName:String;//名字
    public function get playerName():String{
        return _playerName;
    }
    private var _headImg:String;//头像
    private var _scoreNum:Number;//分数
    private var _goldNum:Number;//金币
    public function initData(name:String=null,scoreNum:Number=0,goldNum:Number=0,headImg:String=null):void
    {
        if(!name) _playerName="Robot";
        else _playerName=name;
        if(!headImg)_headImg="view/player/ico1.png";
        else _headImg=headImg;
        if(scoreNum==0) _scoreNum=100;
        else _scoreNum=scoreNum;
        if(goldNum==0) _goldNum=1000;
        else _goldNum=goldNum;
    }

    private var _surplusCardNum:Number;//剩余
    private var _profession:String;//职业
    private var _seatNum:Number;//座号
    private var _ifself:Boolean=false;//玩家操控
    private var viewPanel:*;
    public function initview(ifself:Boolean=false):void
    {
        _ifself=ifself;
        if(_ifself) viewPanel||=new Playerview();
        else viewPanel||=new PlayerviewOther();
        this.addChild(viewPanel);
        if(_headImg) viewPanel.headImg.skin=_headImg;

        viewPanel.playerName.text=_playerName;
        viewPanel.scoreNum.text=_scoreNum+"";
        viewPanel.goldNum.text=_goldNum+"";
    }

    private var _state:String="";//状态
    public function set state(value:String):void{
        _state=value;
        if(_state=="onReady") viewPanel.stateStr.text="准备就绪";
        else if(_state=="robLord") viewPanel.stateStr.text="抢地主";
        else if(_state=="cancelLord") viewPanel.stateStr.text="不抢地主";
        else if(_state=="robDouble") viewPanel.stateStr.text="加倍";
        else if(_state=="cancelDouble") viewPanel.stateStr.text="不加倍";
        else if(_state=="showCard") viewPanel.stateStr.text="出牌";
        else if(_state=="pass") viewPanel.stateStr.text="要不起";
    }
    public function get state():String{
        return _state;
    }


    public function set surplusCardNum(value:Number):void{
        _surplusCardNum=value;
        if(viewPanel) viewPanel.surplusCardNum.text=_surplusCardNum+"";
    }
    public function get surplusCardNum():Number{
        return _surplusCardNum;
    }
    public function set profession(value:String):void{
        _profession=value;
        if(viewPanel){
            viewPanel.profession.text=_profession+"";
            viewPanel.stateStr.text="等待出牌";
        }
    }
    public function get profession():String{
        return _profession;
    }
    public function set seatNum(value:Number):void{
        _seatNum=value;
        if(viewPanel) viewPanel.seatNum.text=_seatNum+"";
    }
    public function get seatNum():Number{
        return _seatNum;
    }





    protected var _cardlist:Array=[];//手牌
    public function get cardlist():Array{
        return _cardlist;
    }
    public function set cardlist(value:Array):void{
        _cardlist=value;
        surplusCardNum=_cardlist.length;
        console.log(playerName,_cardlist);
    }

    public var ifRobot:Boolean=false;//是否为电脑
    public var cardPoint:Point;//牌起始位置



    public function Role() {
    }



    protected function onReady():void{}//准备
    protected function checkoutCards():void{}//检出牌
    public function checkInCard(card:*):void{
        //检入牌
        if(card is Array){
            for(var i:int=0;i<card.length;i++){
                _cardlist.push(card[i]);
            }
        }else if(card is Card){
            _cardlist.push(card);
        }
        PokerToolManager.instance.sortPokers(_cardlist);
        surplusCardNum=_cardlist.length;
    }
    protected function passTurn():void{}//跳过出牌
    protected function wantLandlord():void{}//抢地主
    protected function wantDoubleScore():void{}//加倍

    protected function register():void{}
    protected function unRegister():void{}
    protected function destroy():void{
        this.unRegister();
        this.removeSelf();
    }


    protected function updateGold():void{}
    protected function updateScore():void{}




}
}
