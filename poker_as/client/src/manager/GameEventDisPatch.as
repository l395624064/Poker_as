package client.src.manager {
import laya.events.EventDispatcher;

public class GameEventDisPatch extends EventDispatcher{
    private static var _instance:GameEventDisPatch;
    public function GameEventDisPatch() {
    }

    public static function get instance():GameEventDisPatch
    {
        return _instance||=new GameEventDisPatch();
    }

}
}
