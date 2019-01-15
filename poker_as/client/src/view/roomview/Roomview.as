package client.src.view.roomview {
import client.src.constant.GameEvent;
import client.src.constant.GlobalConfig;
import client.src.elem.card.Card;
import client.src.elem.role.Player;
import client.src.elem.role.Robot;
import client.src.elem.role.Role;
import client.src.manager.GameEventDisPatch;
import client.src.manager.PokerToolManager;
import client.src.model.DeskM;

import laya.events.Event;
import laya.ui.Image;

import ui.GameviewUI;

public class Roomview extends GameviewUI{
    private static var _instance:Roomview;
    private var _roleList:Array=[];
    public function get roleList():Array{
        return _roleList;
    }
    private var _player:Player;
    public function get player():Player{
        return _player;
    }

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
        initEvent();
    }

    private function initData():void
    {
        if(GlobalConfig.SingleGame){
            PokerToolManager.instance.createPokerslib();
            PokerToolManager.instance.splitPokers();

            GameEventDisPatch.instance.event(GameEvent.DeskInit_SINGLE);
        }
    }

    private function initView():void
    {
        if(GlobalConfig.SingleGame){
            var robotA:Robot=new Robot();
            robotA.pos(50,100);

            var robotB:Robot=new Robot();
            robotB.pos(1000,100);

            _player=new Player();
            _player.pos(50,500);

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
            _roleList=[robotA,_player,robotB];
            sortRolelist();

            showBtnPanel("");

            GameEventDisPatch.instance.event(GameEvent.BroadCast_Ready_SINGLE,"ready");//准备事件
        }else{


        }
    }

    private function sortRolelist():void
    {
        _roleList.sort(function (a,b):Number {
            return (a.seatNum<b.seatNum)? -1:1;
        });
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




    private function creatPlayerview(res):void
    {
        //玩家加入房间,添加 view面板，从S端获得座位号等信息

    }

    private function initEvent():void
    {
        ready_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
            if(GlobalConfig.SingleGame){
                player.state="onReady";
                console.log(player.playerName,player.seatNum,player.state);
                GameEventDisPatch.instance.event(GameEvent.READY_OVER_SINGLE);
            }else{
            }
        });
        cancellord_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
            if(GlobalConfig.SingleGame){
                player.state="cancelLord";
                GameEventDisPatch.instance.event(GameEvent.ROBLORD_OVER_SINGLE);
            }else {
            }
        });
        wantlord_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
            if(GlobalConfig.SingleGame){
                player.state="robLord";
                console.log(player.playerName,player.seatNum,player.state);
                GameEventDisPatch.instance.event(GameEvent.ROBLORD_OVER_SINGLE,player.seatNum);
            }else {
            }
        });

        wantdouble_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
            if(GlobalConfig.SingleGame){
                player.state="robDouble";
                GameEventDisPatch.instance.event(GameEvent.ROBDOUBLE_OVER_SINGLE);
            }

        });
        canceldouble_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
            if(GlobalConfig.SingleGame){
                player.state="cancelDouble";
                GameEventDisPatch.instance.event(GameEvent.ROBDOUBLE_OVER_SINGLE);
            }
        });


        showCard_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
        });
        pass_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
        });
    }


    public function showBtnPanel(event:String):void
    {
        btnBox.visible=true;
        this.ready_btn.visible=false;
        this.cancellord_btn.visible=false;
        this.wantlord_btn.visible=false;
        this.wantdouble_btn.visible=false;
        this.canceldouble_btn.visible=false;
        this.showCard_btn.visible=false;
        this.pass_btn.visible=false;
        if(event=="ready"){
            this.ready_btn.visible=true;
        }else if(event=="lord"){
            this.cancellord_btn.visible=true;
            this.wantlord_btn.visible=true;
        }else if(event=="double"){
            this.wantdouble_btn.visible=true;
            this.canceldouble_btn.visible=true;
        }else if(event=="round"){
            this.showCard_btn.visible=true;
            this.pass_btn.visible=true;
        }
    }






    public function register():void
    {
        GameEventDisPatch.instance.on(GameEvent.PLAYER_LOGINROOM_NET,this,creatPlayerview);
        GameEventDisPatch.instance.on(GameEvent.DESK_LORDCARD_SINGLE,this,showLordCard);
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
