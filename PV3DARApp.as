package {	// test	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Sprite;	import flash.events.Event;		import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;	import org.libspark.flartoolkit.detector.FLARMultiMarkerDetectorResult;	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;	import org.libspark.flartoolkit.support.pv3d.FLARCamera3D;	import org.papervision3d.render.LazyRenderEngine;	import org.papervision3d.scenes.Scene3D;	import org.papervision3d.view.Viewport3D;		public class PV3DARApp extends ARAppBase {			protected var _base:Sprite;		public static var globalBase:Sprite;					public static var globalBitmap:Bitmap;			// this debugging stuff displays thresholded binary image		public static var globalBitmapData:BitmapData;	// at the upper right corner				public static var gIsFirstDetectionDone:Boolean;		public static var _detectedMarkers:Array;	// array of FLARDetectedMarkerInfo		public static var _detectedNumFinal:Array;	// array of detected marker's index				protected var _viewport:Viewport3D;		//protected var _viewport:BitmapViewport3D;		protected var _camera3d:FLARCamera3D;				/*protected var _obj3DImageWidth:int;				// once the marker is detected, 		protected var _obj3DBitmapData:BitmapData;		// this debugging stuff displays marker + PV3D obj image 		protected var _obj3DBitmap:Bitmap;				// at the bottom right corner		protected var _capturedBitmapData:BitmapData;	// the image size is _obj3DImageWidth and		protected var _capturedBitmap:Bitmap;			// always scaled up/down to this size		protected var _blackObj3DBitmap:Bitmap;			//		protected var _blackCapturedBitmap:Bitmap;	*/	//				//private var _detectedMarkerBorderLines:Shape;		protected var _scene:Scene3D;		protected var _renderer:LazyRenderEngine;		protected var _markerNode:FLARBaseNode;			//protected var _markerNodeMulti:Array;	// array of FLARBaseNode		//protected var _markerNodeMulti:FLARBaseNode;		protected var _detectedInfo:Array;		// array of FLARMultiMarkerDetectorResult		//protected var detected:Boolean;		protected var detectedNum:int;		protected var _maxMarkerNum:int;	// const		//protected var _detectedResults:FLARMultiMarkerDetectorResult;		protected var _resultMat:FLARTransMatResult;// = new FLARTransMatResult();				// objects to display in 3D		protected var _objectsToDisplay:Array;		protected var _prevDetectedMarkerIndex:Array;				protected var _threshold:int = -1;				// default is adaptive thresholding		protected var _grayandbinaryImage:int = 0;		protected var _doBimodalThresholding:int = 1;	// default is adaptive thresholding		//protected var _pv3dRenderedImageCorner:int = 0;				/*public function get markerNode():FLARBaseNode		{			return _markerNode;		}	*/				/*public function get detectedNumFinal():int		{			return _detectedNumFinal;		}*/				public function PV3DARApp() {		}				protected override function init(cameraFile:String, codeFile:String, canvasWidth:int = 400, canvasHeight:int = 300, codeWidth:int = 60):void {			//_markerNodeMulti = null;			_maxMarkerNum = 0;			addEventListener(Event.INIT, _onInit, false, int.MAX_VALUE);			super.init(cameraFile, codeFile, canvasWidth, canvasHeight, codeWidth);		}				protected override function initM(cameraFile:String, codeFileArray:Array, canvasWidth:int = 400, canvasHeight:int = 300, codeWidth:int = 60):void {			_maxMarkerNum=20;	// max 20 markers			_detectedMarkers = new Array();			_detectedNumFinal = new Array();						addEventListener(Event.INIT, _onInit, false, int.MAX_VALUE);			super.initM(cameraFile, codeFileArray, canvasWidth, canvasHeight, codeWidth);		}				private function _onInit(e:Event):void {			_base = addChild(new Sprite()) as Sprite;			//_base = new Sprite();			//test			globalBase = _base;	// to display thresholded image (for debugging)						_capture.width = 800;//640;			_capture.height = 600;//480;						_capture.alpha = 0.25;				_base.addChild(_capture);						//detected = false;	// protected var detected:Boolean;						_viewport = _base.addChild(new Viewport3D(400, 300)) as Viewport3D;			//_viewport = _base.addChild(new BitmapViewport3D(400, 300)) as BitmapViewport3D;					//_viewport = new BitmapViewport3D(400, 300, false, true, 0x000000, true);			//_viewport = _base.addChild(_viewport) as BitmapViewport3D;			// detected marker border			/*_detectedMarkerBorderLines = new Shape();			_detectedMarkerBorderLines.graphics.lineStyle(5, 0xFF0000);			_detectedMarkerBorderLines.graphics.moveTo(1, 1);			_detectedMarkerBorderLines.graphics.lineTo(1,1);			_base.addChild(_detectedMarkerBorderLines);*/						// empty (black background) bitmap for 'no detected marker'					/*_obj3DImageWidth = 120;				_blackCapturedBitmap = new Bitmap(new BitmapData(_obj3DImageWidth, _obj3DImageWidth, false, 0x00));			_blackCapturedBitmap.x=0; _blackCapturedBitmap.y = _capture.height-_obj3DImageWidth;			_blackObj3DBitmap = new Bitmap(new BitmapData(_obj3DImageWidth, _obj3DImageWidth, false, 0x00));			_blackObj3DBitmap.x=0; _blackObj3DBitmap.y = _capture.height-_obj3DImageWidth;	*/									_viewport.scaleX = 800/400;//640 / 320;				_viewport.scaleY = 600/300;//480 / 240;			_viewport.x = -4; // 4pix for alignment									_camera3d = new FLARCamera3D(_param);						_scene = new Scene3D();			_markerNode = _scene.addChild(new FLARBaseNode()) as FLARBaseNode;	// 'as FLARBaseNode' is a kind of type casting				_renderer = new LazyRenderEngine(_scene, _camera3d, _viewport);						_prevDetectedMarkerIndex = new Array();							gIsFirstDetectionDone = false;			addEventListener(Event.ENTER_FRAME, _onEnterFrame);		}		private function _onEnterFrame(e:Event = null):void {			// overlaying captured image			_capture.bitmapData.draw(_video);								try {				//detected = _detector.detectMarkerLite(_raster, 70) && _detector.getConfidence() > 0.5;				//detectedNum = _detectorMulti.detectMarkerLite(_raster, 70);// && _detectorMulti.getConfidence()>0.5;	//70:threshold				detectedNum = _detectorMulti.detectMarkerLite(_raster, _threshold, _grayandbinaryImage, _doBimodalThresholding);							} catch (e:Error) {}									_detectedNumFinal = new Array();	// clear array			// remove objects in previous frame			//_markerNode.visible = false;			for(i=0; i<_prevDetectedMarkerIndex.length; i++)			{				// set VISIBLE ON/OFF ??				_markerNode.removeChild(_objectsToDisplay[_prevDetectedMarkerIndex[i]]);	// _prevDetectedMarkerIndex[] = codeId			}						if(detectedNum>0)			{				var i:int;				gIsFirstDetectionDone = false;				for(i=0; i<detectedNum; i++)				{					if(_detectorMulti.getConfidence(i) > 0.6)	// heuristic confidence level...					{						gIsFirstDetectionDone = true;												_resultMat = new FLARTransMatResult();						_detectorMulti.getTransmationMatrix(i, _resultMat);														var temp:FLARMultiMarkerDetectorResult = _detectorMulti.getResult(i);						var tempResult:FLARDetectedMarkerInfo = new FLARDetectedMarkerInfo(temp.codeId,																							temp.direction,																							temp.confidence,																							temp.square,																							_resultMat);						_detectedMarkers[_detectedNumFinal.length] = tempResult;	// don't need to explicitly free the result of previous frame ? 						//_detectedMarkers[i] = tempResult;						_detectedNumFinal.push(temp.codeId);							// test: drawing detected marker image						/*/////////////////////////////////////////////////////////						t_patArray = _detectorMulti._patt.getPatArray();						for (y=0; y<16; y++)							for(x=0; x<16; x++)							{								color = uint(t_patArray[y][x][0]<<16 | t_patArray[y][x][1]<<8 | t_patArray[y][x][2]);								globalBitmapData.fillRect(new Rectangle(x*5, y*5, 5, 5), color);							}							var xx:int; var yy:int;							for(var ii:int=0; ii<4; ii++)	// drawing vertex							{								xx=_detectorMulti.getResult(i).square.imvertex[ii].x-2;								yy=_detectorMulti.getResult(i).square.imvertex[ii].y-2;								globalBitmapData.fillRect(new Rectangle(xx, yy, 5, 5), 0xff0000);							}						/////////////////////////////////////////////////////////*/						_objectsToDisplay[temp.codeId].setTransformMatrix(_resultMat);						_markerNode.addChild(_objectsToDisplay[temp.codeId]);											}				}				_prevDetectedMarkerIndex = _detectedNumFinal;			}			else				gIsFirstDetectionDone = false;							// single marker//			if (detected) {//				_detector.getTransformMatrix(_resultMat);//				_markerNode.setTransformMatrix(_resultMat);	// ???????????????????????????????//				//_markerNode.setTransformMatrixDummy(_resultMat);//				_resultMat.getRotationAngle();	// for Z axis//				_resultMat.getIntersectionPoints2();//				trace(_resultMat.intersectionX+" "+_resultMat.intersectionY+"\n");////				//using papervision3d api//				/*var baseRotation:Number3D = Matrix3D.matrix2euler(_markerNode.transform);//				trace("from papervision3D api");//				trace(baseRotation.x+" "+baseRotation.y+" "+baseRotation.z);*///				//				_markerNode.visible = true;//			} else {//				_markerNode.visible = false;//			}			//////////////////////			_renderer.render();			//////////////////////						// drawing debugging info (drawing captured+thresholded image)			/////////////////////////////////////////////////////////////////			//var tmp:DisplayObject;			if(globalBase.getChildByName("tempbitmap"))	// thresholded binary image			{				//tmp = globalBase.removeChildAt(globalBase.getChildIndex(globalBase.getChildByName("tempbitmap")));				//tmp = globalBase.removeChild(globalBitmap);				//tmp = null;	// free ?				globalBase.removeChild(globalBitmap);			}			/*if(globalBase.getChildByName("capturedbitmap"))	// marker + PV3D obj image			{				globalBase.removeChild(_capturedBitmap);				globalBase.removeChild(_obj3DBitmap);			}*/			if(_grayandbinaryImage)			{				//globalBitmapData = _detectorMulti.thresholdedBitmapData.clone();				globalBitmapData = _detectorMulti.thresholdedBitmapData;	// binary image				globalBitmap = new Bitmap(globalBitmapData);				globalBitmap.name = "tempbitmap";				globalBase.addChild(globalBitmap);				//FLARRaster_BitmapData(this._bin_raster).bitmapData.clone();				/*for(var n:int=0; n<3; n++)		// drawing reference markers				{					var t_patArray:Array = _codeArray[n].getPat();					for (var y:int=0; y<16; y++)						for(var x:int=0; x<16; x++)						{							var color:uint = uint(t_patArray[0][y][x][0]<<16 | t_patArray[0][y][x][1]<<8 | t_patArray[0][y][x][2]);							globalBitmapData.fillRect(new Rectangle(x*5+320, y*5+(n*82), 5, 5), color);						}				}*/			}			/*if(_pv3dRenderedImageCorner)			{				if(_detectedNumFinal.length==0)				{					_capturedBitmap = _blackCapturedBitmap;					_capturedBitmap.name = "capturedbitmap";					_obj3DBitmap = _blackObj3DBitmap;					_obj3DBitmap.name = "obj3dbitmap";					_base.addChild(_capturedBitmap);					_base.addChild(_obj3DBitmap);					}					else//if(_detectedNumFinal.length>0)				{					var tempDetected:FLARSquare = _detectedMarkers[0].square;					var centerX:int = int((tempDetected.imvertex[0].x+tempDetected.imvertex[1].x+tempDetected.imvertex[2].x+tempDetected.imvertex[3].x)*0.25);					var centerY:int = int((tempDetected.imvertex[0].y+tempDetected.imvertex[1].y+tempDetected.imvertex[2].y+tempDetected.imvertex[3].y)*0.25);					var length:int = ((centerX-tempDetected.imvertex[0].x)*(centerX-tempDetected.imvertex[0].x))+((centerY-tempDetected.imvertex[0].y)*(centerY-tempDetected.imvertex[0].y));					var tempLength:int;										for(i=1; i<4; i++)					{						tempLength = ((centerX-tempDetected.imvertex[i].x)*(centerX-tempDetected.imvertex[i].x))+((centerY-tempDetected.imvertex[i].y)*(centerY-tempDetected.imvertex[i].y));						if(tempLength > length)							length = tempLength;					}					length = int(Math.sqrt(length)*1.2);										// add captured image					var srcCapturedImage:BitmapData = FLARRgbRaster_BitmapData(_raster).bitmapData;					_capturedBitmapData = new BitmapData(length*2, length*2);					_capturedBitmapData.copyPixels(srcCapturedImage, new Rectangle(centerX-length, centerY-length, length*2, length*2), new Point());					_capturedBitmap = new Bitmap(_capturedBitmapData);					_capturedBitmap.name = "capturedbitmap";					_capturedBitmap.width = _capturedBitmap.height = _obj3DImageWidth;	// scaling					_capturedBitmap.x = 0; _capturedBitmap.y = _capture.height-_obj3DImageWidth;					_base.addChild(_capturedBitmap);										// add PV3D rendered object bitmap					_obj3DBitmapData = new BitmapData(length*2, length*2, true, 0x00);					_obj3DBitmapData.copyPixels(_viewport.bitmapData, new Rectangle(centerX-length+4,centerY-length,length*2,length*2), new Point());					_obj3DBitmap = new Bitmap(_obj3DBitmapData);					_obj3DBitmap.name = "obj3dbitmap";					_obj3DBitmap.width = _obj3DBitmap.height = _obj3DImageWidth;	// scaling					_obj3DBitmap.x = 0; _obj3DBitmap.y = _capture.height-_obj3DImageWidth;					_base.addChild(_obj3DBitmap);				}			}*/			///////////////////////////////////////////////////////////////////////			// draw red border lines on detected markers			/*_detectedMarkerBorderLines.graphics.clear();			_detectedMarkerBorderLines.graphics.lineStyle(5, 0xFF0000);			if(_detectedNumFinal.length)			{				for(i=0; i<_detectedNumFinal.length; i++)				{					_detectedMarkerBorderLines.graphics.moveTo(_detectedMarkers[i].square.imvertex[0].x*_viewport.scaleX-_viewport.x, _detectedMarkers[i].square.imvertex[0].y*_viewport.scaleY);					for(var j:int=1; j<4; j++)						_detectedMarkerBorderLines.graphics.lineTo(_detectedMarkers[i].square.imvertex[j].x*_viewport.scaleX-_viewport.x, _detectedMarkers[i].square.imvertex[j].y*_viewport.scaleY);					_detectedMarkerBorderLines.graphics.lineTo(_detectedMarkers[i].square.imvertex[0].x*_viewport.scaleX-_viewport.x, _detectedMarkers[i].square.imvertex[0].y*_viewport.scaleY);				}			}			else			{				_detectedMarkerBorderLines.graphics.moveTo(1,1);				_detectedMarkerBorderLines.graphics.lineTo(1,1);						}*/		}				public function set mirror(value:Boolean):void {			if (value) {				_base.scaleX = -1;				_base.x = 800;//640;			} else {				_base.scaleX = 1;				_base.x = 0;			}		}				public function get mirror():Boolean {			return _base.scaleX < 0;		}				}}