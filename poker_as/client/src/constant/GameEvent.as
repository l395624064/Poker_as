package client.src.constant {
public class GameEvent {
    public static var GAME_LOAD:String="GAME_LOAD";
    public static var GAME_LOBBY:String="GAME_LOBBY";//大厅
    public static var ENTER_ROOM:String="ENTER_ROOM";//进入房间

    public static var GAME_START:String="GAME_START";//开始游戏

    public static var DeskInit_SINGLE:String="DeskInit_SINGLE";//初始化牌桌-单机

    public static var BroadCast_Ready_SINGLE:String="BroadCast_Ready_SINGLE";//广播准备
    //public static var BroadCast_GetPoker_SINGLE:String="BroadCast_GetPoker_SINGLE";
    //public static var BroadCast_RobLord_SINGLE:String="BroadCast_RobLord_SINGLE";
    public static var BroadCast_RobDouble_SINGLE:String="BroadCast_RobDouble_SINGLE";//广播喊分

    public static var PLAYER_READY_SINGLE:String="PLAYER_READY_SINGLE";//准备
    public static var READY_OVER_SINGLE:String="READY_OVER_SINGLE";
    public static var PLAYER_WANT_LORD_SINGLE:String="PLAYER_WANT_LORD_SINGLE";//抢地主
    public static var ROBLORD_OVER_SINGLE:String="ROBLORD_OVER_SINGLE";
    public static var PLAYER_WANT_DOUBLE_SINGLE:String="PLAYER_WANT_DOUBLE_SINGLE";//加倍
    public static var ROBDOUBLE_OVER_SINGLE:String="ROBDOUBLE_OVER_SINGLE";

    public static var DESK_LORDCARD_SINGLE:String="DESK_LORDCARD_SINGLE";//显示地主牌

    public static var ROUND_TIME_START:String="ROUND_TIME_START";//回合开始
    public static var ROUND_TIME_OVER:String="ROUND_TIME_OVER";





    public static var DeskInit_NET:String="DeskInit_NET";//初始化牌桌-联网
    public static var PLAYER_LOGINROOM_NET:String="PLAYER_LOGINROOM_NET";//玩家加入房间

    public static var PLAYER_READY_NET:String="PLAYER_READY_NET";
    public static var PLAYER_RobLord_NET:String="PLAYER_RobLord_NET";
    public static var PLAYER_RobScore_NET:String="PLAYER_RobScore_NET";

    public static var PLAYER_WANT_LORD_NET:String="PLAYER_WANT_LORD_NET";
    public static var PLAYER_WANT_DOUBLE_NET:String="PLAYER_WANT_DOUBLE_NET";
    public static var PLAYER_SHOWCARD_NET:String="PLAYER_SHOWCARD_NET";
    public static var PLAYER_PASS_NET:String="PLAYER_PASS_NET";
}
}
