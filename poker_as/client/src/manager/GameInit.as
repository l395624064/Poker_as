package client.src.manager {
import client.src.control.GameMainC;

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

    }
    private function initControl():void
    {
        GameMainC.instance;

    }
}
}
