package client.src.control {
import client.src.constant.GameEvent;
import client.src.constant.GlobalConfig;
import client.src.constant.PokerConst;
import client.src.constant.RoleConst;
import client.src.elem.AI.AITools;
import client.src.elem.AI.AIelem;
import client.src.elem.card.Card;
import client.src.elem.role.Player;
import client.src.elem.role.Role;
import client.src.manager.GameEventDisPatch;
import client.src.manager.PokerToolManager
import client.src.model.DeskM;
import client.src.view.roomview.Roomview;

public class SingleDeskC {
    private static var _instance:SingleDeskC;
    public function SingleDeskC() {
        GameEventDisPatch.instance.on(GameEvent.DeskInit_SINGLE,this,deskSingleInit);

        GameEventDisPatch.instance.on(GameEvent.BroadCast_Ready_SINGLE,this,BroadCastReady);
        GameEventDisPatch.instance.on(GameEvent.BroadCast_RobDouble_SINGLE,this,BroadCastDouble);
        GameEventDisPatch.instance.on(GameEvent.READY_OVER_SINGLE,this,checkGameReady);

        GameEventDisPatch.instance.on(GameEvent.ROBLORD_OVER_SINGLE,this,checkLord);
        GameEventDisPatch.instance.on(GameEvent.ROBDOUBLE_OVER_SINGLE,this,checkGameStart);
    }
    public static function get instance():SingleDeskC{
        return _instance||=new SingleDeskC();
    }

    private function deskSingleInit():void
    {
        DeskM.instance.deskPokerType=PokerConst.TYPE_NONE;
        DeskM.instance.deskHeadValue=PokerConst.CARD_NONE;
        DeskM.instance.landlordCards=PokerToolManager.instance.lordlist;
        DeskM.instance.seatIdArr=[1,2,3];

        DeskM.instance.playerTurn=1;
    }

    private function BroadCastReady():void
    {
        var playerlist:Array=Roomview.instance.roleList;
        for(var i:int=0;i<playerlist.length;i++) {
            playerlist[i].event(GameEvent.PLAYER_READY_SINGLE);
        }
    }
    private function BroadCastDouble():void
    {
        if(!checkProfession()) return;
        console.log("--BroadCastDouble");
        GameEventDisPatch.instance.event(GameEvent.DESK_LORDCARD_SINGLE);//显示地主牌

        var lord:*=DeskM.instance.landlord;//刷新地主牌
        lord.checkInCard(DeskM.instance.landlordCards);
        if(lord is Player){
            Roomview.instance.player.showCardlist();
        }

        //叫分
        var playerlist:Array=Roomview.instance.roleList;
        for(var i:int=0;i<playerlist.length;i++) {
            playerlist[i].event(GameEvent.PLAYER_WANT_DOUBLE_SINGLE);
        }
    }

    private function checkGameReady():void
    {
        var playerlist:Array=Roomview.instance.roleList;
        var readPlayer:Number=0;
        for(var i:int=0;i<playerlist.length;i++) {
            if(playerlist[i].state=="onReady"){
                readPlayer++;
            }else{
                return;
            }
        }

        if(readPlayer==playerlist.length) dealToPlayer();
    }



    //发牌-抢地主-加倍-正式游戏
    private function dealToPlayer():void
    {
        var playerlist:Array=Roomview.instance.roleList;
        playerlist[0].cardlist=PokerToolManager.instance.playerCardlist;
        playerlist[1].cardlist=PokerToolManager.instance.playerCardlist;
        playerlist[2].cardlist=PokerToolManager.instance.playerCardlist;


        //Roomview.instance.player.showCardlist();

        //test
        var numlist:Array=[
            3,4,5,5,5,5,6,7,7,8,9,10,10,12,12,13,14,14
        ];
        Roomview.instance.player.cardlist=PokerToolManager.instance.createPolersTest(numlist);
        //PokerToolManager.instance.sortPokers(Roomview.instance.player.cardlist);
        Roomview.instance.player.showCardlist();

        var aielem:AIelem=new AIelem();
        aielem.cardlist=Roomview.instance.player.cardlist;
        return;

        DeskM.instance.wantLordSeat=0;
        DeskM.instance.robLordIndex=0;//记数
        DeskM.instance.playerTurn=1;//轮位
        playerlist[0].event(GameEvent.PLAYER_WANT_LORD_SINGLE);//轮询
    }

    //地主检测
    private function checkLord(wantSeat:Number=-1):void
    {
        DeskM.instance.robLordIndex++;
        var roblordIndex:Number=DeskM.instance.robLordIndex;
        var wantlordNum:Number=wantLordNum;
        if(wantSeat>=0) DeskM.instance.wantLordSeat=wantSeat;
        var wantlordSeat:Number=DeskM.instance.wantLordSeat;

        var rolelist:Array=Roomview.instance.roleList;
        if(roblordIndex==3 && wantlordNum==0){
            //无人抢地主
            rolelist[0].profession=RoleConst.Landlord;
            rolelist[1].profession=RoleConst.Farmer;
            rolelist[2].profession=RoleConst.Farmer;
            DeskM.instance.landlord=rolelist[0];
            GameEventDisPatch.instance.event(GameEvent.BroadCast_RobDouble_SINGLE);//加倍
        }
        else if(roblordIndex==3 && wantlordNum==1){
            //一人抢地主
            rolelist[0].profession=RoleConst.Farmer;
            rolelist[1].profession=RoleConst.Farmer;
            rolelist[2].profession=RoleConst.Farmer;
            rolelist[wantlordSeat-1].profession=RoleConst.Landlord;
            DeskM.instance.landlord=rolelist[wantlordSeat-1];
            GameEventDisPatch.instance.event(GameEvent.BroadCast_RobDouble_SINGLE);//加倍
        }
        else if(roblordIndex==3 && wantlordNum==2 && rolelist[0].state=="cancelLord"){
            //两人抢地主，一号位不想当地主
            rolelist[0].profession=RoleConst.Farmer;
            rolelist[1].profession=RoleConst.Farmer;
            rolelist[2].profession=RoleConst.Landlord;
            DeskM.instance.landlord=rolelist[2];
            GameEventDisPatch.instance.event(GameEvent.BroadCast_RobDouble_SINGLE);//加倍
        }
        else if(roblordIndex==4 && wantlordNum>=2){
            //多人抢地主，一号想当地主
            rolelist[0].profession=RoleConst.Farmer;
            rolelist[1].profession=RoleConst.Farmer;
            rolelist[2].profession=RoleConst.Farmer;
            if(rolelist[0].state=="robLord"){
                //1号位抢-1号位地主
                rolelist[0].profession=RoleConst.Landlord;
                DeskM.instance.landlord=rolelist[0];
            }
            else if(rolelist[0].state=="cancelLord"){
                //1号位不抢-wantlordSeat 地主
                rolelist[wantlordSeat-1].profession=RoleConst.Landlord;
                DeskM.instance.landlord=rolelist[wantlordSeat-1];
            }
            GameEventDisPatch.instance.event(GameEvent.BroadCast_RobDouble_SINGLE);//加倍
        }
        else{
            DeskM.instance.playerTurn++;
            var role:Role=rolelist[DeskM.instance.playerTurn-1];
            role.event(GameEvent.PLAYER_WANT_LORD_SINGLE);
        }
    }




    //是否已完成职业分配
    private function checkProfession():Boolean
    {
        var rolelist:Array=Roomview.instance.roleList;
        var haveNum:Number=0;
        for(var i:int=0;i<rolelist.length;i++){
            if(rolelist[i].profession!=null){
                haveNum++;
            }
        }
        if(haveNum==3) return true;
        else return false;
    }

    //抢地主得玩家数
    private function get wantLordNum():Number
    {
        var rolelist:Array=Roomview.instance.roleList;
        var wantNum:Number=0;
        for(var i:int=0;i<rolelist.length;i++){
            if(rolelist[i].state=="robLord"){
                wantNum++;
            }
        }
        return wantNum;
    }
}
}
