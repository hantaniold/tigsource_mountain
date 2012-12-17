package  
{
	import org.flixel.system.FlxPreloader;
	import Main;
	
	[SWF(width="750", height="300", backgroundColor="#000000")]
	public class Preloader extends FlxPreloader 
	{
		private var main:Main;
		public function Preloader() 
		{
			className = "Main";		  
			super();
		}
		
	}

}