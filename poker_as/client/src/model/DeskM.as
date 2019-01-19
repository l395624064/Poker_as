package client.src.model {
import client.src.constant.PokerConst;
import client.src.elem.card.Card;
import client.src.elem.role.Player;
import client.src.elem.role.Role;

import laya.utils.Pool;

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

    public var deskPokerleng:Number=0;//牌组长度
    private var _deskPokerList:Array=[];//当前桌牌
    public function get deskPokerList():Array{
        return _deskPokerList;
    }
    public function set deskPokerList(value:Array):void{
        if(_deskPokerList.length>0){
            clearDeskCard();
        }
        _deskPokerList=value;
        deskPokerleng=value.length;
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

    private var _playerTurn:Number;//当前座位的回合
    public function get playerTurn():Number{
        return _playerTurn;
    }
    public function set playerTurn(value:Number):void{
        if(value<=0||value>3) throw new Error("DeskM playerTurn set warn!");
        _playerTurn=value;
    }
    public function initPlayerTurn():void{
        _playerTurn=1;
    }
    public function updatePlayerTurn():void
    {
        _playerTurn++;
        if(_playerTurn>3) _playerTurn=1;
    }


    private var _wantLordSeatArr:Array=[];//抢地主座位
    public function get wantLordSeatArr():Array{
        return _wantLordSeatArr;
    }
    public function set wantLordSeatArr(value:Array):void{
        _wantLordSeatArr=value;
    }

    private var _completeNum:Number=0;//已完成的玩家计数
    public function get completeNum():Number{
        return _completeNum;
    }
    public function set completeNum(value:Number):void{
        _completeNum=value;
    }


    private var _scoreNum:Number=0;//分数倍数
    public function get scoreNum():Number{
        return _scoreNum;
    }
    public function set scoreNum(value:Number):void{
        _scoreNum=value;
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

    private var _playerlist:Array=[];//当前玩家数组
    public function get playerList():Array{
        return _playerlist;
    }
    public function set playerList(arr:Array):void{
        _playerlist=arr;
    }
    public function get maxPlayer():*{
        return _playerlist[maxSeatId-1];//最大出牌者
    }

    private var _player:Player;//自己
    public function get Player():Player{
        return _player;
    }
    public function set Player(role:Player):void{
        _player=role;
    }





    /*
    * 初始化牌桌信息
    * */
    public function initRound(maxSeat:Number):void
    {
        deskPokerList=[];//当前桌面牌
        deskHeadValue=PokerConst.CARD_NONE;//当前桌面牌值
        deskPokerType=PokerConst.TYPE_NONE;//当前桌面类型
        maxSeatId=maxSeat;//最大出牌者座位号
        playerTurn=maxSeat;//当前回合的桌位
        gameTurn++;//当前轮数
    }

    /*
    * 清理桌面牌
    * */
    private function clearDeskCard():void
    {
        var card:Card;
        for(var i:int=_deskPokerList.length-1;i>=0;i--){
            card=_deskPokerList[i];
            Pool.recover(card.sign,card);
            card.removeSelf();
        }
        _deskPokerList=[];
    }


    public function DeskM() {
    }





}
}
