﻿package com.wizards{	import flash.geom.Point;
	
	import org.libspark.flartoolkit.core.types.FLARDoublePoint2d;		public class MarkerReader	{		//private var _activeId:int;		private var _activeMarkerInfo:FLARDetectedMarkerInfo;		private var _symbolTable:Array;		private var _crossHairPoint:Point;				//objects for Hyung's Smoothing function		private var _intersectionXHistory:Array;		private var _intersectionYHistory:Array;		private var _maxHistoryNum:int;				public function MarkerReader()		{			_activeMarkerInfo = null;			_symbolTable = new Array();						WizardsG.ACTIVE_MARKER = null;						_crossHairPoint = null;						_intersectionXHistory = new Array();			_intersectionYHistory = new Array();			_maxHistoryNum = 5;		}				public function updateSymbolTable(detectedMarkers:Array, detectedNum:int){			var newSymbolTable:Array = new Array();			var setActive:Boolean = false;			var firstId:int;			var pos:Point = null;			var rot:Number = null;			for(var i = 0; i < detectedNum; i++){				var m:FLARDetectedMarkerInfo = detectedMarkers[i] as FLARDetectedMarkerInfo;				if(!setActive){					firstId = m.codeId;					setActive = true;				}				//check if it's the activeId				if(newSymbolTable[m.codeId] == undefined){					// then we make a new array here					var indArray:Array = new Array();					indArray.push(m);					newSymbolTable[m.codeId] = indArray;				} else {					// we add it to the existing one					var indArray:Array = newSymbolTable[m.codeId] as Array;					indArray.push(m);				}			}			_symbolTable = newSymbolTable;			//now we find the activeMarker						if(_activeMarkerInfo == null ){				if(setActive){					_activeMarkerInfo = _symbolTable[firstId][0];					_intersectionXHistory = new Array();					_intersectionYHistory = new Array();				}			} else {				var id = _activeMarkerInfo.codeId;				if(_symbolTable[id] == undefined){					_activeMarkerInfo = null;					_crossHairPoint = null;				} else {					_activeMarkerInfo = _symbolTable[id][0];				}			}			//now we smooth if found			if(_activeMarkerInfo != null){				//trace("smoothing");				_activeMarkerInfo.transMat.getIntersectionPoints2();	// don't use getIntersectionPoint()				_activeMarkerInfo.transMat.getRotationAngle();				rot = _activeMarkerInfo.transMat.rotationZDegree * -1;				var fpos:FLARDoublePoint2d = getAveragePoint(_activeMarkerInfo.square.sqvertex);				var pos = new Point(800 - fpos.x * 2, fpos.y * 2);				//_activeMarkerInfo.transMat.getRotationAngle();				// let's put a simple smoothing function here!				/////////////////////////////////////////////				var intersectionXSmooth:Number;				var intersectionYSmooth:Number;								if(length==_maxHistoryNum)				{					_intersectionXHistory.shift();					_intersectionYHistory.shift();				}				_intersectionXHistory.push(_activeMarkerInfo.transMat.intersectionX);				_intersectionYHistory.push(_activeMarkerInfo.transMat.intersectionY);									var length:int = _intersectionXHistory.length;								// averaging 5 taps				if(length<3)				{					intersectionXSmooth = _intersectionXHistory[length-1];					intersectionYSmooth = _intersectionYHistory[length-1];				}				else if(length<_maxHistoryNum)				{					intersectionXSmooth = (_intersectionXHistory[length-3]+_intersectionXHistory[length-2]+_intersectionXHistory[length-1])*0.33333;					intersectionYSmooth = (_intersectionYHistory[length-3]+_intersectionYHistory[length-2]+_intersectionYHistory[length-1])*0.33333;				}				else				{					intersectionXSmooth = (_intersectionXHistory[length-5]+_intersectionXHistory[length-4]+_intersectionXHistory[length-3]+_intersectionXHistory[length-2]+_intersectionXHistory[length-1])*0.2;					intersectionYSmooth = (_intersectionYHistory[length-5]+_intersectionYHistory[length-4]+_intersectionYHistory[length-3]+_intersectionYHistory[length-2]+_intersectionYHistory[length-1])*0.2;				}								if(_crossHairPoint == null){					_crossHairPoint = new Point();				}								var tx = pos.x - intersectionXSmooth*.8;				var ty = pos.y + intersectionYSmooth*.8;										_crossHairPoint.x = tx;				_crossHairPoint.y = ty;			}			WizardsG.MARKER_TABLE = _symbolTable;			WizardsG.ACTIVE_MARKER = _activeMarkerInfo;						WizardsG.CROSSHAIR_POINT = _crossHairPoint;			WizardsG.MARKER_ROTATION = rot;			WizardsG.MARKER_POSITION = pos;				}				private function getAveragePoint(sqvertex:Array):FLARDoublePoint2d{			var runningX:Number = 0;			var runningY:Number = 0;			for(var i:int = 0; i < 4; i++){				runningX += sqvertex[i].x;				runningY += sqvertex[i].y;			}			return new FLARDoublePoint2d(runningX/4,runningY/4);		}	}}