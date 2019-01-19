package client.src.view.roomview {
import client.src.constant.GameEvent;
import client.src.constant.GlobalConfig;
import client.src.constant.GlobalConfig;
import client.src.elem.AI.AIelem;
import client.src.elem.card.Card;
import client.src.elem.role.Player;
import client.src.elem.role.Robot;
import client.src.elem.role.Role;
import client.src.manager.GameEventDisPatch;
import client.src.manager.PokerToolManager;
import client.src.model.DeskM;

import laya.events.Event;
import laya.ui.Image;
import laya.utils.Pool;

import ui.GameviewUI;

public class Roomview extends GameviewUI{
    private static var _instance:Roomview;
    private var _player:*;

    public function Roomview() {
        register();
    }
    public static function get instance():Roomview
    {
        return _instance||=new Roomview();
    }

    public function openPanel():void
    {
        initData();
        initView();
    }

    private function initData():void
    {
        GameEventDisPatch.instance.event(GameEvent.DeskInit_SINGLE);//初始化牌桌
    }


    private function initView():void
    {
        if(GlobalConfig.SingleGame){
            var robotA:Robot=new Robot();
            robotA.setClock(50);
            robotA.pos(50,100);

            var robotB:Robot=new Robot();
            robotB.setClock(1000);
            robotB.pos(1000,100);

            //_player=new Robot();//robot test
            //_player.setClock(50);
            _player=new Player();
            _player.pos(50,400);

            //单机直接获取牌和座位号
            robotA.cardlist=[];
            _player.cardlist=[];
            robotB.cardlist=[];
            robotA.seatNum=DeskM.instance.seatId;
            _player.seatNum=DeskM.instance.seatId;
            robotB.seatNum=DeskM.instance.seatId;

            this.addChild(robotA);
            this.addChild(robotB);
            this.addChild(_player);
            DeskM.instance.playerList=sortRolelist([robotA,_player,robotB]);
            DeskM.instance.Player=_player;

            GameEventDisPatch.instance.event(GameEvent.BroadCast_Ready_SINGLE);//准备事件
        }else{


        }
    }

    private function sortRolelist(arr:Array):Array
    {
        arr.sort(function (a,b):Number {
            return (a.seatNum<b.seatNum)? -1:1;
        });
        return arr;
    }

    private function showLordCard():void
    {
        var lordcard:Image;
        var card:Card;
        for(var i:int=1;i<4;i++){
            lordcard=lordcard_box.getChildByName("lordcard_"+i) as Image;
            card=DeskM.instance.landlordCards[i-1];
            lordcard.skin=PokerToolManager.instance.getCardSkin(card.cardValue,card.cardColor);
            lordcard.size(66,88);
        }
    }


    private function showDeskCard():void
    {
        var deskCards:Array=DeskM.instance.deskPokerList;
        var card:Card;
        const dw:Number=20;
        const dy:Number=150;
        const dx:Number=Math.floor((GlobalConfig.GlobalW-deskCards.length*dw)/2);

        for(var i:int=0;i<deskCards.length;i++){
            card=deskCards[i];
            card.showCard();
            card.pos(dx+dw*i,dy);
            this.addChild(card);
        }
    }




    private function creatPlayerview(res):void
    {

    }







    public function register():void
    {
        GameEventDisPatch.instance.on(GameEvent.PLAYER_LOGINROOM_NET,this,creatPlayerview);
        GameEventDisPatch.instance.on(GameEvent.DESK_LORDCARD_SINGLE,this,showLordCard);

        GameEventDisPatch.instance.on(GameEvent.DESK_SHOWCARD_SINGLE,this,showDeskCard);
    }
    public function unRegister():void
    {
        GameEventDisPatch.instance.off(GameEvent.PLAYER_LOGINROOM_NET,this,creatPlayerview);
        GameEventDisPatch.instance.off(GameEvent.DESK_LORDCARD_SINGLE,this,showLordCard);
    }
    public function closePanel():void
    {

    }
}
}
