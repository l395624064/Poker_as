package client.src.elem.AI {
import laya.utils.Browser;

public class AITools {
    public function AITools() {
    }

    private var _retainSingleArr:Array=[];//暂时保留的牌,2，大小王,剩余单牌

    private var _retainBoomArr:Array=[];//暂时保留的牌 炸弹,二维数组
    private var _retainAirplaneArr:Array=[];//暂时保留的牌 飞机,二维数组
    private var _retainStraight:Array=[];//暂时保留的顺子,二维数组
    private var _retainDoubleStraight:Array=[];//暂时保留的连对,二维数组
    private var _retainThree:Array=[];//暂时保留的三张,二维数组
    private var _retainDouble:Array=[];//暂时保留的对子,二维数组


    //如不出牌 则concat所有已拆分数组
    public var _tempArr:Array=[];//剩余待检测手牌
    private var pailArr:Array=[];//桶

    public var model:AIModel;
    private function setmodelPokerArr():void
    {
        model.SingleArr=_retainSingleArr;
        model.BoomArr=_retainBoomArr;
        model.AirplaneArr=_retainAirplaneArr;
        model.Straight=_retainStraight;
        model.DoubleStraight=_retainDoubleStraight;
        model.Three=_retainThree;
        model.Double=_retainDouble;
    }


    //拆分手牌
    public function splitCards():void
    {
        _retainSingleArr=[];
        splitJokerAndTwo();//拆分2和大小王
        //console.log("-_retainSingleArr:",_retainSingleArr);

        pailArr=[];
        setlistToPail();
        _retainBoomArr=[];
        splitBoom();//拆分炸弹
        console.log("-_retainBoomArr:",_retainBoomArr);
        _retainAirplaneArr=[];
        splitAirplane();//拆分飞机
        console.log("-_retainAirplaneArr:",_retainAirplaneArr);

        _retainStraight=[];
        splitStraight();//顺子分裂
        console.log("-_retainStraight:",_retainStraight);

        _retainDoubleStraight=[];
        splitDoubleStraight();//拆分连对
        console.log("-_retainDoubleStraight:",_retainDoubleStraight);

        _retainThree=[];
        splitThree();//拆分三张
        console.log("-_retainThree:",_retainThree);

        checkStraightExtend(); //延长顺子
        combineStraight();//合并顺子

        _retainDouble=[];
        splitlastCard();//拆分对子和单张
        console.log("-_retainDouble:",_retainDouble);
        sortCards(_retainSingleArr);
        console.log("-_retainSingleArr:",_retainSingleArr);

        //splitThreeAndBoom();
        trimNullArr();//整理二维数组

        setmodelPokerArr();//设置model数据
    }

    private function trimNullArr():void
    {
        checkNullArr(_retainBoomArr);
        checkNullArr(_retainAirplaneArr);

        checkNullArr(_retainStraight);
        checkNullArr(_retainDoubleStraight);
        checkNullArr(_retainThree);
        checkNullArr(_retainDouble);
    }


    private function setlistToPail():void
    {
        //桶排序
        pailArr=[[],[],[],
            [],[],[],[],[],[],[],[],[],[],[],[]];
        var nowValue:Number=0;
        for(var i:int=0;i<_tempArr.length;i++){
            nowValue=_tempArr[i].cardValue;
            pailArr[nowValue].push(_tempArr[i]);
        }
        console.log("-pailArr:",pailArr);
        console.log("-----------------------------");
    }


    /*
    * 拆分对子
    * */
    private function splitlastCard():void
    {
        for(var i:int=3;i<pailArr.length;i++){
            if(pailArr[i].length==2){
                var double:Array=pailArr[i].splice(0,2);//对子
                _retainDouble.push(double);
            }else if(pailArr[i].length==1){
                _retainSingleArr.push(pailArr[i].pop());//单张
            }
        }
    }


    /*
    * 三张(含飞机)+炸弹 可带单牌数量 - 剩余单张数量(大小王,2除外)>2
    * 且 单牌为递增序列
    * 且 三张(炸弹) 含有特定牌，则拆分三张(炸弹)，延长顺子
    * 顺子:7,8,9,10,11  炸弹:6666 单张3,4,5  result:3,4,5,6,7,8,9,10,11 And 666
    * 顺子:7,8,9,10,11  三张:666  单张3,4,5  result:3,4,5,6,7,8,9,10,11 And 66
    * */
    private function splitThreeAndBoom():void
    {
        var threeNum:Number=checklengthFromGroup(_retainThree);
        var airNum:Number=checklengthFromGroup(_retainAirplaneArr);
        //var boomNum:Number=checklengthFromGroup(_retainBoomArr);
        var bigNum:Number=threeNum+airNum*2;
        if(bigNum<=0)return;

        var sSingleNum:Number=checkSingleNum(_retainSingleArr,function (card:*):Boolean {
            if(card.cardValue<=AIPokerConst.CARD_A){
                return true;
            }
        });

        if(sSingleNum-bigNum<=2){
            return;
        }
    }


    /*
    * 合并顺子
    * 1.首尾相接的顺子连成一个
    * 2.相同的顺子变成连对
    * */
    private function combineStraight():void
    {
        if(_retainStraight.length<=1) return;
        var arrA:Array=[];
        var arrB:Array=[];
        var arrC:Array=[];
        for(var i:int=0;i<_retainStraight.length;i++){
            arrA=_retainStraight[i];
            if(arrA.length<=0) continue;
            for(var k:int=_retainStraight.length-1;k>=0;k--){
                arrB=_retainStraight[k];
                if(arrB.length<=0) continue;
                if(arrA==arrB){
                    continue;
                }else if(checkStraightSame(arrA,arrB)){
                    arrC=arrA.concat(arrB);
                    sortCards(arrC);
                    _retainDoubleStraight.push(arrC);
                    _retainStraight[i]=[];
                    _retainStraight[k]=[];
                    //console.log("-same straight combine to doubleStraight");
                }else if(checkStraightCombine(arrA,arrB)){
                    arrC=arrA.concat(arrB);
                    sortCards(arrC);
                    _retainStraight.push(arrC);
                    _retainStraight[i]=[];
                    _retainStraight[k]=[];
                    //console.log("-two straight combine to bigStraight");
                }
            }
        }
    }

    /*
    * 如果一个顺子的两端外面有一个对子，如果这个对子小于10,则并入顺子
    * 顺子:4,5,6,7,8  pari:3,3  result:3,4,5,6,7,8  and 3
    * */
    private function checkStraightExtend():void
    {
        var tempArr:Array=[];
        for(var i:int=0;i<_retainStraight.length;i++){
            tempArr=_retainStraight[i];
            if(tempArr.length<=0){
                continue;
            }
            extendStraight(pailArr,tempArr,function (value):Boolean {
                if(value>AIPokerConst.CARD_ten) return true;
                return false;
            });
            //console.log("-checkStraightExtend,:",i);
            _retainStraight[i]=tempArr;
        }
    }

    /*
    * pailArr找出所有的三张
    * */
    private function splitThree():void
    {
        var tempThree:Array=[];
        for(var i:int=3;i<pailArr.length;i++){
            if(pailArr[i].length>=3){
                var arrt:Array=[];
                arrt=pailArr[i].splice(0,pailArr[i].length);
                tempThree.push(arrt);
            }
        }
        _retainThree=tempThree;
    }

    /*
    * pailArr找出所有的连对
    * 查看所有的连对，如果长度超过3，且一端有三条，把此对子放回pailArr
    * */
    private function splitDoubleStraight():void
    {
        var tempDouble:Array=[];
        var nowNum:Number=1;
        var startIndex:Number=0;
        for(var i:int=3;i<pailArr.length-1;i++){
            if(pailArr[i].length<2){
                if(nowNum>=3){
                    var arrt:Array=[];
                    arrt=putoutMoreFromPail(pailArr,startIndex,nowNum,2);
                    tempDouble.push(arrt);
                    nowNum=1;
                    startIndex=0;
                }
                continue;
            }

            if(pailArr[i].length>=2 && pailArr[i+1].length>=2){
                nowNum++;
                if(nowNum==3){
                    startIndex=i-1;
                }
            }
        }

        if(tempDouble.length<=0) return;

        var arrs:Array=[];
        var deletArr:Array=[];
        var headIndex:Number=0;
        var tailIndex:Number=0;
        const mixNum:Number=1;
        for(var k:int=0;k<tempDouble.length;k++){
            //checkHeadAndTail(pailArr,tempThree[k],tempThree,1);
            arrs=tempDouble[k];
            headIndex=arrs[0].cardValue;
            tailIndex=arrs[arrs.length-1].cardValue;
            if(arrs.length==8){
                //右》优先保留大三张
                if(pailArr[tailIndex].length>=mixNum){
                    deletArr.push(arrs.pop());
                    deletArr.push(arrs.pop());
                }
                //左
                else if(pailArr[headIndex].length>=mixNum){
                    deletArr.push(arrs.shift());
                    deletArr.push(arrs.shift());
                }
                tempDouble[k]=arrs;
                putInToPail(pailArr,deletArr);//放回
            }else if(arrs.length>8){
                //右
                if(pailArr[tailIndex].length>=mixNum){
                    deletArr.push(arrs.pop());
                    deletArr.push(arrs.pop());
                }
                //左
                if(pailArr[headIndex].length>=mixNum){
                    deletArr.push(arrs.shift());
                    deletArr.push(arrs.shift());
                }
                tempDouble[k]=arrs;
                putInToPail(pailArr,deletArr);//放回
            }
        }
        _retainDoubleStraight=tempDouble;
    }


    /*
    * 顺子处理
    * 规则1-5
    * */
    private function splitStraight():void
    {
        var _tempStraight:Array=[];//待处理顺子

        //检出顺子
        var arr:Array=[];
        do{
            arr=splitStraightFromPail(pailArr);
            if(arr){
                _tempStraight.push(arr);
            }
        }while (arr)

        if(_tempStraight.length<=0){
            return;
        }
        //console.log("-_tempStraight:",_tempStraight);

        var startTime:Number;//起始时间
        const totalTime:Number=1000;//总时长
        var resultNum:Number=0;//resultNum=5:顺子检测完毕
        for(var k:int=0;k<_tempStraight.length;k++){
            //console.log("-for",k);
            startTime=Browser.now();
            while (resultNum<5){
                resultNum=0;
                if(!stepone(pailArr,_tempStraight[k],_tempStraight)){
                    //console.log("-stepone:");
                    resultNum++;
                }
                if(!steptwo(pailArr,_tempStraight[k],_tempStraight)){
                    //console.log("-steptwo:");
                    resultNum++;
                }
                if(!stepthree(pailArr,_tempStraight[k],_tempStraight)){
                    //console.log("-stepthree:");
                    resultNum++;
                }
                if(!stepfour(pailArr,_tempStraight[k],_tempStraight)){
                    //console.log("-stepfour:");
                    resultNum++;
                }
                if(!stepfive(pailArr,_tempStraight[k],_tempStraight)){
                    //console.log("-stepfive:");
                    resultNum++;
                }

                if(Browser.now()-startTime>=totalTime){
                    console.log("-_tempStraight time out!")
                    break;
                }
                //console.log("---------------while",resultNum);
            }
            resultNum=0;
            //重复检测1-5,直到返回5false,则进行下一轮顺子检测
            /*
            stepone(pailArr,_tempStraight[k],_tempStraight);
            steptwo(pailArr,_tempStraight[k],_tempStraight);
            stepthree(pailArr,_tempStraight[k],_tempStraight);
            stepfour(pailArr,_tempStraight[k],_tempStraight);
            stepfive(pailArr,_tempStraight[k],_tempStraight);
            */
        }
        _retainStraight=_tempStraight;
    }




    /*
    * 顺子如果盖住对子、三张、连对,如果发现打散牌组数更少，则打散
    * 顺子:78910JQK  pari:7,9,J,J,K  result:顺子退回pailArr
    * */
    private function stepfour(pailArr:Array,arr:Array,tempArr:Array):Boolean
    {
        if(arr.length<=0) return false;
        const stralength:Number=arr.length;
        var tempIndex:Number=tempArr.indexOf(arr);

        var lostPailNum:Number=checkHaveFromPail(pailArr,arr[0].cardValue,arr.length);
        var ifSingleNum:Number=stralength-lostPailNum;
        //如当前straight放回pailArr,剩余得单张数<当前pailArr含有straight的单张数
        if(ifSingleNum<lostPailNum){
            tempArr[tempIndex]=[];
            putInToPail(pailArr,arr);//放回
            arr=[];
            return true;
        }
        return false;
    }



    /*
    * 顺子拆出两头的对子
    * 顺子:345678  pari:8 or 3  result:34567,88 or 45678,33
    * 顺子:3456789  pari:8 || 3  result:同stepthree
    * */
    private function stepfive(pailArr:Array,arr:Array,tempArr:Array):Boolean
    {
        if(arr.length<=5) return false;//不满足条件
        var result:Boolean=checkHeadAndTail(pailArr,arr,tempArr,1);
        return result;
    }

    /*
    * 顺子拆出三张
    * 顺子:345678  pari:88  result:34567 888
    * 顺子:345678  pari:33  result:45678 333
    * */
    private function stepthree(pailArr:Array,arr:Array,tempArr:Array):Boolean
    {
        if(arr.length<=5) return false;//不满足条件
        var result:Boolean=checkHeadAndTail(pailArr,arr,tempArr,2);
        return result;
    }

    private function checkHeadAndTail(pailArr:Array,arr:Array,tempArr:Array,mixNum:Number):Boolean
    {
        //if(arr.length<=5) return false;
        var headIndex:Number=arr[0].cardValue;
        var tailIndex:Number=arr[arr.length-1].cardValue;
        var tempIndex:Number=tempArr.indexOf(arr);

        var singArr:Array=[];
        var checkHave:Boolean;
        if(arr.length==6){
            //左
            if(pailArr[headIndex].length>=mixNum){
                checkHave=true;
                singArr.push(arr.shift());
            }
            //右
            else if(pailArr[tailIndex].length>=mixNum){
                checkHave=true;
                singArr.push(arr.pop());
            }
            tempArr[tempIndex]=arr;
            putInToPail(pailArr,singArr);//放回
            if(checkHave) return true;
        }else {
            if(pailArr[headIndex].length>=mixNum){
                checkHave=true;
                singArr.push(arr.shift());//左
            }
            if(pailArr[tailIndex].length>=mixNum){
                checkHave=true;
                singArr.push(arr.pop());//右
            }
            tempArr[tempIndex]=arr;
            putInToPail(pailArr,singArr);//放回
            if(checkHave) return true;
        }
        return false;
    }


    /*
    *顺子拆出连对
    * 总长度只能是8或者9。>=10时，已转换为顺子，不可能存在连对
    * 345678910 长度8  result: XXX678910 or 34567XXX
    * 34567891011 长度9   result: XXX67891011  XXXX7891011 or  345678XXX 34567XXXX
    * */
    private function steptwo(pailArr:Array,arr:Array,tempArr:Array):Boolean
    {
        var lastNum:Number=checklengthFromPail(pailArr);
        const doubleNeed:Number=3;
        if(arr.length<8 || arr.length>=10 || lastNum<doubleNeed){
            return false;
        }

        var tempIndex:Number=tempArr.indexOf(arr);

        //左3
        var headNeed:Array=[];
        for(var i:int=0;i<3;i++){
            headNeed.push(arr[i].cardValue);
        }

        //右3
        var tailNeed:Array=[];
        for(i=arr.length-3;i<arr.length;i++){
            tailNeed.push(arr[i].cardValue);
        }


        var index:Number;
        //左3》是否向右扩展一格
        var headBo:Boolean=checkAddFromPail(pailArr,headNeed[0],headNeed[0]+headNeed.length);
        if(headBo){
            if(arr.length==9){
                index=arr[3].cardValue;
                if(pailArr[index].length>0){
                    tempArr[tempIndex]=arr.splice(4,5);
                }else{
                    tempArr[tempIndex]=arr.splice(3,6);
                }
            }else{
                tempArr[tempIndex]=arr.splice(3,5);
            }
            putInToPail(pailArr,arr);//放回
            return true;
        }

        //右3》是否向左扩展一格
        var tailBo:Boolean=checkAddFromPail(pailArr,tailNeed[0],tailNeed[0]+tailNeed.length);
        if(tailBo){
            if(arr.length==9){
                index=arr[arr.length-4].cardValue;
                if(pailArr[index].length>0){
                    tempArr[tempIndex]=arr.splice(0,5);
                }else{
                    tempArr[tempIndex]=arr.splice(0,6);
                }
            }else {
                tempArr[tempIndex]=arr.splice(0,5);
            }
            putInToPail(pailArr,arr);//放回
            return true;
        }

        return false;
    }




    /*
    * 检测pail中是否包含 indexArr元素 的三连
    * */
    /*
    private function getThreeFromPail(pailArr:Array,indexArr:Array):Array
    {
        //从pailArr内检出包含indexArr索引的元素
        const mixNum:Number=3;
        var tempArr:Array=[];
        var index:Number;
        for(var i:int=0;i<indexArr.length-3;i++){
            index=indexArr[i];
            if(pailArr[index].length<=0){
                return null;
            }else{
                tempArr.push(pailArr[index].pop());
            }
        }

        if(tempArr.length==indexArr.length){
            return tempArr;//完全匹配
        }else if(tempArr.length<mixNum){
            putInToPail(pailArr,tempArr);//不符合条件放回
            return null;
        }

        //检测 tempArr 是否包含三连
        var starIndex:Number=-1;
        var nowNum:Number=1;
        for(i=0;i<tempArr.length-2;i++){
            if(tempArr[i].cardValue==tempArr[i+1].cardValue-1){
                nowNum++;
                if(nowNum==mixNum){
                    starIndex=i-1;
                }
            }else{
                nowNum=1;
            }
        }

        if(starIndex>=0){
            var threeArr:Array=tempArr.splice(starIndex,3);
            putInToPail(pailArr,tempArr);
            return threeArr;
        }
        putInToPail(pailArr,tempArr);
        return null;
    }*/



    /*
    * 顺子分裂
    * 345678910，pail:6,7， result:34567,678910
    * */
    private function stepone(pailArr:Array,arr:Array,tempArr:Array):Boolean
    {
        if(arr.length<=5 || arr.length>9){
            return false;
        }

        var needArr:Array=[];
        var starIndex:Number=0;
        var tempIndex:Number=tempArr.indexOf(arr);
        if(tempIndex<0) throw new Error("stepone arr not found in tempArr");
        if(6==arr.length){
            starIndex=1;
            needArr=[arr[1].cardValue,arr[2].cardValue,arr[3].cardValue,arr[4].cardValue];
        }
        else if(7==arr.length){
            starIndex=2;
            needArr=[arr[2].cardValue,arr[3].cardValue,arr[4].cardValue];
        }
        else if(8==arr.length){
            starIndex=3;
            needArr=[arr[3].cardValue,arr[4].cardValue];
        }
        else if(9==arr.length){
            starIndex=4;
            needArr=[arr[4].cardValue];
        }

        var index:Number=0;
        for(var i:int=0;i<needArr.length;i++){
            index=needArr[i];
            if(pailArr[index].length<=0){
                return false;
            }
        }

        console.log("-get new straight")
        var startNum:Number=arr[starIndex].cardValue;
        var arra:Array=arr.splice(0,5);
        var arrb:Array=arr.splice(0,arr.length);
        var deletArr:Array=putoutFromPail(pailArr,startNum,needArr.length);
        arrb=deletArr.concat(arrb);

        extendStraight(pailArr,arrb);
        tempArr.push(arrb);
        extendStraight(pailArr,arra);
        tempArr[tempIndex]=arra;

        return true;
    }

    /*
    *延长顺子首尾
    * */
    private function extendStraight(pailArr:Array,arr:Array,checkValuefunc:Function=null):void
    {
        var headValue:Number=0;
        var headEnd:Boolean=checkHeadEnd(arr[0].cardValue);
        while(!headEnd){
            headValue=arr[0].cardValue;
            if(pailArr[headValue-1].length>0){
                if(checkValuefunc && checkValuefunc(headValue)){
                    continue;
                }
                arr.unshift(pailArr[headValue-1].pop());
                if(checkHeadEnd(arr[0].cardValue)){
                    headEnd=true;
                }
            }else{
                headEnd=true;
            }
        }


        var tailValue:Number=0;
        var tailEnd:Boolean=checkTailEnd(arr[arr.length-1].cardValue);
        while (!tailEnd){
            tailValue=arr[arr.length-1].cardValue;
            if(pailArr[tailValue+1].length>0){
                if(checkValuefunc && checkValuefunc(headValue)){
                    continue;
                }
                arr.push(pailArr[tailValue+1].pop());
                if(checkTailEnd(arr[arr.length-1].cardValue)){
                    tailEnd=true;
                }
            }else{
                tailEnd=true;
            }
        }
    }


    private function checkHeadEnd(cardValue:Number):Boolean
    {
        if(cardValue<=AIPokerConst.CARD_three) return true;
        return false;
    }
    private function checkTailEnd(cardValue:Number):Boolean
    {
        if(cardValue>=AIPokerConst.CARD_A) return true;
        return false;
    }


    /*
    private function getMaxStraight(cardlist:Array,mixNum:Number=3):Array
    {
        var tempArr:Array=[];
        do{
            var straArr:Array=splitStraightFromPail(cardlist,mixNum);
            if(straArr && straArr.length>tempArr.length){
                tempArr=straArr;
            }
        }while (!straArr)

        if(tempArr.length<=0) return null;
        return tempArr;
    }*/

    /*
    * 拆出所有顺子，暂时忽视连对
    * 二维数组保存
    * */
    private function splitStraightFromPail(pailArr:Array):Array
    {
        var nowNum:Number=1;
        const mixNum:Number=5;
        var startIndex:Number=0;
        var straightArr:Array=[];

        for(var i=0;i<pailArr.length-1;i++){
            if(pailArr[i].length<=0){
                nowNum=1;
                continue;
            }
            else if(pailArr[i].length>0 && pailArr[i+1].length>0){
                nowNum++;
                if(nowNum==mixNum) startIndex=i-3;
                if(i+1==pailArr.length-1 && nowNum>=mixNum){
                    straightArr=putoutFromPail(pailArr,startIndex,nowNum);
                    return straightArr;
                }
            }
            else{
                if(nowNum>=mixNum){
                    straightArr=putoutFromPail(pailArr,startIndex,nowNum);
                    nowNum=1;
                    return straightArr;
                }
            }
        }
        return null;
    }

    /*
    * 尽可能长
    * 如超过mixNum ,且首尾存在三张,则拆出三张
    * */
    /*
    private function splitDoubleStraight(pailArr:Array,doubleArr:Array):void
    {
        var startIndex:Number=0;
        var nowNum:Number=1;
        const mixNum:Number=3;//符合最小连对即可
        for(var i:int=0;i<pailArr.length;i++){
            if(pailArr[i].length<=0){
                nowNum=1;
                continue;
            }

            if(pailArr[i].length>0 && pailArr[i+1].length>0){
                nowNum++;
                if(nowNum==mixNum){
                    startIndex=i-mixNum+1;
                }
            }
        }

        if(nowNum<mixNum){
            return;
        }
    }
    */




    //检出剩余牌
    private function getcardsFromPail(arr:Array):Array
    {
        var cardsArr:Array=[];
        var nowArr:Array=[];
        for(var i:int=0;i<arr.length;i++){
            nowArr=arr[i];
            for(var j:int=0;j<nowArr.length;j++){
                cardsArr.push(nowArr[j]);
            }
        }

        return cardsArr;
    }

    //检测剩余牌数量
    private function checklengthFromPail(arr:Array):Number
    {
        var _arr:*;
        var _num:Number=0;
        for(var i:int=0;i<arr.length;i++){
            _arr=arr[i];
            if(_arr is Array){
                _num+=_arr.length;
            }else{
                _num++;
            }
        }
        return _num;
    }

    /*
    * 检测组数量
    * */
    private function checklengthFromGroup(arr:Array):Number
    {
        var _arr:Array;
        var _num:Number=0;
        for(var i:int=0;i<arr.length;i++){
            _arr=arr[i];
            if(_arr.length>0){
                _num++;
            }
        }
        return _num;
    }

    /*
    * 检测数组内 符合func的单牌数量
    * */
    private function checkSingleNum(arr:Array,func:Function):Number
    {
        var _num:Number=0;
        for(var i:int=0;i<arr.length;i++){
            if(func(arr[i])){
                _num++;
            }
        }
        return _num;
    }

    /*
    * 获得指定牌
    * */
    private function getSingleFromArr(arr:Array,func:Function):Array
    {
        var _arr:Array=[];
        for(var i:int=0;i<arr.length;i++){
            if(func(arr[i])){
                _arr.push(arr[i]);
            }
        }
        return _arr;
    }



    //检测 含有指定数组元素得pail数量
    private function checkHaveFromPail(pailArr:Array,startNum:Number,straingtNum:Number):Number
    {
        var num:Number=0;
        for(var i:int=startNum;i<startNum+straingtNum;i++){
            if(pailArr[i].length>0){
                num++;
            }
        }
        return num;
    }


    //桶单个拿出
    private function putoutFromPail(pailArr:Array, startNum:Number, straingtNum:Number):Array
    {
        var arr:Array=[];
        for(var i:int=startNum;i<startNum+straingtNum;i++){
            arr.push(pailArr[i].pop());
        }
        return arr;
    }

    //桶内拿出指定数量
    private function putoutMoreFromPail(pailArr:Array, startNum:Number, straingtNum:Number,putoutNum:Number):Array
    {
        var arr:Array=[];
        for(var i:int=startNum;i<startNum+straingtNum;i++){
            arr=arr.concat(pailArr[i].splice(0,putoutNum));
        }
        return arr;
    }

    //桶放入
    private function putInToPail(pailArr:Array,putInArr:Array):void
    {
        var index:Number;
        for(var i:int=0;i<putInArr.length;i++){
            index=putInArr[i].cardValue;
            pailArr[index].push(putInArr[i]);
        }
        putInArr=[];
    }


    //是否为递增
    private function checkAddFromPail(pailArr:Array,startIndex:Number,endIndex:Number,getArr:Boolean=false):*
    {
        for(var i:int=startIndex;i<endIndex;i++){
            if(pailArr[i].length<=0){
                return false;
            }
        }
        if(!getArr) return true;

        var tempArr:Array=[];
        for(i=startIndex;i<endIndex;i++){
            tempArr.push(pailArr[i].pop());
        }
        return tempArr;
    }

    //是否为递增
    private function checkAddFromlist(cardlist:Array):Boolean
    {
        for(var i:int=0;i<cardlist.length-1;i++){
            if(cardlist[i].cardValue!=cardlist[i+1].cardValue-1){
                return false;
            }
        }
        return true;
    }

    //检测两个顺子是否相同
    private function checkStraightSame(arra:Array,arrb:Array):Boolean
    {
        if(arra.length!=arrb.length) return false;
        for(var i:int=0;i<arra.length;i++){
            if(arra[i].cardValue!=arrb[i].cardValue){
                return false;
            }
        }
        return true;
    }

    //检测两个顺子能否合并
    private function checkStraightCombine(arra:Array,arrb:Array):Boolean
    {
        var heada:Number=arra[0].cardValue;
        var taila:Number=arra[arra.length-1].cardValue;
        var headb:Number=arrb[0].cardValue;
        var tailb:Number=arrb[arrb.length-1].cardValue;

        if(taila==headb+1 || tailb==heada+1){
            return true;
        }
        return false;
    }


    //小-大
    private function sortCards(arr:Array):void
    {
        arr.sort(function (a,b):Number {
            return (a.cardValue>b.cardValue)? 1:-1;
        })
    }

    /*
        * 清除空数组
        * */
    private function checkNullArr(arr:Array):void
    {
        for(var i:int=arr.length-1;i>=0;i--){
            if(arr[i].length<=0){
                arr.splice(i,1);
            }
        }
    }





    private function splitJokerAndTwo():void
    {
        var card:*;
        for(var i:int=_tempArr.length-1;i>=0;i--){
            card=_tempArr[i];
            if(card.cardValue==AIPokerConst.CARD_BJoker || card.cardValue==AIPokerConst.CARD_SJoker){
                _tempArr.splice(i,1);
                _retainSingleArr.push(card);
            }
            else if(card.cardValue==AIPokerConst.CARD_TWO){
                _tempArr.splice(i,1);
                _retainSingleArr.push(card);
            }
        }
    }

    private function splitBoom():void
    {
        for(var i:int=0;i<pailArr.length;i++){
            if(pailArr[i].length>=4){
                var boom:Array=pailArr[i].splice(0,4);
                _retainBoomArr.push(boom);
            }
        }
    }

    private function splitAirplane():void
    {
        for(var i:int=0;i<pailArr.length-1;i++){
            if(pailArr[i].length>=3 && pailArr[i+1].length>=3){
                var airplane:Array=pailArr[i].splice(0,3);
                airplane=airplane.concat(pailArr[i+1].splice(0,3));
                _retainAirplaneArr.push(airplane);
            }
        }
    }

}
}
