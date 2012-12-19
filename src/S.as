package  
{
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author Sean Hogan
	 */
	public class S 
	{
		[Embed(source = "../mp3/mountain.mp3")] public static const embed_song:Class;
		public static var song:FlxSound;
		
		[Embed(source = "../mp3/cross1.mp3")] public static const embed_cross1:Class;
		[Embed(source = "../mp3/cross2.mp3")] public static const embed_cross2:Class;
		[Embed(source = "../mp3/cross3.mp3")] public static const embed_cross3:Class;
		[Embed(source = "../mp3/cross4.mp3")] public static const embed_cross4:Class;
		[Embed(source = "../mp3/cross5.mp3")] public static const embed_cross5:Class;
		[Embed(source = "../mp3/cross6.mp3")] public static const embed_cross6:Class;
		[Embed(source = "../mp3/cross7.mp3")] public static const embed_cross7:Class;
		public static var cross1:FlxSound;
		public static var cross2:FlxSound;
		public static var cross3:FlxSound;
		public static var cross4:FlxSound;
		public static var cross5:FlxSound;
		public static var cross6:FlxSound;
		public static var cross7:FlxSound;
		
		[Embed(source = "../mp3/end.mp3")] public static const embed_end:Class;
		[Embed(source = "../mp3/fall.mp3")] public static const embed_Fall:Class;
		[Embed(source = "../mp3/hit1.mp3")] public static const embed_hit1:Class;
		[Embed(source = "../mp3/hit2.mp3")] public static const embed_hit2:Class;
		
		public static var hit1:FlxSound;
		public static var hit2:FlxSound;
		public static var fall:FlxSound;
		public static var end:FlxSound;
		
		public static function init():void {
			song = new FlxSound;
			song.loadEmbedded(embed_song, true);
			
			cross1 = new FlxSound;
			cross2 = new FlxSound;
			cross3 = new FlxSound;
			cross4 = new FlxSound;
			cross5 = new FlxSound;
			cross6 = new FlxSound;
			cross7 = new FlxSound;
			
			
			cross1.loadEmbedded(embed_cross1, false);
			cross2.loadEmbedded(embed_cross2, false);
			cross3.loadEmbedded(embed_cross3, false);
			cross4.loadEmbedded(embed_cross4, false);
			cross5.loadEmbedded(embed_cross5, false);
			cross6.loadEmbedded(embed_cross6, false);
			cross7.loadEmbedded(embed_cross7, false);
			
			cross1.volume = cross2.volume = cross3.volume = cross4.volume = cross5.volume = cross6.volume = cross7.volume = 0.5;
		
			
			hit1 = new FlxSound;
			hit2 = new FlxSound;
			fall = new FlxSound;
			end = new FlxSound;
			
			hit1.loadEmbedded(embed_hit1, false);
			hit2.loadEmbedded(embed_hit2, false);
			fall.loadEmbedded(embed_Fall, false);
			end.loadEmbedded(embed_end,true);
			
			
		}
		
		public static function change_cross_volume(delta:Number):void {
			var cur:Number = cross1.volume;
			cross1.volume = cross2.volume = cross3.volume = cross4.volume = cross5.volume = cross6.volume = cross7.volume = cross1.volume + delta;
		}
		public static function play_cross(y:Number):void {
			var maxht:Number = 50;
			if (y < maxht / 7) {
				cross1.play();
			} else if (y < 2 * maxht / 7) {
				cross2.play();
			} else if (y < 3 * maxht / 7) {
				cross3.play();
			} else if (y < 4 * maxht / 7) {
				cross4.play();
			} else if (y < 5 * maxht / 7) {
				cross5.play();
			} else if (y < 6 * maxht / 7) {
				cross6.play();
			} else if (y < 7 * maxht / 7) {
				cross7.play();
			}
		}
		
		public static function play_hit():void {
			if (Math.random() <= 0.5) {
				hit1.play();
			} else {
				hit2.play();
			}
		}
	}

}