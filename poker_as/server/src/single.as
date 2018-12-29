package
{
	import laya.cloud.ServerScriptBase;
	import laya.cloud.IServerScript;

	/**
	 * ...
	 * @author
	 */
	public class single extends ServerScriptBase implements IServerScript{
		/*[COMPILER OPTIONS:normal]*/
		public function oncreated():void{
			console.log("js create room");
			console.log("   name="+this.name);
			console.log("   master="+this.master);
			console.log("   fps="+this.fps);
			console.log("   duration="+this.duration);
			console.log("   usernum="+this.usernum);
		}

		public function onstart():void{
			console.log("js Room '"+this.name+"' Start!!");
		}

		public function onclose():void{
			console.log("js Room '"+this.name+"' Closed!!");
		}

		public function onuserin(userid:String, data:Object):void{

		}

		public function onuserout(userid:String):void{
			console.log("js Room '"+this.name+"' user logout, userid='"+userid+"'");
		}

		public function onuserevent(userid:String, key:String, val:String):void{
			console.log("js Room '"+this.name+"' recv user '"+userid+"' event, key='"+key+"' value='"+val+"'");
		}

		public function onupdate():void{
			
		}
	}

}