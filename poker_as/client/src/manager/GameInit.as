package client.src.manager {
import client.src.control.NetDeskC;
import client.src.control.GameMainC;
import client.src.control.PlayerC;
import client.src.control.SingleDeskC;
import client.src.model.DeskM;
import client.src.model.PlayerM;

public class GameInit {
    private static var _instance:GameInit;
    public function GameInit() {
    }
    public static function get instance():GameInit
    {
        return _instance||=new GameInit();
    }

    public function init():void
    {
        initModel();
        initControl();
    }

    private function initModel():void
    {
        DeskM.instance;
        PlayerM.instance;
    }
    private function initControl():void
    {
        GameMainC.instance;
        NetDeskC.instance;
        PlayerC.instance;
        SingleDeskC.instance;
    }
}
}
