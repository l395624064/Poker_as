package client.src.model {

public class DeskM {
    private static var _instance:DeskM;
    public static function get instance():DeskM
    {
        return _instance||=new DeskM();
    }

    private var _pokersNum:Number;
    public function get pokersNum():Number{
        return _pokersNum;
    }
    public function set pokersNum(value:Number):void{
        _pokersNum=value;
    }

    private var _pokersType:String;
    public function get pokersType():String{
        return _pokersType;
    }
    public function set pokersType(value:String):void{
        _pokersType=value;
    }

    private var _pokersList:Array=[];
    public function get pokersList():Array{
        return _pokersList;
    }
    public function set pokersList(value:Array):void{
        _pokersList=value;
    }

    private var _gameTurn:Number;
    public function get gameTurn():Number{
        return _gameTurn;
    }
    public function set gameTurn(value:Number):void{
        _gameTurn=value;
    }

    private var _playerTurn:Number;//第几位出牌
    public function get playerTurn():Number{
        return _playerTurn;
    }
    public function set playerTurn(value:Number):void{
        _playerTurn=value;
    }

    private var _landlordCards:Array=[];//地主三张
    public function get landlordCards():Array{
        return _landlordCards;
    }
    public function set landlordCards(value:Array):void{
        _landlordCards=value;
    }



    public function DeskM() {
    }





}
}
