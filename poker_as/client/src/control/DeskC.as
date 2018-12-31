package client.src.control {
public class DeskC {
    private static var _instance:DeskC;
    public function DeskC() {
        //收发事件/协议  操作deskModel数据
    }
    public static function get instance():DeskC
    {
        return _instance||=new DeskC();
    }

    /*给玩家发牌*/
    private function dealToPlayer():void
    {

    }






}
}
