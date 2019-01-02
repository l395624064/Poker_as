package client.src.control {
import client.src.constant.GameEvent;
import client.src.constant.PokerConst;
import client.src.manager.GameEventDisPatch;
import client.src.model.DeskM;

public class DeskC {
    private static var _instance:DeskC;
    public function DeskC() {
        //收发事件/协议  操作deskModel数据
        GameEventDisPatch.instance.on(GameEvent.DeskInit_SINGLE,this,deskSingleInit);
        GameEventDisPatch.instance.on(GameEvent.DeskInit_NET,this,deskNetInit);

        GameEventDisPatch.instance.on(GameEvent.PLAYER_READY,this,readyHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_RobLord,this,robLordHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_RobScore,this,robScoreHandle);

        GameEventDisPatch.instance.on(GameEvent.PLAYER_WANT_LORD,this,wantLordHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_CANCEL_LORD,this,cancelLordHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_WANT_DOUBLE,this,wantDoubleHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_CANCEL_DOUBLE,this,cancelDoubleHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_SHOWCARD,this,showCardHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_PASS,this,passTurnHandle);
    }



    public static function get instance():DeskC
    {
        return _instance||=new DeskC();
    }

    /*给玩家发牌*/
    private function dealToPlayer():void
    {

    }

    private function readyHandle():void
    {

    }
    private function robLordHandle():void
    {

    }
    private function robScoreHandle():void
    {

    }

    private function wantLordHandle():void
    {
        //S端发送抢地主事件

    }
    private function cancelLordHandle():void
    {

    }
    private function wantDoubleHandle():void
    {

    }
    private function cancelDoubleHandle():void
    {

    }
    private function showCardHandle():void
    {

    }
    private function passTurnHandle():void
    {

    }




    private function deskSingleInit():void
    {
        DeskM.instance.deskPokerType=PokerConst.TYPE_NONE;
        DeskM.instance.deskHeadValue=PokerConst.CARD_NONE;

    }
    private function deskNetInit():void
    {

    }







}
}
