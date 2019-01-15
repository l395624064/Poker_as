package client.src.model {
import client.src.constant.PokerConst;
import client.src.elem.role.Role;

public class DeskM {
    private static var _instance:DeskM;
    public static function get instance():DeskM
    {
        return _instance||=new DeskM();
    }


    /*
    private var _deskPokerNum:Number;//当前桌牌数
    public function get deskPokerNum():Number{
        return _deskPokerNum;
    }
    public function set deskPokerNum(value:Number):void{
        _deskPokerNum=value;
    }
    */


    private var _deskBJokerHave:Boolean=false;//当前牌桌大王
    private var _deskSJokerHave:Boolean=false;//当前牌桌小王
    private var _deskPokerTwoNum:Number=0;//当前牌桌已出2的数量
    public function get deskPokerTwoNum():Number{
        return _deskPokerTwoNum;
    }
    public function set deskPokerTwoNum(value:Number):void{
        _deskPokerTwoNum=value;
    }

    private var _deskPokerList:Array=[];//当前桌牌
    public function get deskPokerList():Array{
        return _deskPokerList;
    }
    public function set deskPokerList(value:Array):void{
        _deskPokerList=value;
    }

    private var _deskPokerType:String;//当前桌牌类型
    public function get deskPokerType():String{
        return _deskPokerType;
    }
    public function set deskPokerType(value:String):void{
        _deskPokerType=value;
    }

    private var _deskHeadValue:Number;//当前桌牌权值
    public function get deskHeadValue():Number{
        return _deskHeadValue;
    }
    public function set deskHeadValue(value:Number):void{
        _deskHeadValue=value;
    }

    private var _seatIndex:Number=-1;
    private var _seatIdArr:Array=[1,2,3];//座位号
    public function set seatIdArr(value:Array):void{
        _seatIdArr=value;
        _seatIndex=-1;
    }
    public function get seatId():Number{
        if(_seatIdArr && _seatIdArr.length>0){
            var index:Number;
            var seatid:Number;
            if(_seatIndex==-1){
                index=Math.floor(Math.random()*_seatIdArr.length);
                seatid=_seatIdArr[index];
                _seatIndex=index;
            }else{
                _seatIndex++;
                if(_seatIndex>=_seatIdArr.length) _seatIndex=0;
                seatid=_seatIdArr[_seatIndex];
            }
            //_seatIdArr.splice(index,1);
            return seatid;
        }
        throw new Error("seatid not enough");
    }


    private var _gameTurn:Number;//游戏轮数
    public function get gameTurn():Number{
        return _gameTurn;
    }
    public function set gameTurn(value:Number):void{
        _gameTurn=value;
    }

    private var _maxSeatId:Number;//最大出牌者座位号
    public function get maxSeatId():Number{
        return _maxSeatId;
    }
    public function set maxSeatId(value:Number):void{
        _maxSeatId=value;
    }

    private var _playerTurn:Number;//轮位
    public function get playerTurn():Number{
        return _playerTurn;
    }
    public function set playerTurn(value:Number):void{
        _playerTurn=value;
        if(_playerTurn>3) _playerTurn=1;
    }

    private var _wantLordSeat:Number;//抢地主座位
    public function get wantLordSeat():Number{
        return _wantLordSeat;
    }
    public function set wantLordSeat(value:Number):void{
        _wantLordSeat=value;
    }

    private var _robLordIndex:Number=0;//抢地主计数
    public function get robLordIndex():Number{
        return _robLordIndex;
    }
    public function set robLordIndex(value:Number):void{
        _robLordIndex=value;
    }



    private var _landlordCards:Array=[];//地主三张
    public function get landlordCards():Array{
        return _landlordCards;
    }
    public function set landlordCards(value:Array):void{
        _landlordCards=value;
    }

    private var _landlord:Role;//地主
    public function get landlord():Role{
        return _landlord;
    }
    public function set landlord(role:Role):void{
        _landlord=role;
    }




    public function DeskM() {
    }





}
}
