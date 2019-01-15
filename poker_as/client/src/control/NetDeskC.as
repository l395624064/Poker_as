package client.src.control {
import client.src.constant.GameEvent;
import client.src.constant.GlobalConfig;
import client.src.constant.PokerConst;
import client.src.manager.GameEventDisPatch;
import client.src.manager.PokerToolManager;
import client.src.model.DeskM;
import client.src.view.roomview.Roomview;

public class NetDeskC {
    private static var _instance:NetDeskC;
    public function NetDeskC() {
        //收发事件/协议  操作deskModel数据
        GameEventDisPatch.instance.on(GameEvent.DeskInit_NET,this,deskNetInit);

        GameEventDisPatch.instance.on(GameEvent.PLAYER_READY_NET,this,readyHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_RobLord_NET,this,robLordHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_RobScore_NET,this,robScoreHandle);

        GameEventDisPatch.instance.on(GameEvent.PLAYER_WANT_LORD_NET,this,wantLordHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_WANT_DOUBLE_NET,this,wantDoubleHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_SHOWCARD_NET,this,showCardHandle);
        GameEventDisPatch.instance.on(GameEvent.PLAYER_PASS_NET,this,passTurnHandle);
    }



    public static function get instance():NetDeskC
    {
        return _instance||=new NetDeskC();
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
    private function wantDoubleHandle():void
    {

    }
    private function showCardHandle():void
    {

    }
    private function passTurnHandle():void
    {

    }





    private function deskNetInit():void
    {

    }







}
}
