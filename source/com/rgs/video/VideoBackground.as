package com.rgs.video
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.VideoLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class VideoBackground extends Sprite
	{
		private var bgVideo					: VideoLoader;
		
		public function VideoBackground()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bgVideo = new VideoLoader("assets/video/bluebg.flv", { name:"sparks1", onComplete: onLoadComplete, onFail: onLoadFail, autoPlay:true, repeat:-1, width:1280, height:768 } );
			addChild(bgVideo.content);
			bgVideo.load();
		}
		
		private function onLoadFail(e:LoaderEvent):void
		{
			trace("couldn't load " + e.target + ": " + e.target.text);
		}
		
		private function onLoadComplete(e:LoaderEvent):void
		{
			trace("bg video loaded...");
		}
	
	}
}