package client.src.elem.role {
import client.src.constant.GameEvent;
import client.src.manager.GameEventDisPatch;
import client.src.model.DeskM;

public class Robot extends Role{
    public function Robot(){

        init();
    }

    private function init():void
    {
        super.initData("机器人");
        super.initview();
        super.ifRobot=true;

        register();
    }

    override protected function onReady():void
    {
        super.state = "onReady";
        console.log(this.playerName,this.seatNum,this.state);
        GameEventDisPatch.instance.event(GameEvent.READY_OVER_SINGLE);
    }

    override protected function wantLandlord():void
    {
        super.state="cancelLord";
        console.log(this.playerName,this.seatNum,this.state);
        if(super.state=="robLord"){
            GameEventDisPatch.instance.event(GameEvent.ROBLORD_OVER_SINGLE,this.seatNum);
        }else{
            GameEventDisPatch.instance.event(GameEvent.ROBLORD_OVER_SINGLE);
        }
    }

    override protected function wantDoubleScore():void
    {
        super.state="cancelDouble";
        console.log(this.playerName,this.seatNum,this.state);
        GameEventDisPatch.instance.event(GameEvent.ROBDOUBLE_OVER_SINGLE);
    }







    override protected function register():void
    {
        this.on(GameEvent.PLAYER_WANT_LORD_SINGLE,this,wantLandlord);
        this.on(GameEvent.PLAYER_WANT_DOUBLE_SINGLE,this,wantDoubleScore);
        this.on(GameEvent.PLAYER_READY_SINGLE,this,onReady);
    }

    override protected function unRegister():void
    {
        this.off(GameEvent.PLAYER_WANT_LORD_SINGLE,this,wantLandlord);
        this.off(GameEvent.PLAYER_WANT_DOUBLE_SINGLE,this,wantDoubleScore);
        this.off(GameEvent.PLAYER_READY_SINGLE,this,onReady);
    }

}
}
