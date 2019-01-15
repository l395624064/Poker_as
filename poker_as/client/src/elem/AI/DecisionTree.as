package client.src.elem.AI {
import client.src.model.DeskM;

public class DecisionTree {
    public var model:AIModel;
    public var aielem:AIelem;
    public var deskM:DeskM;
    public function DecisionTree() {
    }

    /*
    public static var TYPE_Single:String="TYPE_Single";//单
    public static var TYPE_Double:String="TYPE_Double";//对
    public static var TYPE_Three:String="TYPE_Three";//三不带
    public static var TYPE_ThreeAndOne:String="TYPE_ThreeAndOne";//三带一
    public static var TYPE_ThreeAndTwo:String="TYPE_ThreeAndTwo";//三带二

    public static var TYPE_Straight:String="TYPE_Straight";//顺子
    public static var TYPE_DoubleStraight:String="TYPE_DoubleStraight";//连对
    public static var TYPE_ThreeStraight:String="TYPE_ThreeStraight";//三连
    public static var TYPE_Airplane:String="TYPE_Airplane";//飞机

    public static var TYPE_Boom:String="TYPE_Boom";//炸弹
    public static var TYPE_JokerBoom:String="TYPE_JokerBoom";//王炸
    public static var TYPE_NONE:String="TYPE_NONE";//不存在得牌型
    */
    /*
    * 基础出牌策略
    * 不对身份以及局面进行判断
    * */
    public function baseSelfDecision():Array
    {
        var outCard:Array=bD_lastHand();//最后一手

        if(!outCard||outCard.length<=0){
            outCard=bD_lastTwoHand();//最后两手
        }
        if(!outCard||outCard.length<=0){
            outCard=bD_trimHand();//压缩牌型质量
        }
        if(!outCard||outCard.length<=0){
            outCard=bD_bottom();//兜底
        }
        return outCard;
    }

    /*
    * 兜底策略:
    * 依据牌型复杂度检出牌
    * 出飞机带双对(不包含10以上对子)》出飞机带双单(不包含大小王,2,A)》连对》顺子》三带二(不包含A及以上)》三带一(不包含2及以上)》对》单》炸弹
    * */
    private function bD_bottom():Array
    {
        var handgroupNum:Number=model.handGroupNum;
        var cardlist:Array=[];
        if(model.AirplaneArr.length>0){
            var airPlane:Array=[];
            if(model.Double.length>=2){
                airPlane=model.getAirplane(0);
                var doubleA:Array=model.getDouble(0);
                var doubleB:Array=model.getDouble(0);
                if(handgroupNum<6){
                    cardlist.push(airPlane,doubleA,doubleB);//牌组数小于6时 可带任意牌型
                    return cardlist;
                }
                else if(doubleA[0].cardValue<=AIPokerConst.CARD_ten && doubleB[0].cardValue<=AIPokerConst.CARD_ten){
                    cardlist.push(airPlane,doubleA,doubleB);//飞机携带对子禁止大于10
                    return cardlist;
                }else{
                    model.putInSingle(doubleA);
                    model.putInSingle(doubleB);
                    model.putInAirPlane(airPlane);
                }
            }
            else if(model.SingleArr.length>=2){
                airPlane=model.getAirplane(0);
                var singleA:*=model.getSingle(0);
                var singleB:*=model.getSingle(0);
                if(handgroupNum<6){
                    cardlist.push(airPlane,singleA,singleB);//牌组数小于6时 可带任意牌型
                    return cardlist;
                }
                else if(singleA.cardValue<AIPokerConst.CARD_A && singleB.cardValue<=AIPokerConst.CARD_A){
                    cardlist.push(airPlane,singleA,singleB);//飞机携带单牌小于A
                    return cardlist;
                }else{
                    model.putInSingle(singleA);
                    model.putInSingle(singleB);
                    model.putInAirPlane(airPlane);
                }
            }
        }
        if(model.DoubleStraight.length>0){
            cardlist=model.getDoubleStraight(0,0);//最小连对
            return cardlist;
        }
        if(model.Straight.length>0){
            cardlist=model.getStraight(0,0);//最小顺子
            return cardlist;
        }
        if(model.Three.length>0){
            var three:Array=[];
            if(model.Double.length>0){
                three=model.getThree(0);//最小三张
                var doubleX:Array=model.getDouble(0);
                if(handgroupNum<5){
                    cardlist.push(three,doubleX);//牌组数小于5时 可带任意牌型
                    return cardlist;
                }
                else if(doubleX[0].cardValue<AIPokerConst.CARD_A){
                    cardlist.push(three,doubleX);//携带对子小于A
                    return cardlist;
                }else{
                    model.putInDouble(doubleX);
                    model.putInThree(three);
                }
            }
            else if(model.SingleArr.length>0){
                three=model.getThree(0);//最小三张
                var singleX:*=model.getSingle(0);
                if(handgroupNum<5){
                    cardlist.push(three,singleX);//牌组数小于5时 可带任意牌型
                    return cardlist;
                }
                else if(singleX.cardValue<AIPokerConst.CARD_TWO){
                    cardlist.push(three,singleX);//携带单牌小于2
                    return cardlist;
                }else{
                    model.putInSingle(singleX);
                    model.putInThree(three);
                }
            }
        }
        if(model.Double.length>0){
            cardlist=model.getDouble(0);//最小对子
            return cardlist;
        }
        if(model.SingleArr.length>0){
            cardlist.push(model.getSingle(0));//最小单牌
            return cardlist;
        }

        if(!cardlist || cardlist.length<=0){
            throw new Error("AI cant putOut card! bD_bottom not found card!");
        }
    }

    /*
    * 整理策略:尽量缩进牌组数量和质量
    * 三张数量+飞机数量》=1 && 三张数量+飞机数量《小单数量 出小单
    * 三张数量+飞机数量》=1 && 三张数量+飞机数量《对子数量+2 && 对子数量》2 出小对 不包含对2
    * 顺子数量>=2 有可管的顺子 出小顺
    * */
    private function bD_trimHand():Array
    {
        var cardlist:Array=[];
        var handgroupNum:Number=model.handGroupNum;

        var threeSum:Number=model.Three.length+model.AirplaneArr.length*2;
        var singleSum:Number=model.getSmallSingleNum();
        var doubleSum:Number=model.Double.length;
        if(threeSum>0 && singleSum>threeSum && singleSum-threeSum>=3){
            cardlist.push(model.getSingle(0));
            return cardlist;
        }
        else if(threeSum>0 && doubleSum>threeSum && doubleSum-threeSum>=2){
            cardlist=model.getDouble(0);
            return cardlist;
        }
        else if(model.Straight.length>=2){
            var maxNum:Number=model.Straight[0].cardValue;
            var slength:Number=model.Straight[0].length;

            var bStraight:Array=model.getStraight(maxNum,slength);
            if(bStraight){
                model.putInStraight(bStraight);
                cardlist=model.Straight[0];
                return cardlist;
            }
        }

        return null;
    }

    /*
    * 优先策略:仅剩两手牌,且牌型无关联
    * 优先出(依据长度)  飞机>连对>顺子>三张>对子>单张》炸弹
    * */
    private function bD_lastTwoHand():Array
    {
        var cardlist:Array=[];
        var handgroupNum:Number=model.handGroupNum;
        if(handgroupNum==2){
            if(model.AirplaneArr.length==1){
                cardlist.push(model.AirplaneArr[0]);
                model.AirplaneArr=[];
            }
            else if(model.DoubleStraight.length==1){
                cardlist.push(model.DoubleStraight[0]);
                model.DoubleStraight=[];
            }
            else if(model.Straight.length==1){
                cardlist.push(model.Straight[0]);
                model.Straight=[];
            }
            else if(model.Three.length==1){
                cardlist.push(model.Three[0]);
                model.Three=[];
            }
            else if(model.Double.length==1){
                cardlist.push(model.Double[0]);
                model.Double=[];
            }
            if(model.SingleArr.length==1){
                cardlist.push(model.SingleArr[0]);
                model.SingleArr=[];
            }
            else if(model.BoomArr.length==1){
                cardlist.push(model.BoomArr[0]);
                model.BoomArr=[];
            }
            return cardlist;
        }
        return null;
    }


    /*
    * 最后一手策略:能一次性出完得牌 直接出
    * 三带一 三袋二 飞机+双顺 飞机+双单
    * 任何只剩一种牌型
    * */
    private function bD_lastHand():Array
    {
        var cardlist:Array=[];
        var handgroupNum:Number=model.handGroupNum;

        //飞机
        if(model.AirplaneArr.length==1 && handgroupNum==3){
            var airPlane:Array=[];
            if(model.Double.length==2){
                airPlane=model.getAirplane(0);
                var doubleA:Array=model.getDouble(0);
                var doubleB:Array=model.getDouble(0);
                cardlist.push(airPlane,doubleA,doubleB);
                return cardlist;
            }
            else if(model.SingleArr.length==2){
                airPlane=model.getAirplane(0);
                var singleA:*=model.getSingle(0);
                var singleB:*=model.getSingle(0);
                cardlist.push(airPlane,singleA,singleB);
                return cardlist;
            }
        }

        //三带
        if(model.Three.length==1 && handgroupNum==2){
            var three:Array=[];
            if(model.Double.length==1){
                three=model.getThree(0);
                var doubleC:Array=model.getDouble(0);
                cardlist.push(three,doubleC);
                return cardlist;
            }
            else if(model.SingleArr.length==1){
                three=model.getThree(0);
                var singleC:*=model.getSingle(0);
                cardlist.push(three,singleC);
                return cardlist;
            }
        }

        //只剩一手的牌型
        if(handgroupNum==1){
            cardlist=lastoneHand();
            return cardlist;
        }

        return null;
    }

    /*
    * 最后一手牌
    * */
    private function lastoneHand():Array
    {
        var handgroupNum:Number=model.handGroupNum;
        var cardlist:Array=[];
        if(handgroupNum>1){
            return null;
        }

        if(model.SingleArr.length==1){
            cardlist.push(model.SingleArr[0]);
            model.SingleArr=[];
        }
        else if(model.Double.length==1){
            cardlist.push(model.Double[0]);
            model.Double=[];
        }
        else if(model.Three.length==1){
            cardlist.push(model.Three[0]);
            model.Three=[];
        }
        else if(model.Straight.length==1){
            cardlist.push(model.Straight[0]);
            model.Straight=[];
        }
        else if(model.DoubleStraight.length==1){
            cardlist.push(model.DoubleStraight[0]);
            model.DoubleStraight=[];
        }
        else if(model.AirplaneArr.length==1){
            cardlist.push(model.AirplaneArr[0]);
            model.AirplaneArr=[];
        }
        else if(model.BoomArr.length==1){
            cardlist.push(model.BoomArr[0]);
            model.BoomArr=[];
        }
        return cardlist;
    }

    /*
    * 基础跟牌策略:
    * 不对身份以及局面进行判断
    * 仅保证自己优先出完牌
    * */
    public function baseFollowDecision(deskObj:Object):Array
    {
        //简易策略-依据排列好的牌型出牌
        var deskpokerType:String=deskObj.pokerType;
        var deskpokerLength:Number=deskObj.pokerLength;
        var deskpokerMax:Number=deskObj.deskpokerMax;

        var threeArr:Array=[];
        var oneCard:*;
        var twoCard:Array=[];

        var handgroupNum:Number=model.handGroupNum;//手
        var cardlist:Array=[];
        if(deskpokerType==AIPokerConst.TYPE_Single){
            /*
            * 单张策略:手牌组少于6,可出大单（2,大小王）
            * */
            var selectCard:*=model.getSingle(deskpokerMax);
            if(!selectCard) return null;

            if(model.checkBigSingle(selectCard) && handgroupNum>6){
                model.putInSingle(selectCard);//放回
            }else {
                cardlist.push(selectCard);
            }
        }
        else if(deskpokerType==AIPokerConst.TYPE_Double){
            /*
            * 对子策略:手牌组少于5,可出对2
            * */
            cardlist=model.getDouble(deskpokerMax);
            if(!cardlist){
                if(handgroupNum>5){
                    return null;
                }
                cardlist=model.getTwoArr(2);//从单牌内查找对2
            }
        }
        else if(deskpokerType==AIPokerConst.TYPE_Three){
            /*
            * 三张策略:手牌组小于4,可出三张2
            * */
            cardlist=model.getThree(deskpokerMax);
            if(!cardlist){
                if(handgroupNum>4){
                    return null;
                }
                cardlist=model.getTwoArr(3);//从单牌内查找三张2
            }
        }
        else if(deskpokerType==AIPokerConst.TYPE_ThreeAndOne){
            /*
            * 三带一策略:
            * 无三张:牌组小于4,可出三张2
            * 正常三张:牌组小于3,可带大单
            * */
            threeArr=model.getThree(deskpokerMax);
            if(!threeArr){
                if(handgroupNum>4){
                    return null;
                }
                threeArr=model.getTwoArr(3);//从单牌内查找三张2
            }

            oneCard=model.getSingle(0);
            if(!oneCard){
                model.putInThree(threeArr);//放回3张
                return null;
            }

            if(model.checkBigSingle(oneCard) && handgroupNum>3){
                model.putInThree(threeArr);//放回3张
                model.putInSingle(oneCard);//放回
            }else {
                cardlist.push(threeArr,oneCard);
            }
        }
        else if(deskpokerType==AIPokerConst.TYPE_ThreeAndTwo){
            /*
            * 三带二策略:对子不能超过10
            * 无三张:牌组小于4,可出三张2
            * */
            threeArr=model.getThree(deskpokerMax);
            if(!threeArr){
                if(handgroupNum>4){
                    return null;
                }
                threeArr=model.getTwoArr(3);//从单牌内查找三张2
            }

            twoCard=model.getDouble(0);
            if(!twoCard){
                model.putInThree(threeArr);//放回3张
                return null;
            }

            if(twoCard[0].cardValue>AIPokerConst.CARD_ten && handgroupNum>3){
                model.putInDouble(twoCard);
                model.putInThree(threeArr);
            }else{
                cardlist.push(threeArr,twoCard);
            }
        }
        else if(deskpokerType==AIPokerConst.TYPE_Straight){
            /*
            * 顺子策略:强手,不进行二次分裂
            * */
            cardlist=model.getStraight(deskpokerMax,deskpokerLength);
        }
        else if(deskpokerType==AIPokerConst.TYPE_ThreeStraight){
            /*
            * 三连策略:强手,不进行拆分
            * */
            cardlist=model.getThreeStraight(deskpokerMax,deskpokerLength);
        }
        else if(deskpokerType==AIPokerConst.TYPE_DoubleStraight){
            /*
            * 连对策略:强手,不进行拆分
            * */
            cardlist=model.getDoubleStraight(deskpokerMax,deskpokerLength);//连对
        }
        else if(deskpokerType==AIPokerConst.TYPE_Airplane){
            /*
            * 飞机策略
            * 带两对:禁止带对2
            * 带两单:牌组小于4时,可带大单
            * */
            var airPlane:Array=model.getAirplane(deskpokerMax);//飞机

            if(!airPlane){
                return null;
            }

            if(deskpokerLength==10){
                //两对
                var twoA:Array=model.getDouble(0);
                var twoB:Array=model.getDouble(0);
                if(twoA && twoB){
                    cardlist.push(airPlane,twoA,twoB);
                }else{
                    model.putInAirPlane(airPlane);
                    model.putInDouble(twoA);
                    model.putInDouble(twoB);
                }
            }else{
                //两单
                var oneA:*=model.getSingle(0);
                var oneB:*=model.getSingle(0);
                if(oneA && oneB){
                    if(model.checkBigSingle(oneB) && handgroupNum>4){
                        model.putInAirPlane(airPlane);
                        model.putInDouble(oneA);
                        model.putInDouble(oneB);
                    }else{
                        cardlist.push(airPlane,oneA,oneB);
                    }
                }else{
                    model.putInAirPlane(airPlane);
                    model.putInDouble(oneA);
                    model.putInDouble(oneB);
                }
            }
        }
        else if(deskpokerType==AIPokerConst.TYPE_Boom){
            /*
            * 炸弹策略:牌组小于2时,可压炸
            * */
            if(handgroupNum<=2){
                cardlist=model.getBoom(deskpokerMax);//炸弹
            }
        }


        /*
        * 无可出牌型:
        * 牌型不为炸弹,牌组少于5时,可出炸弹/王炸
        * */
        if(!cardlist){
            if(deskpokerType!=AIPokerConst.TYPE_Boom && deskpokerType!=AIPokerConst.TYPE_JokerBoom){
                if(handgroupNum<5){
                    var boom:Array=model.getBoom(0);//炸弹-可出
                    if(!boom){
                        var jokerBoom:Array=model.getBoomArr();//王炸可出
                        cardlist.push(jokerBoom);
                    }else{
                        cardlist.push(boom);
                    }
                }
            }
        }

        return cardlist;
    }
























    public function lordDecision():void
    {

    }

    public function farmerDecision():void
    {

    }


    /*
    * 手里只剩一组牌:出完即赢
    * */
    private function oneHand():Boolean
    {

    }

    /*
    * 手里只有一组小牌,其他大牌:先出大的，再出小的
    * */
    private function allBig():Boolean
    {

    }

    /*
    * 敌人只有两张牌，我有绝对的大单，其他都是对子:出单，迫使对方出单
    * */
    private function foreEnemySingle():Boolean
    {

    }
    /*
    * 我下手是队友，只有一张牌，且我有<10的牌:出小单张
    * */
    private function letFirend():Boolean
    {

    }

    /*
    * 有些小的顺子、连对、飞机:先出这些
    * */
    private function smallAndLong():Boolean
    {

    }

    /*
    * 牌比较少的时候:优先出单张以外的牌
    * */
    private function fewPoke():Boolean
    {

    }

    /*
    * 地主一张牌时，我在他上手:尽量出其他牌型，否则从大往小
    * */
    private function enemyOnePokeAndPrve():Boolean
    {

    }
    /*
    * 地主一张牌时，我在他下手:如果有对子，而且单张很多，出非最小单张，期望和对家配合，否则同上
    * */
    private function enemyOnePokeAndNext():Boolean
    {

    }

    /*
    * 兜底的策略:小牌优先出
    * */
    private function smallFirst():Boolean
    {

    }

}
}
