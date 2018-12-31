package client.src.manager {
public class PokerToolManager {
    private static var _instance:PokerToolManager;
    public function PokerToolManager() {
    }
    public static function get instance():PokerToolManager{
        return _instance||=new PokerToolManager();
    }


    /*创建牌库*/
    public function createPokerslib():void
    {

    }

    /*排序*/
    public function sortPokers():Array
    {

    }

    /*打乱*/
    public function randomPokers():Array
    {

    }


}
}
