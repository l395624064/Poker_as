package client.src.view.roomview {
import ui.GameviewUI;

public class Roomview extends GameviewUI{
    private static var _instance:Roomview;
    public function Roomview() {
    }
    public static function get instance():Roomview
    {
        return _instance||=new Roomview();
    }

    public function openPanel():void
    {
        initData();
        initView();
        initEvent();
    }

    private function initData():void
    {


    }

    private function initView():void
    {

    }
    private function initEvent():void
    {

    }



    public function closePanel():void
    {

    }

}
}
