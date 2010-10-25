package com.rgs.video
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.core.LoaderCore;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Sparker extends Sprite
	{
		private var queue					: LoaderMax;
		private var sparks1					: VideoLoader;
		
		public function Sparker()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
						
			queue = new LoaderMax( { name:"main", onFail:onLoadFail, onComplete:onLoadComplete } );
			sparks1 = new VideoLoader("assets/video/sparks-purple.flv", { name:"sparks1", autoPlay:false, width: 1280, height: 768 } );
			addChild(sparks1.content);
			queue.append(sparks1);
			queue.load();
		}
		
		private function onLoadFail(e:LoaderEvent):void
		{
			trace("couldn't load " + e.target + ": " + e.target.text);
		}
		
		private function onLoadComplete(e:LoaderEvent):void
		{
			trace("sparks video loaded...");
		}
		
		public function playSparks():void
		{
			sparks1.gotoVideoTime(0, true, true);
//			sparks1.playVideo();
		}
	}
}