package client.src.elem.role {
import laya.maths.Point;

public class Role {
    public var headImg:String="";//头像
    public var scoreNum:Number;//分数
    public var goldNum:Number;//金币
    public var seatNum:Number;//座位号
    public var cardlist:Array=[];//手牌
    public var surplusCardNum:Number;//剩余手牌数量
    public var profession:String;//职业
    public var ifRobot:Boolean=false;//是否为电脑
    public var cardPoint:Point;//牌起始位置

    public function Role() {
    }

    //检出牌
    public function checkoutCards():void
    {

    }

    //检入牌
    public function checkInCard():void
    {

    }

    //跳过出牌
    public function passTurn():void
    {

    }

    //抢地主
    public function wantLandlord():void
    {

    }

    //加倍
    public function wantDoubleScore():void
    {

    }

    public function updateGold():void
    {

    }
    public function updateScore():void
    {

    }




}
}
