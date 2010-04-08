﻿package {		import com.wizards.ARGameController;	import com.wizards.WizardsG;		import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.utils.getTimer;	import flash.ui.Keyboard;		import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;	import org.papervision3d.lights.PointLight3D;	import org.papervision3d.materials.ColorMaterial;	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;	import org.papervision3d.objects.primitives.Cube;	import org.papervision3d.objects.primitives.Plane;		//[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]	[SWF(width=800, height=600, backgroundColor=0xffffff, frameRate=60)]		public class WizardsAR extends PV3DARApp {		private var _plane:Plane;		private var _plane1:Plane, _plane2:Plane, _plane3:Plane, _plane4:Plane;		private var _cube:Cube;		//private var _arrow:Arrow;		//private var _simpleGame:MovieClip;				private var _oldDetectedNum:int;				private var _arGameController:ARGameController;				private var _spellDataLoader:URLLoader;		private var _spellData:XML;				public function WizardsAR() {			// Initalize application with the path of camera calibration file and patter definition file.			// カメラ補正ファイルとパターン定義ファイルのファイル名を渡して初期化。			addEventListener(Event.INIT, _onInit);			//init('Data/camera_para.dat', 'Data/flarlogo.pat');	// 50%						// multi marker detection			//var codeList:Array = new Array("data/marker_casting_16_50.pat", "data/marker_iceelement_16_50.pat", "data/marker_fireelement_16_50.pat");			//var codeList:Array = new Array("data/marker1_16_80.pat", "data/marker2_16_80.pat", "data/marker3_16_80.pat", "data/marker_cast_16_80.pat", "data/marker_fire_16_80.pat", "data/marker_ice_16_80.pat");			var codeList:Array = new Array("data/marker1_16_80.pat", "data/marker2_16_80.pat", "data/marker3_16_80.pat");			initM('data/camera_para.dat', codeList);		}		private function _onInit(e:Event):void {			mirror = !mirror;			stage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyPushed);						/*stage.addEventListener(MouseEvent.CLICK, _onClick);			addEventListener(Event.ENTER_FRAME, _onEnterFrame);*/						_spellDataLoader = new URLLoader();			_spellDataLoader.addEventListener(Event.COMPLETE, onSpellLoadComplete);						_spellDataLoader.load(new URLRequest("data/spell_data.xml"));						// building PV3D models			// 20 random colored wireframe + cubes			this._objectsToDisplay = new Array();			var tempObj:FLARBaseNode;			var color:Number;			var light:PointLight3D  = new PointLight3D();			light.x = 0; light.y = 1000; light.z = -1000;			//var wmat:WireframeMaterial;			var fmat:FlatShadeMaterial; 			var cmat:ColorMaterial;			for (var i:int=0; i<this._maxMarkerNum; i++)	// 20 objects... 			{				tempObj = new FLARBaseNode;				//color = int(Math.random()*255)<<16 | int(Math.random()*255)<<8 | int(Math.random()*255);					color = 0xF00000;				cmat = new ColorMaterial(color);				_plane1 = new Plane(cmat, 3, 60);				_plane1.rotationX = 180;	_plane1.x = -29;				_plane2 = new Plane(cmat, 3, 60);				_plane2.rotationX = 180;	_plane2.x = 29;				_plane3 = new Plane(cmat, 60, 3);				_plane3.rotationX = 180;	_plane3.y = -29;				_plane4 = new Plane(cmat, 60, 3);				_plane4.rotationX = 180;	_plane4.y = 29;				tempObj.addChild(_plane1);	tempObj.addChild(_plane2);	tempObj.addChild(_plane3);	tempObj.addChild(_plane4);				/*fmat = new FlatShadeMaterial(light, color, 0x75104e);				_cube = new Cube(new MaterialsList({all: fmat}), 30, 30, 30);				_cube.z = 25;				tempObj.addChild(_cube);*/				_objectsToDisplay.push(tempObj);		// ...				//this._markerNode.addChild(tempObj);	// ... 			}		}				public function onSpellLoadComplete(ev:Event){			_spellData = new XML(_spellDataLoader.data);			WizardsG.SPELLS = _spellData.spells;			WizardsG.SYNTAX = _spellData.syntax;			WizardsG.TIMING = _spellData.timing;						_arGameController = new ARGameController();			//_base.alpha = .25;	//////////////////////////////////////			addChildAt(_arGameController,0);				//addChild(_arGameController);						_base.mouseEnabled = false;			//stage.addEventListener(MouseEvent.CLICK, _onClick);			addEventListener(Event.ENTER_FRAME, _onEnterFrame);						//for(var i  = 0; i < this.numChildren; i++)	trace(this.getChildAt(i));			//for(i=0; i<this._base.numChildren; i++)	trace(this._base.getChildAt(i));		}				private function _onClick(e:MouseEvent):void {			//mirror = !mirror;		}				// mainly for turning on/off debugging infos		public function _onKeyPushed(event:KeyboardEvent):void		{			switch (event.keyCode)			{				// adaptive thresholding				case 81:	if (this._threshold == 100)							{								this._threshold = -1;								trace("adaptive thresholding");								}							else							{								this._threshold = 100;								trace("fixed value thresholding");								}							break;				// gray, thresholded binary image				case 87:	if(!this._grayandbinaryImage)	this._grayandbinaryImage = 1;							else	this._grayandbinaryImage = 0;							break;				// turn on/off adaptive(bimodal) thresholding				case 69:	if(!this._doBimodalThresholding) this._doBimodalThresholding = 1;							else	this._doBimodalThresholding = 0;							break;				case 82:				default:break;			}		}				private function _onEnterFrame(e:Event = null):void		{			var t:uint = getTimer();			WizardsG.TIME_DIFF = (t-WizardsG.TIME)/1000;			WizardsG.TIME = t;						//trace("detectedNum: "+detectedNum+", oldDetectedNum: "+_oldDetectedNum);			/*trace(_detectedMarkers.length);			for(var i in _detectedMarkers){				trace(_detectedMarkers[i].codeId);			}*/			/*// protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();						_arGameController.moveActivePhrase(_resultMat.intersectionX, _resultMat.intersectionY, _resultMat.rotationZDegree);			*/			_arGameController.updatePhrases(_detectedMarkers, _detectedNumFinal.length);			_arGameController.update();		}			}}