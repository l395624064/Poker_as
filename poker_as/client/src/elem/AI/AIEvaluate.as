package client.src.elem.AI {
public class AIEvaluate {

    private  var VALUE_three:Number=-7;
    private  var VALUE_four:Number=-6;
    private  var VALUE_five:Number=-5;
    private  var VALUE_six:Number=-4;
    private  var VALUE_seven:Number=-3;
    private  var VALUE_eight:Number=-2;
    private  var VALUE_nine:Number=-1;
    private  var VALUE_ten:Number=0;
    private  var VALUE_J:Number=1;
    private  var VALUE_Q:Number=2;
    private  var VALUE_K:Number=3;
    private  var VALUE_A:Number=4;

    private  var VALUE_TWO:Number=5;
    private  var VALUE_SJoker:Number=7;
    private  var VALUE_BJoker:Number=8;

    public function AIEvaluate() {
    }


    private var pArr:Array=[6,6,6,5,5,5,4,4,4,3];//轮次对应分值
    public function getHandCardValue(sumNum,turns:Number,hands:Number):Number
    {
        var p:Number=pArr[turns];
        var n:Number=hands;

        return sumNum-p*n;
    }




    //炸弹牌组价值
    public function getBoomArrValue(arr:Array):Number
    {
        var sum:Number=0;
        for(var i:int=0;i<arr.length;i++){
            sum+=getBoomValue();
        }
        return sum;
    }

    //飞机牌组价值
    public function getAirplaneArrValue(arr:Array):Number
    {
        var sum:Number=0;
        var maxNum:Number;
        for(var i:int=0;i<arr.length;i++){
            maxNum=arr[i][arr[i].length-1].cardValue
            sum+=getAirplaneValue(maxNum);
        }
        return sum;
    }

    //连对牌组价值
    public function getDoubleStraightArrValue(arr:Array):Number
    {
        var sum:Number=0;
        var maxNum:Number;
        for(var i:int=0;i<arr.length;i++){
            maxNum=arr[i][arr[i].length-1].cardValue
            sum+=getDoubleStraightValue(maxNum);
        }
        return sum;
    }

    //顺子牌组价值
    public function getStraightArrValue(arr:Array):Number
    {
        var sum:Number=0;
        var maxNum:Number;
        for(var i:int=0;i<arr.length;i++){
            maxNum=arr[i][arr[i].length-1].cardValue
            sum+=getStraightValue(maxNum);
        }
        return sum;
    }

    //单牌牌组价值
    public function getSingleArrValue(arr:Array):Number
    {
        var sum:Number=0;
        for(var i:int=0;i<arr.length;i++){
            sum+=getSingleValue(arr[i].cardValue);
        }
        return sum;
    }

    //对子牌组价值
    public function getDoubleArrValue(arr:Array):Number
    {
        var sum:Number=0;
        for(var i:int=0;i<arr.length;i++){
            sum+=getDoubleValue(arr[i][0].cardValue);
        }
        return sum;
    }

    //三张牌组价值
    public function getThreeArrValue(arr:Array):Number
    {
        var sum:Number=0;
        for(var i:int=0;i<arr.length;i++){
            sum+=getThreeValue(arr[i][0].cardValue);
        }
        return sum;
    }







    //王炸价值
    public function getJokerBoomValue():Number{
        return 12;
    }

    //炸弹价值
    public function getBoomValue():Number{
        return 9;
    }

    /*
    * 飞机带翅膀价值
    * 333444 带 两对 或者 俩单
    * wingNum=[牌值，牌值];
    * */
    public function getAirplaneAndwingValue(maxNum:Number,wingNum:Array):Number
    {
        var sum:Number=Math.max(0,getSingleValue(maxNum)/2);
        if(wingNum[0]>AIPokerConst.CARD_ten){
            sum+=getSingleValue(wingNum[0]);
        }
        if(wingNum[1]>AIPokerConst.CARD_ten){
            sum+=getSingleValue(wingNum[1]);
        }
        return sum;
    }

    //飞机价值
    public function getAirplaneValue(maxNum:Number):Number
    {
        var sum:Number=Math.max(0,getSingleValue(maxNum)/2);
        return sum;
    }

    //连对价值
    public function getDoubleStraightValue(maxNum:Number):Number
    {
        var sum:Number=Math.max(0,getSingleValue(maxNum)/2);
        return sum;
    }

    //顺子价值
    public function getStraightValue(maxNum:Number):Number
    {
        var sum:Number=Math.max(0,getSingleValue(maxNum)/2);
        return sum;
    }

    //三带一价值
    public function getThreeAndoneValue(threeNum:Number):Number
    {
        var sum:Number=getSingleValue(threeNum);
        if(threeNum>AIPokerConst.CARD_ten){
            sum+=sum*0.5;
        }
        return sum;
    }

    //三张价值
    public function getThreeValue(value:Number):Number
    {
        var sum:Number=getSingleValue(value);
        if(value>AIPokerConst.CARD_ten){
            sum+=sum;
        }
        return sum;
    }

    //对子价值
    public function getDoubleValue(value:Number):Number
    {
        var sum:Number=getSingleValue(value);
        if(value>AIPokerConst.CARD_ten){
            sum+=sum*0.5;
        }
        return sum;
    }

    //单牌价值
    public function getSingleValue(value:Number):Number
    {
        var eva:Number=0;
        switch (value){
            case AIPokerConst.CARD_three:eva=VALUE_three;
                break;
            case AIPokerConst.CARD_four:eva=VALUE_four;
                break;
            case AIPokerConst.CARD_five:eva=VALUE_five;
                break;
            case AIPokerConst.CARD_six:eva=VALUE_six;
                break;
            case AIPokerConst.CARD_seven:eva=VALUE_seven;
                break;
            case AIPokerConst.CARD_eight:eva=VALUE_eight;
                break;
            case AIPokerConst.CARD_nine:eva=VALUE_nine;
                break;
            case AIPokerConst.CARD_ten:eva=VALUE_ten;
                break;
            case AIPokerConst.CARD_J:eva=VALUE_J;
                break;
            case AIPokerConst.CARD_Q:eva=VALUE_Q;
                break;
            case AIPokerConst.CARD_K:eva=VALUE_K;
                break;
            case AIPokerConst.CARD_A:eva=VALUE_A;
                break;

            case AIPokerConst.CARD_TWO:eva=VALUE_TWO;
                break;
            case AIPokerConst.CARD_SJoker:eva=VALUE_SJoker;
                break;
            case AIPokerConst.CARD_BJoker:eva=VALUE_BJoker;
                break;
        }
        return eva;
    }



















}
}
