package  
{
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Sean Hogan
	 */
	public class K 
	{
		
		public var JP_RIGHT:Boolean = false;
		public var JP_LEFT:Boolean = false;
		public var RIGHT:Boolean = false;
		public var LEFT:Boolean = false;
		public var JP_JUMP:Boolean = false;
		
		public function update():void {
			
			JP_RIGHT = FlxG.keys.justPressed("RIGHT");
			JP_LEFT = FlxG.keys.justPressed("LEFT");
			RIGHT = FlxG.keys.RIGHT;
			LEFT = FlxG.keys.LEFT;
			JP_JUMP = FlxG.keys.justPressed("X");
			
		}
		
	}

}