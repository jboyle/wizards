﻿package com.wizards.levels.scenarios.views{	import com.wizards.WizardsG;	import com.wizards.levels.LevelEvent;	import com.wizards.levels.Room;	import com.wizards.levels.View;		import flash.display.Graphics;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.geom.Point;		public class V2S_trainingView extends View	{		var trainingSymbol1:MovieClip;		var trainingSymbol2:MovieClip;		var trainingSymbolStart:MovieClip;		var startingPoint:Point;		var currPoint:Point, prevPoint:Point;		var bBegin:Boolean;		var bOnStartingPoint:Boolean;		var bComplete:Boolean;		var sp:Sprite;		var g:Graphics;				var length:Number;				public function V2S_trainingView()		{			super();			trainingSymbol1 = new TrainingSymbol1();			trainingSymbol1.x = 400; trainingSymbol1.y=300;			this.addChild(trainingSymbol1);			trainingSymbol2 = new TrainingSymbol2();			trainingSymbol2.x = 400; trainingSymbol2.y=300;			trainingSymbol2.visible = false;			this.addChild(trainingSymbol2);						bBegin = false;			bOnStartingPoint = true;			bComplete = false;			prevPoint = new Point();			currPoint = new Point();						sp = new Sprite();			this.addChild(sp);			g = sp.graphics;			g.lineStyle(30, 0xFFFF00);						length = 0;		}				override public function update():void		{			super.update();						if(WizardsG.CROSSHAIR_POINT!=null && !bComplete)			{				if(trainingSymbol1.hitTestPoint(WizardsG.CROSSHAIR_POINT.x, WizardsG.CROSSHAIR_POINT.y) && !trainingSymbol2.hitTestPoint(WizardsG.CROSSHAIR_POINT.x, WizardsG.CROSSHAIR_POINT.y))				{					if(!bBegin)					{						bBegin = true;						bOnStartingPoint = true;						startingPoint = new Point(WizardsG.CROSSHAIR_POINT.x, WizardsG.CROSSHAIR_POINT.y);						trainingSymbolStart = new TrainingSymbol1Starting();						trainingSymbolStart.x = WizardsG.CROSSHAIR_POINT.x;						trainingSymbolStart.y = WizardsG.CROSSHAIR_POINT.y;						this.addChild(trainingSymbolStart);						prevPoint = startingPoint;					}					else					{						// draw a line from prevPoint to currPoint						currPoint.x = WizardsG.CROSSHAIR_POINT.x;						currPoint.y = WizardsG.CROSSHAIR_POINT.y;												var distance:Number = Math.sqrt(Math.pow(prevPoint.x-currPoint.x,2)+Math.pow(prevPoint.y-currPoint.y,2));						if(distance <= 40)						{							g.moveTo(prevPoint.x, prevPoint.y);							g.lineTo(currPoint.x, currPoint.y);														prevPoint.x = currPoint.x;							prevPoint.y = currPoint.y;														length+=distance;						}												if(length>30)	bOnStartingPoint = false;												// completion check						if(trainingSymbolStart.hitTestPoint(WizardsG.CROSSHAIR_POINT.x, WizardsG.CROSSHAIR_POINT.y) && !bOnStartingPoint)							if(length>800 && length<1600)	// 854, 1342							{								// clear!								// sound effect!								bComplete = true;								this._fader.addEventListener(Event.COMPLETE, handleFadeComplete);								this.fadeOut(0.5);							}							else							{									//trace("clear drawing");								this.removeChild(trainingSymbolStart);								g.clear();								g.lineStyle(30, 0xFFFF00);								length = 0;								bBegin = false;								bOnStartingPoint = true;							}					}				}			}		}				private function handleFadeComplete(ev:Event)		{			this.removeChild(trainingSymbolStart);			this.removeChild(sp);			this.removeChild(trainingSymbol2);			this.removeChild(trainingSymbol1);						// move to next level!!			var evt:LevelEvent = new LevelEvent(LevelEvent.CHANGE_LEVEL);			evt.level = 0;			evt.room = "intro";	// FightingScenario()			evt.direction = Room.NORTH;			evt.fadeIn = true;			dispatchEvent(evt);				trace("V2S_trainingView sent CHANGE_LEVEL event");		}	}}