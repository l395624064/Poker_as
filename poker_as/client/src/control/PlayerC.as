package client.src.control {
import client.src.constant.GameEvent;
import client.src.manager.GameEventDisPatch;
import client.src.manager.GameEventDisPatch;

public class PlayerC {
    private static var _instance:PlayerC;
    public function PlayerC() {
        //

    }
    public static function get instance():PlayerC
    {
        return _instance||=new PlayerC();
    }
}
}
