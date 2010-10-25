package com.rgs.sprites
{
	import flash.display.Bitmap;
	
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.easing.Quadratic;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.twoD.actions.TweenToZone;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.GreyscaleZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	
	public class SpriteEmitter extends Emitter2D
	{
		private var _bitmap : Bitmap;
		private var gzone : GreyscaleZone;
		
		public function SpriteEmitter()
		{
			counter = new Blast(3000);
			addInitializer( new ColorInit( 0xFFFFFF00, 0xCC6600 ));
			addInitializer(new Lifetime( 6 ));
			addInitializer(new Position( new RectangleZone(0, 0, 600, 300)));
			
			addAction( new Age( Quadratic.easeInOut));
			gzone = new GreyscaleZone();
//			addAction( new TweenToZone( gzone));
			addAction(new TweenToZone ( new DiscZone(null, 200, 150)));
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}

		public function set bitmap(value:Bitmap):void
		{
			_bitmap = value;
			addAction(new TweenToZone(new GreyscaleZone(_bitmap.bitmapData, 0, 0)));
//			gzone.bitmapData = _bitmap.bitmapData;
			
		}

	}
}