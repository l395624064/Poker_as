package client.src.model {
public class PlayerM {
    private static var _instance:PlayerM;
    public function PlayerM() {
    }
    public static function get instance():PlayerM
    {
        return _instance||=new PlayerM();
    }


}
}
