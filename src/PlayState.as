package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	public class PlayState  extends FlxState
	{
		
		
		private var mountain:FlxSprite;
		private var player:FlxSprite;
		private var npc:FlxSprite;
		private var zone:FlxSprite;
		private var dropper:FlxSprite;
		private var foot_pt:Point = new Point;
		private var k:K;
		
		private var state:int = 0;
		private const S_INIT:int = 0;
		private const S_PLAY:int = 1;
		private const S_END:int = 2;
		
		private var s_heights:Array = new Array(FlxG.width);
		
		private var stars:FlxGroup = new FlxGroup(40);
		private var pluses:FlxGroup = new FlxGroup(8);
		
		override public function create():void 
		{
			
			add(stars);
			
			mountain = new FlxSprite(0, 0);
			mountain.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
			add(mountain);
			
			player = new FlxSprite(0, 0);
			player.acceleration.y = 80;
			player.makeGraphic(3, 10, 0xffffffff);
			player.exists = false;
			add(player);
			
			npc = new FlxSprite(FlxG.width - 10, FlxG.height - 12);
			npc.makeGraphic(3, 10, 0xffffffff);
			npc.exists = false;
			add(npc);
			
			zone = new FlxSprite;
			zone.makeGraphic(15, FlxG.height, 0xffffffff);
			zone.alpha = 0;
			add(zone);
			
			dropper = new FlxSprite;
			dropper.makeGraphic(1, 60, 0xffff0000);
			dropper.visible = false;
			add(dropper);
			
			for (var i:int = 0; i < 40; i++) {
				var star:FlxSprite = new FlxSprite(0, 0);
				if (Math.random() < 0.34) {
					star.makeGraphic(1, 1, 0xff00ff00);
					star.velocity.x = 12 + 12 * Math.random();
				} else if (Math.random() < 0.51) {
					star.makeGraphic(1, 1, 0xffff2222);
					star.velocity.x = 7 + 7 * Math.random();
				} else {
					star.makeGraphic(1, 1, 0xffffffff);
					star.velocity.x = 3 + 3 * Math.random();
				}
				star.alpha = Math.random();
				// Using this as an alpha rising or lowering state var
				if (Math.random() > 0.5) {
					star.alive = false;
				} else {
					star.alive = true;
				}
				star.x = FlxG.width * Math.random();
				star.y = 50 * Math.random();
				stars.add(star);
			}
			
			for (i = 0; i < pluses.maxSize; i++) {
				var plus:FlxSprite = new FlxSprite;
				plus.makeGraphic(3, 3, 0xffff5555);
				plus.framePixels.setPixel32(0, 0, 0x00000000);
				plus.framePixels.setPixel32(2, 0, 0x00000000);
				plus.framePixels.setPixel32(0, 2, 0x00000000);
				plus.framePixels.setPixel32(2, 2, 0x00000000);
				pluses.add(plus);
			}
			pluses.exists = false;
			add(pluses);
			
			
			k = new K;
			
			state = S_INIT;
		}
		
		override public function destroy():void 
		{
			super.destroy();
		}
		
		private var done_drawing_init:Boolean = false;
		
		override public function update():void 
		{
			// Move the stars, pulsate 'em
			for each (var star:FlxSprite in stars.members) {
				if (star.x > FlxG.width) {
					star.x = 0;
					star.y = 50 * Math.random();
				}
				
				if (star.alive) {
					if (star.alpha < 1) {
						star.alpha += 0.011;
					} else {
						star.alive = false;
					}
				} else {
					if (star.alpha > 0) {
						star.alpha -= 0.011;
					} else {
						star.alive = true;
					}
				}
			}
			if (state == S_INIT) {
				if (FlxG.keys.justPressed("SPACE")) {
					state = S_PLAY;
					player.x = 4;
					player.y = 20;
					zone.x = 2;
					zone.y = 0;
					player.exists = true;
					pluses.exists = true;
					npc.exists = true;
				}
				super.update();
				return;
			} else if (state == S_PLAY) {
				super.update();
				update_plus();
				update_player();
			} else if (state == S_END) {
				super.update();
				update_player();
				update_end();
			}
			
			// Initialize the pluses when drawing finished
			if (false == done_drawing_init && draw_mountain() == true) {
				done_drawing_init = true;
				for (var i:int = 0; i < pluses.maxSize; i++) {
					var plus:FlxSprite = pluses.members[i];
					plus.x = FlxG.width - 2 - i * 4;
					plus.y = s_heights[plus.x] - 5 - 10 * Math.random();
				}
			} 
			
			// Pulsate the zone where you can drop pluses
			if (pluses.getFirstAvailable() != null) {
				if (zone.alive) {
					zone.alpha += 0.0035;
					if (zone.alpha > 0.6) {
						zone.alive = false;
					}
				} else {
					zone.alpha -= 0.0035;
					if (zone.alpha <= 0.002) {
						zone.alive = true;
					}
				}
			} else {
				zone.alpha = 0;
			}
			
			change_bg_color();
			k.update();
		}
		
		private var end_ctr:int = 0;
		private var score:Number = 0;
		private var t_end:Number = 0;
		private var score_text:FlxText;
		
		// Shake and flash and shit
		private function update_end():void {
			spd = 0;
			if (end_ctr == 0) {
				FlxG.shake(0.03, 2);
				FlxG.flash(0xaaff2222, 1);
				for (var i:int = 0; i < FlxG.width; i++) {
					score += (FlxG.height - s_heights[i]);
					for (var j:int = s_heights[i]; j < FlxG.height; j++) {
						mountain.framePixels.setPixel32(i, j, (mountain.framePixels.getPixel32(i, j) | 0x00ff0000) & 0xffff0000);
					}
				}
				speed_up();
				end_ctr += 1;
			} else if (end_ctr == 1) {
				t_end += FlxG.elapsed;
				if (t_end > 1.5) {
					t_end = 0;
					FlxG.shake(0.04, 2);
					FlxG.flash(0xbbff1111, 1);
					speed_up();
					speed_up();
					end_ctr += 1;
				}
			} else if (end_ctr == 2) {
				t_end += FlxG.elapsed;
				if (t_end > 2) {
					FlxG.shake(0.06, 2);
					FlxG.flash(0xdaff0000, 1); 
					speed_up();
					speed_up();
					speed_up();
					t_end = 0;
					end_ctr += 1;
				}
			} else if (end_ctr == 3) {
				t_end += FlxG.elapsed;
				if (t_end > 2) {
					FlxG.shake(0.07, 2);
					FlxG.flash(0xffdd0000, 1);
					speed_up(); speed_up(); speed_up(); speed_up(); speed_up(); 
					end_ctr += 1;
					t_end = 0;
				}
			} else if (end_ctr == 4) {
				t_end += FlxG.elapsed;
				if (t_end > 1) {
					FlxG.shake(0.08, 2);
					FlxG.flash(0xff440000, 1);
					speed_up(); speed_up();
					end_ctr += 1;
					t_end = 0;
				}
			} else if (end_ctr == 5) {
				t_end += FlxG.elapsed;
				if (t_end > 1) {
					FlxG.shake(0.08, 2);
					FlxG.flash(0xff220000, 1);
					speed_up(); speed_up();
					end_ctr += 1;
					t_end = 0;
				}
			} else if (end_ctr == 6) {
				t_end += FlxG.elapsed;
				if (t_end > 1) {
					FlxG.shake(0.08, 2);
					FlxG.flash(0xff110000, 1);
					speed_up(); speed_up();
					end_ctr += 1;
					t_end = 0;
				}
			} else if (end_ctr == 7) {
				t_end += FlxG.elapsed;
				if (t_end > 1) {
					pluses.setAll("exists", false);
					for (var lol:int = 0; lol < stars.maxSize; lol++) {
						stars.members[lol].acceleration.y = 3 + 5 * Math.random();
					}
					FlxG.shake(0.08, 2);
					FlxG.flash(0xff000000, 4);
					speed_up(); speed_up();
					end_ctr += 1;
					t_end = 0;
					tm_change_Bg = 50000000;
					for each (var star:FlxSprite in stars.members) {
						star.velocity.x = 0;
					}
					FlxG.bgColor = 0xff000000;
					
					var percent:Number = score / (FlxG.height * FlxG.width);
					percent *= 100;
					
					score_text = new FlxText((FlxG.width / 2) - 80, 15, 500, percent.toFixed(2) + "%\n\nhappy 2012 holidays tigsource\n-sean hogan");
					score_text.alpha = 0;
					zone.visible = false;
					add(score_text);
				}
			} else if (end_ctr == 8) {
				score_text.alpha += 0.002;
				player.alpha -= 0.002;
				npc.alpha -= 0.002;
				mountain.velocity.y = 5;
			}
		}
		
		// updates pluses and the dropper
		private function update_plus():void {
			// Drop a plus if jump in zone
			if (player.overlaps(zone) && k.JP_JUMP) {
				var plus:FlxSprite = pluses.getFirstAvailable() as FlxSprite;
				if (plus != null) {
					plus.exists = true;
					plus.velocity.y = 40;
					plus.x = dropper.x + (dropper.width / 2);
					plus.y = 0;
					speed_down();
				}
			}
			
			// move dropper
			if (player.overlaps(zone) && zone.alpha > 0) {
				dropper.visible = true;
				if (dropper.alive) {
					dropper.velocity.x = spd;
					if (dropper.x > FlxG.width - dropper.width) {
						dropper.velocity.x = -spd;
						dropper.alive = false;
					}
				} else {
					dropper.velocity.x = -spd;
					if (dropper.x < 0) {
						dropper.velocity.x = spd;
						dropper.alive = true;
					}
				}
			} else {
				dropper.velocity.x = 0;
				dropper.visible = false;
			}
			
			// If a plus exists and touches the mountain
			// then it adds some pixels to the mountain
			for each (plus in pluses.members) {
				if (plus.velocity.y > 0) {
					if (plus.y > s_heights[int(plus.x)]) {
						plus.velocity.y = 0;
						var r:uint = 40 + 40 * Math.random();
						FlxG.flash(0xffff0000 | (r << 8) | (r), 0.3);
						
						var x:int = int(plus.x) - 10;
							
						for (var i:int = 0; i < 5; i++) {
							mountain.framePixels.setPixel32(x - 2, s_heights[x-2] - 1, 0xffff0000 | (r << 8) | r);
							
							mountain.framePixels.setPixel32(x - 1, s_heights[x-1] - 1, 0xffff0000 | (r << 8) | r);
							mountain.framePixels.setPixel32(x - 1, s_heights[x-1] - 2, 0xffff0000 | (r << 8) | r);
							mountain.framePixels.setPixel32(x - 1, s_heights[x-1] - 3, 0xffff0000 | (r << 8) | r);
							
							mountain.framePixels.setPixel32(x, s_heights[x] - 5, 0xffff0000 | (r << 8) | r);
							mountain.framePixels.setPixel32(x, s_heights[x] - 1, 0xffff0000 | (r << 8) | r);
							mountain.framePixels.setPixel32(x, s_heights[x] - 2, 0xffff0000 | (r << 8) | r);
							mountain.framePixels.setPixel32(x, s_heights[x] - 3, 0xffff0000 | (r << 8) | r);
							mountain.framePixels.setPixel32(x, s_heights[x] - 4, 0xffff0000 | (r << 8) | r);
							
							mountain.framePixels.setPixel32(x + 1, s_heights[x+1] - 1, 0xffff0000 | (r << 8) | r);
							mountain.framePixels.setPixel32(x + 1, s_heights[x+1] - 2, 0xffff0000 | (r << 8) | r);
							mountain.framePixels.setPixel32(x + 1, s_heights[x+1] - 3, 0xffff0000 | (r << 8) | r);
							
							mountain.framePixels.setPixel32(x + 2, s_heights[x+2] - 1, 0xffff0000 | (r << 8) | r);
							
							s_heights[x-2] -= 1;
							s_heights[x-1] -= 3;
							s_heights[x] -= 5;
							s_heights[x+1] -= 3;
							s_heights[x + 2] -= 1;
							
							for (var j:int = 0; j < 5; j++) {
								if (s_heights[x - 2 + j] <= 0) {
									state = S_END;
								}
							}
							x += 5;
							
							
						}
						
						plus.x = FlxG.width - 25 * Math.random();
						plus.y = s_heights[int(plus.x)] - 3 - 10 * Math.random();
					}
				}
			}
			
		}
		private var spd:int = 25;
		private var pluses_held:int = 0;
		private function update_player():void {
			
			// Player's foot point used to detect collision
			// with the "top" of each part of the mountain
		
			foot_pt.x = int(player.x + 1);
			foot_pt.y = int(player.y + player.height);
			
			if (k.RIGHT) {
				player.velocity.x = spd;
			} else if (k.LEFT) {
				player.velocity.x = -spd;
			} else {
				player.velocity.x = 0;
			}
			
			if (player.x < 0) {
				player.velocity.x = 0;
				player.x = 0;
			} else if (player.x > FlxG.width - player.width) {
				player.velocity.x = 0;
				player.x = FlxG.width - player.width;
			}
			
			if (player.y < -player.height) {
				player.velocity.y = 30;
				player.y = -player.height;
			}
			
			// Infinite jumping, I don't give a shit
			if (k.JP_JUMP) {
				player.velocity.y = -spd;
			}
			
			// "Collision detection"
			if (int(foot_pt.y) > s_heights[int(foot_pt.x)]) {
				foot_pt.y = s_heights[int(foot_pt.x)];
				player.y = foot_pt.y - player.height;
			}
			
			// Change state if you touch a plus
			for each (var plus:FlxSprite in pluses.members) {
				if (plus.exists && player.overlaps(plus)) {
					plus.exists = false;
					pluses_held += 1;
					FlxG.flash(0xffff7777, 0.5);
					speed_up();
				}
			}
			
		}
		
		// Move stars faster, move player faster, oscillate bg faster
		private function speed_up():void {
			tm_change_Bg -= 0.007;
			spd += 8;
			max_red = Math.min(max_red + 15, 255);
			for each (var star:FlxSprite in stars.members) {
				star.velocity.x *= 1.18;
			}
		}
		
		private function speed_down():void {
			tm_change_Bg += 0.007;
			spd -= 8;
			max_red -= 15;
			for each (var star:FlxSprite in stars.members) {
				star.velocity.x *= (1/1.18);
			}
		}
		private var mountain_len:int = 0;
		private var mountain_last_y:int = 0;
		private var mountain_color:uint = 0xFFaaaaaa;
		// Based on what vertical slice we're drawing,
		// make a flat, upward or downward slope of pixels
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
			s_heights[mountain_len] = y;
			// Fill in below the top of the mountain for a nice flaky effect
			var rest:int = y + 1;
			var alpha:uint = 255;
			while (rest < FlxG.height) {
				alpha = ((1 - rest / FlxG.height) * Math.random()) * 255;
				alpha = Math.min(255, alpha + 100 * Math.random() + 1);
				mountain.framePixels.setPixel32(mountain_len, rest, (alpha << 24) | (0x00FFFFFF & mountain_color));
				rest += 1;
			}
			mountain_len += 1;
			mountain_last_y = y;
			return false;
		}
		
		private var cur_blue:uint = 0;
		private var cur_red:uint = 0;
		private var max_red:uint = 40;
		private var max_blue:uint = 32;
		private var red_state:int = 0;
		private var blue_state:int = 0;
		private var red_rate:int = 1;
		private var blue_rate:int = 1;
		private var t_change_bg:Number = 0;
		private var tm_change_Bg:Number = 0.07;
		
		// nothing to see here, just oscillate the red and blue
		// channels of the bg at different rates
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