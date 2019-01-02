package client.src.constant {
public class GameEvent {
    public static var GAME_LOAD:String="GAME_LOAD";
    public static var GAME_LOBBY:String="GAME_LOBBY";//大厅
    public static var ENTER_ROOM:String="ENTER_ROOM";//进入房间

    public static var GAME_START:String="GAME_START";//开始游戏

    public static var DeskInit_SINGLE:String="DeskInit_SINGLE";//初始化牌桌-单机
    public static var DeskInit_NET:String="DeskInit_NET";//初始化牌桌-单机

    public static var PLAYER_READY:String="PLAYER_READY";//准备
    public static var PLAYER_RobLord:String="PLAYER_RobLord";//抢地主
    public static var PLAYER_RobScore:String="PLAYER_RobScore";//加倍

    public static var PLAYER_WANT_LORD:String="PLAYER_WANT_LORD";
    public static var PLAYER_CANCEL_LORD:String="PLAYER_CANCEL_LORD";
    public static var PLAYER_WANT_DOUBLE:String="PLAYER_WANT_DOUBLE";
    public static var PLAYER_CANCEL_DOUBLE:String="PLAYER_CANCEL_DOUBLE";
    public static var PLAYER_SHOWCARD:String="PLAYER_SHOWCARD";
    public static var PLAYER_PASS:String="PLAYER_PASS";
}
}
