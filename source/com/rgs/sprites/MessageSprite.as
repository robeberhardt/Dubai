package com.rgs.sprites
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.text.SplitTextField;
	import com.rgs.rings.Connector;
	import com.rgs.utils.SoundManager;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import org.flintparticles.twoD.renderers.PixelRenderer;
	import org.osflash.signals.Signal;
	
	public class MessageSprite extends Sprite
	{
		public  var index						: int;
		private var _scale						: Number;
		public var bitmapHolder					: Sprite;
		private var _stf						: SplitTextField;
		private var glow						: GlowFilter;
		private var shadow						: DropShadowFilter;
		private var blackGlow					: GlowFilter;
		private var _busy						: Boolean;
		public var recycleSignal				: Signal;
		public var busySignal					: Signal;
		public var connectedTo					: Connector;
		public var killMeNowSignal				: Signal;
		
		private static const FULL_SCALE			: Number = 2;
		private static const ARRIVE_MULTIPLIER	: Number = 1;
		private static const DEPART_MULTIPLIER	: Number = 1;
		
		public function MessageSprite()
		{
			bitmapHolder = new Sprite();
			visible = false;
			alpha = 0;
			scale = FULL_SCALE;
			busy = false;
			recycleSignal = new Signal(MessageSprite);
			busySignal = new Signal(MessageSprite);
			killMeNowSignal = new Signal(MessageSprite);
			//myEmitter = new SpriteEmitter();
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		public function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			glow = new GlowFilter(0xffffff, 1, 15, 15, 5, 5);
			//blackGlow = new GlowFilter(0x000000, 0, 0, 5, 0, 0);
			shadow = new DropShadowFilter(0, 0, 0x000000, 0, 0, 0, 1, 5);
			filters = [glow, shadow];
			addChild(bitmapHolder);
			if (_stf) { addChild(_stf); }

//			renderer = new PixelRenderer( new Rectangle( 0, 0, 600, 300 ) );
//			renderer.addFilter(new BlurFilter(2, 2, 1));
//			renderer.addFilter( new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.95,0 ] ) );
//			renderer.addEmitter( myEmitter );
//			addChild( renderer );
		}
		
		override public function toString():String
		{
			return "[ MessageSprite ::: index=" + index + " ]"; 
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
			scaleX = scaleY = value;
		}
		
		public function get stf():SplitTextField
		{
			return _stf;
		}
		
		public function set stf(value:SplitTextField):void
		{
			_stf = value;
			_stf.x = 25;
			_stf.y = 25;
			trace("stf = " + _stf);
		}
		
		public function arrive():void
		{
			
			TweenMax.to(this, 5*ARRIVE_MULTIPLIER, {  autoAlpha: 1, ease:Cubic.easeIn });
//			TweenMax.to(this, 3*ARRIVE_MULTIPLIER, {  scale: 1.5, ease:Quad.easeOut });
			TweenMax.to(this, 8*ARRIVE_MULTIPLIER, { delay: 2, glowFilter:{ strength: 0, blurX: 0, blurY: 0} });
			TweenMax.to(this, 2*ARRIVE_MULTIPLIER, { delay: 2, dropShadowFilter:{alpha: .9, strength: 15, blurX: 4, blurY:4} }); 
			
			
			
//			TweenMax.to(this, 3*ARRIVE_MULTIPLIER, { autoAlpha: 1 });
//			TweenMax.to(this, 3*ARRIVE_MULTIPLIER, { scale: 1.5, ease:Cubic.easeOut });
//			TweenMax.to(this, 4*ARRIVE_MULTIPLIER, { delay: 1, glowFilter:{ strength: 0, blurX: 0, blurY: 0} });
//			TweenMax.to(this, 2*ARRIVE_MULTIPLIER, { delay: 2, dropShadowFilter:{alpha: .9, strength: 15, blurX: 4, blurY:4} }); 
//			
//			SoundManager.getInstance().playSound(SoundManager.ARRIVAL_SOUNDS);
//			
//			addEventListener(MouseEvent.CLICK, killMeNow);
			
			
		}
		
		public function blurAndTint():void
		{
			TweenMax.to(this, 4*ARRIVE_MULTIPLIER, { tint: 0x5f017a, glowFilter:{ strength: 5, blurX: 4, blurY: 4} });
		}
		
		
		public function depart():void
		{
//			TweenMax.to(this, .5, { alpha: 0, onComplete: recycle });
			TweenMax.to(this, .5*DEPART_MULTIPLIER, { alpha: 1 });
			TweenMax.to(this, 1*DEPART_MULTIPLIER, { delay: .5, autoAlpha: 0, onComplete: recycle });
			TweenMax.to(this, 1*DEPART_MULTIPLIER, { scaleX: 4, scaleY: .15, ease:Cubic.easeOut });
			TweenMax.to(this, 1*DEPART_MULTIPLIER, { glowFilter:{strength: 8, blurX: 15, blurY: 15} });
			
			SoundManager.getInstance().playSound(SoundManager.DEPARTURE_SOUNDS, 0, .25);
			
			removeEventListener(MouseEvent.CLICK, killMeNow);
			
		}
		
		private function killMeNow(e:MouseEvent):void
		{
			killMeNowSignal.dispatch(this);
		}
		
		private function recycle():void
		{
			trace("recycling " + this);
			visible = false;
			alpha = 0;
			scale = FULL_SCALE;
			busy = false;
//			glow.strength = 5;
//			glow.quality = 5;
//			glow.blurX = 15;
//			glow.blurY = 15;
			TweenMax.to(this, .25, { glowFilter: {alpha: 1, strength: 5, blurX: 15, blurY: 15}});
			TweenMax.to(this, .25, { dropShadowFilter: { alpha: 0, strength: 0, blurX: 0, blurY: 0}});
			recycleSignal.dispatch(this);
		}

		public function get busy():Boolean
		{
			return _busy;
		}

		public function set busy(value:Boolean):void
		{
			_busy = value;
			if (_busy)
			{
				busySignal.dispatch(this);
			}
		}
		
		

	}
}