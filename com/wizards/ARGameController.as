package com.wizards
{
	import com.wizards.effects.Effect;
	import com.wizards.effects.HitPoints;
	import com.wizards.levels.LevelEvent;
	import com.wizards.levels.intro.IntroLevel;
	import com.wizards.levels.onecloud.Level1;
	import com.wizards.levels.scenarios.FightScenario;
	import com.wizards.view.TargetParticle;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.libspark.flartoolkit.core.types.FLARDoublePoint2d;
	
	public class ARGameController extends MovieClip
	{
		public static const DELAY_REMOVE:Number = 2;
		
		private var _displayArea:DisplayArea;
		private var _spellController:SpellController;
		private var _levelController:LevelController;
		//private var _roomController:RoomController;
		
		private var _player:GameObject;
		
		private var _activePhrases:Array;
		private var _activeIds:Array;
		private var _activeTimers:Array;
		
		private var _intersectionXHistory:Array;
		private var _intersectionYHistory:Array;
		private var _maxHistoryNum:int;
		
		private var _healthIndicator:MovieClip;
		
		private var _crossHairClip:MovieClip;
		
		public function ARGameController()
		{
			_displayArea = new DisplayArea();
			_spellController = new SpellController(_displayArea);
			
			_player = new GameObject();
			
			_activePhrases = new Array();
			_activeIds = new Array();
			_activeTimers = new Array();
			
			var playerHP = new HitPoints(10,Effect.DURATION_FOREVER,0);
			_player.addEffect(playerHP);
			
			_spellController.selfTarget = _player;
			_spellController.target = null;
			
			_intersectionXHistory = new Array();
			_intersectionYHistory = new Array();
			_maxHistoryNum = 5;
			
			//_roomController = new RoomController;
			//_roomController.addEventListener("roomChange",handleRoomChange);
			_levelController = new LevelController();
			_levelController.addEventListener(LevelEvent.CLEAR, handleLevelClear);
			
			_levelController.addLevel(new IntroLevel());
			_levelController.addLevel(new Level1());
			_levelController.addLevel(new FightScenario());
			
			//////////////////////
			/*_levelController.level = 1;
			var l:Level = _levelController.levelObj;
			l.setRoom("6",Room.NORTH);*/
			
			_healthIndicator = new HealthIndicator();
			_healthIndicator.mouseEnabled = false;
			_healthIndicator.alpha = 0;
			
			_crossHairClip = new CrosshairClip();
			_crossHairClip.visible = false;
			
			
			//addChild(_roomController);
			addChild(_levelController);
			addChild(_displayArea);
			addChild(_crossHairClip);
			addChild(_healthIndicator);
			
		}
		
		public function update(){
			_displayArea.update();
			_spellController.update();
			_levelController.update();
			
			//_roomController.update();
			
			//_player.update();
			//_target.update();
		}
		
		public function getPhrase(num:int):Phrase{
			trace("casting "+num);
			var ret:Phrase
			if(num == WizardsG.MARGER_OPEN){
				ret = new Phrase("open");
			} else if(num == WizardsG.MARKER_ATTACK){
				ret = new Phrase("attack");
			} else if(num == WizardsG.MARKER_ICE){
				ret = new Phrase("ice");
			} else if(num == WizardsG.MARKER_FIRE){
				ret = new Phrase("fire");
			}
			return ret;
		}
		
		/*public function stopCast(){
			_spellController.stopCast();
		}
		
		public function moveActivePhrase(x:Number, y:Number, rotation:Number){
		
			if(_spellController.activePhrase != null){
				_spellController.activePhrase.clip.x = x;
				_spellController.activePhrase.clip.y = y;
			}
		}*/
		
		public function updatePhrases(detectedMarkers:Array, detectedNum:int){
			//trace(_activeIds);
			_crossHairClip.visible = false;
			for(var i = 0; i < detectedNum; i++){
				var m:FLARDetectedMarkerInfo = detectedMarkers[i] as FLARDetectedMarkerInfo;
				var ind:int = _activeIds.indexOf(m.codeId);
				if(ind == -1){
					//we create a new marker
					var phrase:Phrase = getPhrase(m.codeId);
					phrase.clip.x = m.transMat.intersectionX;
					phrase.clip.y = m.transMat.intersectionY;
					
					_spellController.startCast(phrase);
					_activeIds.push(m.codeId);
					_activePhrases.push(phrase);
					_activeTimers.push(0);
				} else {
					var p:Phrase = _activePhrases[ind] as Phrase;
					//trace(m.transMat.intersectionX+" "+m.transMat.intersectionY);
					
					//var tmat = new Matrix(m.transMat.m00,-m.transMat.m01,m.transMat.m10,-m.transMat.m11,0,0);
					//p.clip.transform.matrix = tmat;
					
					if(!p.fixed){
						var clipPoint:FLARDoublePoint2d = getAveragePoint(m.square.sqvertex);
						p.clip.x = 800 - (clipPoint.x * 2);
						p.clip.y = clipPoint.y * 2;
						m.transMat.getRotationAngle();
						p.clip.rotation = m.transMat.rotationZDegree * -1;
						_activeTimers[ind] = 0;
						
					}
					if(p.crossHairsClip != null){
						m.transMat.getIntersectionPoints2();	// don't use getIntersectionPoint()
						// let's put a simple smoothing function here!
						/////////////////////////////////////////////
						var intersectionXSmooth:Number;
						var intersectionYSmooth:Number;
						var length:int = _intersectionXHistory.length;
						if(length==_maxHistoryNum)
						{
							_intersectionXHistory.shift();
							_intersectionYHistory.shift();
						}
						_intersectionXHistory.push(m.transMat.intersectionX);
						_intersectionYHistory.push(m.transMat.intersectionY);
						
						// averaging 5 taps
						if(length<3)
						{
							intersectionXSmooth = _intersectionXHistory[length-1];
							intersectionYSmooth = _intersectionYHistory[length-1];
						}
						else if(length<_maxHistoryNum)
						{
							intersectionXSmooth = (_intersectionXHistory[length-3]+_intersectionXHistory[length-2]+_intersectionXHistory[length-1])*0.33333;
							intersectionYSmooth = (_intersectionYHistory[length-3]+_intersectionYHistory[length-2]+_intersectionYHistory[length-1])*0.33333;
						}
						else
						{
							intersectionXSmooth = (_intersectionXHistory[length-5]+_intersectionXHistory[length-4]+_intersectionXHistory[length-3]+_intersectionXHistory[length-2]+_intersectionXHistory[length-1])*0.2;
							intersectionYSmooth = (_intersectionYHistory[length-5]+_intersectionYHistory[length-4]+_intersectionYHistory[length-3]+_intersectionYHistory[length-2]+_intersectionYHistory[length-1])*0.2;
						}
						
						var tx = p.clip.x - intersectionXSmooth*.8;
						var ty = p.clip.y + intersectionYSmooth*.8;
						
						var particle:TargetParticle = getParticleBySpellName(p.spellName);
						p.crossHairsClip.addChild(particle);
						particle.run(new Point(p.clip.x,p.clip.y),new Point(tx,ty));
						_crossHairClip.x = tx;
						_crossHairClip.y = ty;
						_crossHairClip.visible = true;
						//p.crossHairsClip.x = p.clip.x - intersectionXSmooth *.7;
						//p.crossHairsClip.y = intersectionYSmooth*.7 + p.clip.y;
						
						
						/*trace(_intersectionXHistory);
						trace(_intersectionYHistory);
						trace(intersectionXSmooth+"   "+intersectionYSmooth);*/
						/////////////////////////////////////////////
						//p.crossHairsClip.x = p.clip.x - m.transMat.intersectionX *.4;
						//p.crossHairsClip.y = m.transMat.intersectionY*.4 + p.clip.y;
						if(p.spell != null){
							//p.spell.target = _roomController.getSpellCollision(tx, ty);
							p.spell.target = _levelController.getSpellCollision(tx,ty);
						}
					}
				}
			}
			
			var toRemove:Array = new Array();
			//now we check for the ones that aren't added
			for(i = 0; i < _activeIds.length; i++){
				var found:Boolean = false
				for(var j = 0; j < detectedNum; j++){
					var m:FLARDetectedMarkerInfo = detectedMarkers[j] as FLARDetectedMarkerInfo;
					if(m.codeId == _activeIds[i]){
						found = true;
						break;
					}
				}
				if(!found){
					toRemove.push(i);
				}
			}
			
			for(i = 0; i < toRemove.length; i++){
				//here we update the timers and if their too long we remove the phrases
				var ind:int = toRemove[i];
				_activeTimers[ind] += WizardsG.TIME_DIFF;
				if(_activeTimers[ind] >= DELAY_REMOVE){
					var p:Phrase = _activePhrases[ind] as Phrase;
					_spellController.stopCast(p);
					_activePhrases.splice(ind,1);
					_activeIds.splice(ind,1);
					_activeTimers.splice(ind,1);
				}
			}
		}
		
		private function getAveragePoint(sqvertex:Array):FLARDoublePoint2d{
			var runningX:Number = 0;
			var runningY:Number = 0;
			for(var i:int = 0; i < 4; i++){
				runningX += sqvertex[i].x;
				runningY += sqvertex[i].y;
			}
			return new FLARDoublePoint2d(runningX/4,runningY/4);
		}
		
		private function handleLevelClear(ev:LevelEvent){
			_spellController.clearAllPhrases();
			
			var p:Phrase;
			var toRemove = _activePhrases.slice();
			for(var i = 0; i < toRemove.length; i++){
				p = _activePhrases[i] as Phrase;
				var ind = _activePhrases.indexOf(p);
				_activePhrases.splice(ind,1);
				_activeIds.splice(ind,1);
				_activeTimers.splice(ind,1);
			}
		}
		
		private function getParticleBySpellName(name:String):TargetParticle{
			if(name == "fireAttack"){
				return new FireParticle();
			} else if(name == "iceAttack"){
				return new IceParticle();
			} else {
				return new AttackParticle();
			}
		}

	}
}
