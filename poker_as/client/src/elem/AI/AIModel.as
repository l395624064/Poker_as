package client.src.elem.AI {

public class AIModel {
    public function AIModel() {
    }

    public var GameTurns:Number=1;//游戏轮数：忽略大牌得轮次

    public var seatId:Number;

    public var prevProfession:String;//上家身份
    public var nextProfession:String;//下家身份
    public var profession:String;//自己身份

    public var prevHandNum:Number;//上家手牌数
    public var nextHandNum:Number;//下家手牌数
    public var handNum:Number;//自己手牌数



    public var SingleArr:Array=[];//2，大小王,剩余单牌
    public var Double:Array=[];//对子,二维数组
    public var Three:Array=[];//三张,二维数组
    public var Straight:Array=[];//顺子,二维数组
    public var DoubleStraight:Array=[];//连对,二维数组
    public var AirplaneArr:Array=[];// 飞机,二维数组
    public var BoomArr:Array=[];// 炸弹,二维数组


    //剩余几手牌
    public function get handGroupNum():Number
    {
        var num:Number=0;
        num+=SingleArr.length;
        num+=BoomArr.length;
        num+=AirplaneArr.length;
        num+=Straight.length;
        num+=DoubleStraight.length;
        num+=Three.length;
        num+=Double.length;
        return num;
    }





    /*
    * 检出合法炸弹
    * */
    public function getBoom(maxNum:Number):Array
    {
        var boom:Array=[];
        for(var i:int=0;i<BoomArr.length;i++){
            boom=BoomArr[i];
            if(boom[0].cardValue>maxNum){
                BoomArr.splice(i,1);
                return boom;
            }
        }
        return null;
    }

    /*
    * 检出合法顺子
    * 不进行二次分裂
    * */
    public function getStraight(maxNum:Number,length:Number):Array
    {
        var straight:Array=[];
        if(maxNum==0 && length==0){
            straight=Straight.shift();
            return straight;
        }

        for(var i:int=0;i<Straight.length;i++){
            straight=Straight[i];
            if(straight[0].cardValue>maxNum && straight.length==length){
                Straight.splice(i,1);
                return straight;
            }
        }
        return null;
    }
    public function putInStraight(arr:Array):void
    {
        if(arr && arr.length>0){
            Straight.push(arr);
            sortArr(Straight);
        }
    }

    /*
    * 检出合法连对
    * 不进行二次分裂
    * */
    public function getDoubleStraight(maxNum:Number,length:Number):Array
    {
        var double:Array=[];
        if(maxNum==0 && length==0){
            double=DoubleStraight.shift();
            return double;
        }

        for(var i:int=0;i<DoubleStraight.length;i++){
            double=DoubleStraight[i];
            if(double[0].cardValue>maxNum && double.length==length){
                DoubleStraight.splice(i,1);
                return double;
            }
        }
        return null;
    }

    /*
    * 检测合法飞机
    * */
    public function getAirplane(maxNum:Number):Array
    {
        var airPlane:Array=[];
        for(var i:int=0;i<AirplaneArr.length;i++){
            airPlane=AirplaneArr[i];
            if(airPlane[0].cardValue>maxNum){
                AirplaneArr.splice(i,1);
                return airPlane;
            }
        }
        return null;
    }
    public function putInAirPlane(arr:Array):void
    {
        if(arr && arr.length>0){
            AirplaneArr.push(arr);
            sortArr(AirplaneArr);
        }
    }

    /*
    * 检出合法三连
    * */
    public function getThreeStraight(maxNum:Number,length:Number):Array
    {
        if(Three.length<length) return null;

        sortArr(Three);
        var threeS:Array;
        for(var i:int=0;i<Three.length-2;i++){
            if(Three[i][0].cardValue<=maxNum){
                continue;//数值不符合
            }

            if(Three.length-i<length){
                return null;//长度不符合
            }

            if(checkStraight(Three,i,length)){
                threeS=Three.splice(i,length);
                return threeS;
            }
        }
        return null;
    }







    //检出合法三张
    public function getThree(maxNum:Number):Array
    {
        var three:Array;
        for(var i:int=0;i<Three.length;i++){
            three=Three[i];
            if(three[0].cardValue>maxNum){
                Three.splice(i,1);
                return three;
            }
        }
        return null;
    }
    public function putInThree(arr:Array){
        if(arr && arr.length>0){
            Three.push(arr);
            sortArr(Three);
        }
    }


    //检出合法对子
    public function getDouble(maxNum:Number):Array
    {
        var double:Array;
        for(var i:int=0;i<Double.length;i++){
            double=Double[i];
            if(double[0].cardValue>maxNum){
                Double.splice(i,1);
                return double;
            }
        }
        return null;
    }
    public function putInDouble(arr:Array):void
    {
        if(arr && arr.length>0){
            Double.push(arr);
            sortArr(Double);
        }
    }



    /*
    * 检出合法单牌
    * */
    public function getSingle(maxNum:Number):*
    {
        var card:*;
        for(var i:int=0;i<SingleArr.length;i++){
            card=SingleArr[i];
            if(card.cardValue>maxNum){
                SingleArr.splice(i,1);
                return card;
            }
        }
        return null;
    }
    public function putInSingle(card:*):void
    {
        if(card){
            SingleArr.push(card);
            sortArr(SingleArr);
        }
    }

    /*
    * 从SingleArr内检出小牌
    * */
    public function getSmallSingleNum():Number
    {
        var card:*;
        var num:Number=0;
        for(var i:int=0;i<SingleArr.length;i++){
            card=SingleArr[i];
            if(card.cardValue<AIPokerConst.CARD_TWO){
                num++;
            }
        }
        return num;
    }

    /*
    * 从SingleArr内检出王炸
    * */
    public function getBoomArr():Array
    {
        var boomArr:Array=[];
        var card:*;
        for(var i:int=SingleArr.length-1;i>=0;i--){
            card=SingleArr[i];
            if(card.cardValue==AIPokerConst.CARD_BJoker || card.cardValue==AIPokerConst.CARD_SJoker){
                boomArr.push(SingleArr.splice(i,1));
            }
        }

        if(boomArr.length==2){
            return boomArr;
        }
        putInSingle(boomArr[0]);//放回
        return null;
    }
    /*
    * 从SingleArr内检出对2
    * */
    public function getTwoArr(maxnum:Number):Array
    {
        const maxNum:Number=maxnum;
        var nowNum:Number=0;
        var twoArr:Array=[];
        var card:*;
        for(var i:int=SingleArr.length-1;i>=0;i--){
            card=SingleArr[i];
            if(card.cardValue==AIPokerConst.CARD_TWO && nowNum<maxNum){
                twoArr.push(SingleArr.splice(i,1));
            }
        }

        if(twoArr.length==maxNum){
            return twoArr;
        }

        for(i=twoArr.length-1;i>=0;i--){
            putInSingle(twoArr[i]);//放回
        }
        return null;
    }

    //是否为大单
    public function checkBigSingle(card:*):Boolean
    {
        if(card.cardValue<AIPokerConst.CARD_TWO){
            return false;
        }
        return true;
    }



    //放回-排序
    private function sortArr(arr:Array):void
    {
        arr.sort(function (a,b):Number {
            if(a is Array || b is Array){
                return (a[0].cardValue>b[0].cardValue)? 1:-1;
            }
            return (a.cardValue>b.cardValue)? 1:-1;
        });
    }


    //检测Straight
    private function checkStraight(arr:Array,startIndex:Number,length:Number):Boolean
    {
        var cardA:*;
        var cardB:*;
        var cardC:*;
        var cardD:*;
        var cardE:*;
        var cardF:*;
        if(length==2){
            cardA=arr[startIndex][0];
            cardB=arr[startIndex+1][0];
            if(cardA.cardValue==cardB.cardValue-1){
                return true;
            }
        }
        else if(length==3){
            cardA=arr[startIndex][0];
            cardB=arr[startIndex+1][0];
            cardC=arr[startIndex+2][0];
            if(cardA.cardValue==cardB.cardValue-1==cardC.cardValue-2){
                return true;
            }
        }
        else if(length==4){
            cardA=arr[startIndex][0];
            cardB=arr[startIndex+1][0];
            cardC=arr[startIndex+2][0];
            cardD=arr[startIndex+3][0];
            if(cardA.cardValue==cardB.cardValue-1==cardC.cardValue-2==cardD.cardValue-3){
                return true;
            }
        }
        else if(length==5){
            cardA=arr[startIndex][0];
            cardB=arr[startIndex+1][0];
            cardC=arr[startIndex+2][0];
            cardD=arr[startIndex+3][0];
            cardE=arr[startIndex+4][0];
            if(cardA.cardValue==cardB.cardValue-1==cardC.cardValue-2==cardD.cardValue-3==cardE.cardValue-4){
                return true;
            }
        }
        else if(length==6){
            cardA=arr[startIndex][0];
            cardB=arr[startIndex+1][0];
            cardC=arr[startIndex+2][0];
            cardD=arr[startIndex+3][0];
            cardE=arr[startIndex+4][0];
            cardF=arr[startIndex+5][0];
            if(cardA.cardValue==cardB.cardValue-1==cardC.cardValue-2==cardD.cardValue-3==cardE.cardValue-4==cardF.cardValue-5){
                return true;
            }
        }
        return false;
    }


}
}
