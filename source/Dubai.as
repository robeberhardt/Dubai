package{	import com.freeactionscript.ParallaxField;	import com.greensock.TweenMax;	import com.greensock.easing.*;	import com.greensock.plugins.*;	import com.greensock.plugins.TweenPlugin;	import com.rgs.CallToAction;	import com.rgs.egg.Invader;	import com.rgs.fonts.FontLibrary;	import com.rgs.rings.Connector;	import com.rgs.rings.Particle;	import com.rgs.rings.Ring;	import com.rgs.rings.RingMaster;	import com.rgs.sprites.MessageSprite;	import com.rgs.sprites.SpriteFactory;	import com.rgs.sprites.SpriteQueue;	import com.rgs.txt.Message;	import com.rgs.txt.MessageLoader;	import com.rgs.utils.FramesManager;	import com.rgs.utils.KeyboardManager;	import com.rgs.utils.Logger;	import com.rgs.utils.SoundManager;	import com.rgs.video.Sparker;	import com.rgs.video.VideoBackground;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.TimerEvent;	import flash.geom.Point;	import flash.sampler.getInvocationCount;	import flash.text.Font;	import flash.utils.Timer;		import net.hires.debug.Stats;
		public class Dubai extends MovieClip	{				private var progressBar			: Sprite;				private var holder				: Sprite;				private var bg					: VideoBackground;				private var rm					: RingMaster;				private var starHolder			: MovieClip;		private var pfield				: ParallaxField;				private var stats				: Stats;		private var queueTimer			: Timer;		private var hookupTimer			: Timer;				private var currentSprite		: MessageSprite;		private var currentMessage		: Message;		//public var timeMultiplier		: Number = 1.0;				private var pick				: Connector;				private var egg				: Invader;		private var eggTimer		: Timer;		private var fm				: FramesManager;				private var mySparker		: Sparker;				public function Dubai()		{			alpha = 1;						TweenPlugin.activate([MotionBlurPlugin, DynamicPropsPlugin, TintPlugin]);			Logger.setMode(Logger.LOG_INTERNAL_ONLY);						bg = new VideoBackground();			addChild(new VideoBackground());			SpriteQueue.getInstance().emptySignal.add(onEmpty);			addChild(SpriteFactory.getInstance());						progressBar = new Sprite();			addChild(progressBar);			progressBar.graphics.beginFill(0x333333, 1);			progressBar.graphics.drawRect(-stage.stageWidth*.5, -6, stage.stageWidth, 12);			progressBar.graphics.endFill();			progressBar.x = stage.stageWidth * .5;;			progressBar.y = stage.stageHeight * .5;			progressBar.scaleX = 0;						holder = new Sprite();			addChild(holder);			holder.alpha = 0;						addChild(SoundManager.getInstance());			KeyboardManager.getInstance().soundSignal.add(onSoundKey);						MessageLoader.getInstance().loadedSignal.addOnce(onLoadComplete);			//MessageLoader.getInstance().load("long.plist");			MessageLoader.getInstance().progressSignal.add(onLoadProgress);			MessageLoader.getInstance().load("contents.plist");		}				private function onSoundKey():void		{			SoundManager.getInstance().toggleSound();		}				private function onLoadProgress(p:Number):void		{			progressBar.scaleX = p;		}				private function onLoadComplete():void		{			removeChild(progressBar);			MessageLoader.getInstance().progressSignal.removeAll();			init();		}				private function init():void		{			addChild(KeyboardManager.getInstance());						//			starHolder = new MovieClip();//			holder.addChild(starHolder);//			pfield = new ParallaxField();//			pfield.createField(starHolder, 10, 10, stage.stageWidth, stage.stageHeight, 100, 3, 1, .05);			//			egg = new Invader();//			holder.addChild(egg);//			egg.invasionOverSignal.add(onInvasionOver);//			KeyboardManager.getInstance().invaderSignal.add(onInvaderKey);//			eggTimer = new Timer(900000);//			eggTimer.addEventListener(TimerEvent.TIMER, onEggTimer);//			eggTimer.start();						rm = new RingMaster();			rm.scale = 1.5;			rm.x = Math.round(stage.stageWidth * .5);			rm.y = Math.round(stage.stageHeight * .5);			holder.addChild(rm);						KeyboardManager.getInstance().ringSignal.add(onRingKey);			KeyboardManager.getInstance().randomPositionsSignal.add(onRandomPositionsKey);			KeyboardManager.getInstance().originalPositionsSignal.add(onOriginalPositionsKey);			KeyboardManager.getInstance().killSignal.add(onKillKey);			KeyboardManager.getInstance().tweenAllSignal.add(onTweenAllToggle);			//			var cta:MovieClip = new CallToAction();//			addChild(cta);//			cta.x = 0//			cta.y = stage.stageHeight;						fm = new FramesManager();			addChild(fm);			KeyboardManager.getInstance().frameSignal.add(onFrameKey);			//			stats = new Stats();//			addChild(stats);									TweenMax.to(holder, 3, { alpha: 1 } );						//hookupTimer = new Timer(6000, 0);			hookupTimer = new Timer(11000, 0);			hookupTimer.addEventListener(TimerEvent.TIMER, hookup);						//queueTimer = new Timer(5000, 0);			queueTimer = new Timer(5000, 0);			queueTimer.addEventListener(TimerEvent.TIMER, mainLoop);						// sparks			mySparker = new Sparker();			addChild(mySparker);						// and away we go!			queueTimer.start();				}				private function onRandomPositionsKey():void		{			rm.randomPositions();		}						private function onOriginalPositionsKey():void		{			rm.originalPositions();		}				private function onFrameKey():void		{			fm.nextFrame();		}				private function onTweenAllToggle():void		{			rm.tweenAllRingsTogger();		}				private function onKillKey():void		{			trace("trying to kill random sprite... rm.usedConnectors = " + rm.usedConnectors.length);			if (rm.usedConnectors.length > 0)			{ 				rm.killRandomSprite();			}		}				private function mainLoop(e:TimerEvent):void		{			queueTimer.stop();			SpriteQueue.getInstance().nextSpriteSignal.addOnce(gotNextSprite);			SpriteQueue.getInstance().getNextAvailableSprite();			trace(rm.availableConnectors);			trace("\n\n");			trace(rm.usedConnectors);			trace("\n\n");		}				private function gotNextSprite(theSprite:MessageSprite)		{			theSprite.x = stage.stageWidth * .5;			theSprite.y = stage.stageHeight * .5;			holder.addChild(theSprite);			theSprite.arrive();			mySparker.playSparks();			currentSprite = theSprite;			hookupTimer.start();		}				private function onEmpty():void		{			trace("we're empty, starting timer...");			queueTimer.start();		}				private function hookup(e:TimerEvent):void		{			hookupTimer.stop();			trace("hookup - available connectors = " + rm.availableConnectors.length);			if (rm.availableConnectors.length == 0)			{ 				rm.killRandomSprite();			}						var hookupTime:Number = .5;						if (currentSprite.parent != holder)			{				var hookupPoint:Point = currentSprite.localToGlobal(new Point(currentSprite.x, currentSprite.y));				var newScale:Number = Ring(currentSprite.parent.parent).realScale;//				trace("newScale: " + newScale + ", from " + currentSprite.parent.parent);//				trace("\n---> newScale: " + newScale);				currentSprite.parent.removeChild(currentSprite);				currentSprite.scale = newScale;				currentSprite.x = hookupPoint.x;				currentSprite.y = hookupPoint.y;				holder.addChild(currentSprite);			}						pick = rm.getRandomConnector();			trace("pick is " + pick);			var targetRing:Ring = rm.getRingByIndex(pick.ring.index);//			var targetAlpha:Number = .4 + (targetRing.index*.15);						var targetAlpha:Number;						//			if (targetRing.index % 2 == 0)//			{//				targetAlpha = .8;////			}//			else//			{//				targetAlpha = .5////			}									switch (targetRing.index)			{				case 0 :					targetAlpha = .4;					break;								case 1 :					targetAlpha = .5;					break;								case 2 :					targetAlpha = .6;					break;								case 3 :					targetAlpha = .7;					break;								case 4 :					targetAlpha = .8;					break;								case 5 :					targetAlpha = .9;					break;			}									SoundManager.getInstance().playSound(SoundManager.HOOKUP_SOUNDS, hookupTime, .25);						TweenMax.to(currentSprite, hookupTime, { delay: .25, dynamicProps: {  x:getTargetPointX, y:getTargetPointY },				scale: targetRing.realScale*.6, alpha: targetAlpha,				motionBlur:{strength: 2, quality: 4}, ease:Cubic.easeInOut,				onComplete:attachToTarget, onCompleteParams: [currentSprite, pick]			});						TweenMax.to(currentSprite, hookupTime, { dropShadowFilter: { alpha: 0, strength: 0, blurX:0, blurY:0 } });			currentSprite.blurAndTint();					}				private function getTargetPointX():Number		{			return pick.parent.localToGlobal(new Point(pick.x, pick.y)).x;		}				private function getTargetPointY():Number		{			return pick.parent.localToGlobal(new Point(pick.x, pick.y)).y;		}				private function attachToTarget(what:*, where:Connector):void		{			where.addChild(what);			where.passenger = what;			what.x = what.y = 0;			what.scale = .6;			where.active = true;			what.connectedTo = where;			queueTimer.start();		}				private function onRingKey():void		{			rm.toggleRings();		}				/*		*   INVADER STUFF		*/				private function onInvaderKey():void		{			trace("INVASION");			eggTimer.stop();			egg.invade();		}				private function onEggTimer(e:TimerEvent):void		{			eggTimer.stop();			egg.invade();		}				private function onInvasionOver():void		{			trace("restarting egg timer");			eggTimer.start();		}					}}