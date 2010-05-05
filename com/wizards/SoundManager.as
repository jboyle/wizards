package com.wizards
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class SoundManager extends EventDispatcher
	{
		static public var MANAGER:SoundManager;
		
		private var _sounds:Object;
		public function SoundManager(target:IEventDispatcher=null)
		{
			super(target);
			
			_sounds = new Object()
			
			MANAGER = this;
		}
		
		public function loadSound(name:String, path:String):WSound{
			var sound:Sound = new Sound(new URLRequest(path));
			var ret = new WSound(sound);
			_sounds[name] = ret;
			return ret;
		}
		
		public function playSound(name:String):WSound{
			trace("playing: "+name);
			var wSound:WSound = _sounds[name] as WSound;
			if(wSound != null){
				wSound.play();
			}
			return wSound;
		}
		
		public function stopSound(name:String):WSound{
			trace("stopping: "+name);
			var wSound:WSound = _sounds[name] as WSound;
			if(wSound != null){
				wSound.stop();
			}
			return wSound;
		}
		
		public function fadeInSound(name:String, time:Number):WSound{
			trace("fading in: "+name);
			var wSound:WSound = _sounds[name] as WSound;
			if(wSound != null){
				wSound.fadeIn(time);
			}
			return wSound;
		}
		
		public function fadeOutSound(name:String, time:Number):WSound{
			trace("fading out: "+name);
			var wSound:WSound = _sounds[name] as WSound;
			if(wSound != null){
				wSound.fadeOut(time);
			}
			return wSound;
		}
		
		public function update():void{
			var s:WSound;
			for(var i in _sounds){
				s = _sounds[i] as WSound;
				s.update();
			}
		}
		
	}
}