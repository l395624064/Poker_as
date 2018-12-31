package client.src.data {
import client.src.constant.Protocol;

public class ProtocolData {
    //通过协议号返回JsonObj数据格式
    private static var _instance:ProtocolData;
    public static function get instance():ProtocolData{
        return _instance||=new ProtocolData();
    }

    public  function getJson(protocolNum:Number):Object
    {
        if(protocolNum==Protocol.GameRead){
            return {a:Protocol.GameRead,seatId:0,roomId:0};
        }
    }
}
}
