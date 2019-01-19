package client.src.constant {
public class GameEvent {
    public static var GAME_LOAD:String="GAME_LOAD";
    public static var GAME_LOBBY:String="GAME_LOBBY";//大厅
    public static var ENTER_ROOM:String="ENTER_ROOM";//进入房间

    public static var GAME_START:String="GAME_START";//开始游戏

    public static var DeskInit_SINGLE:String="DeskInit_SINGLE";//初始化牌桌-单机

    public static var BroadCast_Ready_SINGLE:String="BroadCast_Ready_SINGLE";//广播准备
    public static var BroadCast_RobDouble_SINGLE:String="BroadCast_RobDouble_SINGLE";//广播喊分

    public static var PLAYER_RESETSTATE_SINGLE:String="PLAYER_RESETSTATE_SINGLE";//重置状态
    public static var PLAYER_READY_SINGLE:String="PLAYER_READY_SINGLE";//准备
    public static var READY_OVER_SINGLE:String="READY_OVER_SINGLE";
    public static var PLAYER_WANTLORD_SINGLE:String="PLAYER_WANTLORD_SINGLE";//抢地主
    public static var PLAYER_WANTDOUBLELORD_SINGLE:String="PLAYER_WANTDOUBLELORD_SINGLE";//加倍抢地主
    public static var ROBLORD_OVER_SINGLE:String="ROBLORD_OVER_SINGLE";
    public static var PLAYER_WANTSCORE_SINGLE:String="PLAYER_WANTSCORE_SINGLE";//加倍
    public static var ROBSCORE_OVER_SINGLE:String="ROBSCORE_OVER_SINGLE";

    public static var DESK_LORDCARD_SINGLE:String="DESK_LORDCARD_SINGLE";//显示地主牌
    public static var DESK_SHOWCARD_SINGLE:String="DESK_SHOWCARD_SINGLE";//显示桌面牌
    public static var DESK_ROUNDOVER_SINGLE:String="DESK_ROUNDOVER_SINGLE";//回合-结束

    public static var PLAYER_ROUNDREADY_SINGLE:String="PLAYER_ROUNDREADY_SINGLE";//游戏正式开始
    public static var PLAYER_ShowCardPassive_SINGLE:String="PLAYER_ShowCardPassive_SINGLE";//回合-被动出牌
    public static var PLAYER_ShowCardSelf_SINGLE:String="PLAYER_ShowCardSelf_SINGLE";//回合-主动出牌

    public static var PLAYER_ROUNDTIMEOVER_SINGLE:String="PLAYER_ROUNDTIMEOVER_SINGLE";//计时器-回合时间到
    public static var PLAYER_LORDTIMEOVER_SINGLE:String="PLAYER_LORDTIMEOVER_SINGLE";//计时器-叫地主时间到
    public static var PLAYER_ROBLORDTIMEOVER_SINGLE:String="PLAYER_ROBLORDTIMEOVER_SINGLE";//计时器-抢地主时间到
    public static var PLAYER_ROBSCORETIMEOVER_SINGLE:String="PLAYER_ROBSCORETIMEOVER_SINGLE";//计时器-抢分时间到





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
