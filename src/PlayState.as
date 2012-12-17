package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	public class PlayState  extends FlxState
	{
		
		
		private var mountain:FlxSprite;
		private var player:FlxSprite;
		
		private var state:int = 0;
		private const S_INIT:int = 0;
		private const S_PLAY:int = 1;
		
		override public function create():void 
		{
			
			mountain = new FlxSprite(0, 0);
			mountain.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
			add(mountain);
			
			player = new FlxSprite(0, 0);
			player.makeGraphic(2, 10, 0xffffffff);
			add(player);
			
			state = S_INIT;
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		private var done_drawing_init:Boolean = false;
		
		override public function update():void 
		{
			
			if (state == S_INIT) {
				if (FlxG.keys.justPressed("SPACE")) {
					state = S_PLAY;
				}
				super.update();
				return;
			}
			if (false == done_drawing_init && draw_mountain() == true) {
				done_drawing_init = true;
			} 
			
			change_bg_color();
			super.update();
		}
		
		private var mountain_len:int = 0;
		private var mountain_last_y:int = 0;
		private var mountain_color:uint = 0xFFaaaaaa;
		private function draw_mountain():Boolean {
			if (mountain_len >= FlxG.width) {
				return true;
			} 
			
			var y:int = 0;
			if (mountain_len == 0) {
				y = 97;
			} else {
				if (mountain_len <= FlxG.width / 7) {
					y = mountain_last_y - 3 + 6 * Math.random();
				} else if (mountain_len <=  2 *( FlxG.width / 7)) {
					y = mountain_last_y - (1.8 * Math.random());
				}  else if (mountain_len <= 3*( FlxG.width/ 7) ){
					y = mountain_last_y + 4 * Math.random();
				}  else if (mountain_len <= 4*( FlxG.width / 7)) {
					y = mountain_last_y - 2 + 4 * Math.random();
				}  else if (mountain_len <= 5*( FlxG.width / 7) ){
					y = mountain_last_y - (1.5 * Math.random());
				}  else if (mountain_len <= 6*( FlxG.width / 7)) {
					y = mountain_last_y + 4 * Math.random();
				} else {
					y = (mountain_last_y - 3) + 6 * Math.random();
				}
				if (y > 98) y = 98;
				if (y < 5) y = 8 -4*Math.random();
			}
			
			mountain.framePixels.setPixel32(mountain_len, y, mountain_color)
			var rest:int = y + 1;
			var alpha:uint = 255;
			while (rest < FlxG.height) {
				alpha = ((1 - rest / FlxG.height) * Math.random()) * 255;
				alpha = Math.min(255, alpha + 100 * Math.random());
				mountain.framePixels.setPixel32(mountain_len, rest, (alpha << 24) | (0x00FFFFFF & mountain_color));
				rest += 1;
			}
			mountain_len += 1;
			mountain_last_y = y;
			return false;
		}
		
		private var cur_blue:uint = 0;
		private var cur_red:uint = 0;
		private const max_red:uint = 40;
		private const max_blue:uint = 32;
		private var red_state:int = 0;
		private var blue_state:int = 0;
		private var red_rate:int = 1;
		private var blue_rate:int = 1;
		private var t_change_bg:Number = 0;
		private var tm_change_Bg:Number = 0.07;
		private function change_bg_color():void 
		{
			t_change_bg += FlxG.elapsed;
			if (t_change_bg > tm_change_Bg) {
				t_change_bg = 0;
			} else {
				return;
			}
			if (red_state == 0) {
				cur_red = Math.min(max_red, cur_red + red_rate);
				if (cur_red >= max_red) {
					red_state = 1;
				}
			} else {
				cur_red = cur_red - red_rate;
				if (cur_red > 255) cur_red = 0; // overflow oops lol
				if (cur_red == 0) {
					red_state = 0;
					red_rate = Math.max(1, uint(3 * Math.random()));
				}
			}
			
			
			if (blue_state == 0) {
				cur_blue = Math.min(max_blue, cur_blue+ blue_rate);
				if (cur_blue >= max_blue) {
					blue_state = 1;
				}
			} else {
				cur_blue = cur_blue - blue_rate;
				if (cur_blue > 255) cur_blue = 0; // overflow oops lol
				if (cur_blue == 0) {
					blue_state = 0;
					blue_rate = Math.max(1, uint(3 * Math.random()));
				}
			}
			
			FlxG.bgColor = 0xFF000000 | (cur_red << 16) | (cur_blue);
		}
	}

}