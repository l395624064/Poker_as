package client.src.view.roomview {
import client.src.constant.GameEvent;
import client.src.constant.GlobalConfig;
import client.src.elem.role.Role;
import client.src.manager.GameEventDisPatch;
import client.src.manager.PokerToolManager;

import laya.events.Event;

import ui.GameviewUI;

public class Roomview extends GameviewUI{
    private static var _instance:Roomview;


    public function Roomview() {
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
            GameEventDisPatch.instance.event(GameEvent.DeskInit_SINGLE);
            PokerToolManager.instance.createPokerslib();
        }
    }

    private function initView():void
    {
        if(GlobalConfig.SingleGame){
            var robotA:Role=new Role();
            robotA.initData("机器人A");
            robotA.initview();
            robotA.pos(50,100);
            this.addChild(robotA);

            var robotB:Role=new Role();
            robotB.initData("机器人B");
            robotB.initview();
            robotB.pos(1000,100);
            this.addChild(robotB);

            var player:Role=new Role();
            player.initData("玩家");
            player.initview(true);
            player.pos(50,550);
            this.addChild(player);
        }
    }
    private function initEvent():void
    {
        ready_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
        });
        cancellord_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
        });
        wantlord_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
        });
        wantdouble_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
        });
        canceldouble_btn.on(Event.MOUSE_DOWN,this,function () {
            btnBox.visible=false;
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

    }
    public function unRegister():void
    {

    }
    public function closePanel():void
    {

    }
}
}
