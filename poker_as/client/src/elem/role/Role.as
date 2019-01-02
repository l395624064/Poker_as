package client.src.elem.role {
import client.src.view.playerview.Playerview;
import client.src.view.playerview.PlayerviewOther;

import laya.display.Sprite;

import laya.maths.Point;

public class Role extends Sprite{
    private var _playerName:String;//名字
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

    private var _surplusCardNum:Number;//剩余手牌数量
    private var _profession:String;//职业
    private var _seatNum:Number;//座位号
    private var viewPanel:*;
    public function initview(ifself:Boolean=false):void
    {
        if(ifself) viewPanel||=new Playerview();
        else viewPanel||=new PlayerviewOther();
        this.addChild(viewPanel);
        if(_headImg) viewPanel.headImg.skin=_headImg;

        viewPanel.playerName.text=_playerName;
        viewPanel.scoreNum.text=_scoreNum+"";
        viewPanel.goldNum.text=_goldNum+"";
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
        if(viewPanel) viewPanel.profession.text=_profession+"";
    }
    public function get profession():String{
        return _profession;
    }
    public function set seatNum(value:Number):void{
        _seatNum=value;
        if(viewPanel) viewPanel.seatNum.text=_seatNum+"";
    }
    public function get seatNum():Number{
        return seatNum;
    }




    public var cardlist:Array=[];//手牌

    public var ifRobot:Boolean=false;//是否为电脑
    public var cardPoint:Point;//牌起始位置



    public function Role() {
    }





    //检出牌
    public function checkoutCards():void
    {

    }

    //检入牌
    public function checkInCard():void
    {

    }

    //跳过出牌
    public function passTurn():void
    {

    }

    //抢地主
    public function wantLandlord():void
    {

    }

    //加倍
    public function wantDoubleScore():void
    {

    }

    public function updateGold():void
    {

    }
    public function updateScore():void
    {

    }




}
}
