/**This class is automatically generated by LayaAirIDE, please do not make any modifications. */
package ui {
	import laya.ui.*;
	import laya.display.*;
	import laya.display.Text;

	public class Playerview2UI extends Scene {
		public var headImg:Image;
		public var playerName:Text;
		public var goldNum:Text;
		public var scoreNum:Text;
		public var profession:Text;
		public var surplusCardNum:Text;
		public var seatNum:Text;

		public static var uiView:Object =/*[STATIC SAFE]*/{"type":"Scene","props":{"width":230,"height":300},"compId":2,"child":[{"type":"Image","props":{"y":30,"x":6,"var":"headImg","skin":"view/player/ico1.png"},"compId":5},{"type":"Text","props":{"y":11,"x":155,"width":49,"text":"名字:","strokeColor":"#000000","stroke":3,"height":19,"fontSize":18,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":10},{"type":"Text","props":{"y":75,"x":159,"width":48,"text":"座位:","strokeColor":"#000000","stroke":3,"height":20,"fontSize":18,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":11},{"type":"Text","props":{"y":10,"x":11.5,"width":49,"text":"身份:","strokeColor":"#000000","stroke":3,"height":20,"fontSize":18,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":12},{"type":"Text","props":{"y":162,"x":11.5,"width":49,"text":"金币:","strokeColor":"#000000","stroke":3,"height":20,"fontSize":18,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":14},{"type":"Text","props":{"y":190,"x":11,"width":49,"text":"积分:","strokeColor":"#000000","stroke":3,"height":20,"fontSize":18,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":15},{"type":"Text","props":{"y":38,"x":145.5,"width":75,"var":"playerName","text":"XX","strokeColor":"#000000","stroke":3,"height":18,"fontSize":18,"font":"SimHei","color":"#ffffff","align":"center","runtime":"laya.display.Text"},"compId":16},{"type":"Text","props":{"y":162,"x":62,"width":49,"var":"goldNum","text":"XX","strokeColor":"#000000","stroke":3,"height":20,"fontSize":18,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":17},{"type":"Text","props":{"y":190,"x":62,"width":49,"var":"scoreNum","text":"XX","strokeColor":"#000000","stroke":3,"height":20,"fontSize":18,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":18},{"type":"Text","props":{"y":10,"x":66,"width":49,"var":"profession","text":"XX","strokeColor":"#000000","stroke":3,"height":20,"fontSize":18,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":20},{"type":"Sprite","props":{"y":150,"x":115,"width":105,"texture":"poker/CardBack.png","height":141},"compId":22},{"type":"Text","props":{"y":245,"x":146,"width":44,"var":"surplusCardNum","text":"17","strokeColor":"#ff0400","stroke":3,"height":36,"fontSize":35,"font":"SimHei","color":"#ffffff","runtime":"laya.display.Text"},"compId":23},{"type":"Text","props":{"y":111,"x":142,"width":75,"var":"seatNum","text":"XX","strokeColor":"#000000","stroke":3,"height":18,"fontSize":18,"font":"SimHei","color":"#ffffff","align":"center","runtime":"laya.display.Text"},"compId":24}],"loadList":["view/player/ico1.png","poker/CardBack.png"],"loadList3D":[]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);

		}

	}
}