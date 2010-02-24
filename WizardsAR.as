package {		import flash.events.Event;	import flash.events.MouseEvent;		import org.papervision3d.lights.PointLight3D;	import org.papervision3d.materials.WireframeMaterial;	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;	import org.papervision3d.materials.utils.MaterialsList;	import org.papervision3d.objects.primitives.Cube;	import org.papervision3d.objects.primitives.Plane;		//[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]	[SWF(width=800, height=600, backgroundColor=0x808080, frameRate=30)]		public class WizardsAR extends PV3DARApp {				private var _plane:Plane;		private var _cube:Cube;		//private var _simpleGame:MovieClip;				private var _oldDetectedNum:int;				public function WizardsAR() {			// Initalize application with the path of camera calibration file and patter definition file.			// カメラ補正ファイルとパターン定義ファイルのファイル名を渡して初期化。			addEventListener(Event.INIT, _onInit);			//init('Data/camera_para.dat', 'Data/flarlogo.pat');	// 50%						// multi marker detection			var codeList:Array = new Array("data/marker1_16_50.pat", "data/marker2_16_50.pat", "data/marker3_16_50.pat");			//var codeList:Array = new Array("Data/marker1_32_50.pat", "Data/marker2_32_50.pat", "Data/marker3_32_50.pat");			//var codeList:Array = new Array("Data/marker3_16_50.pat");			initM('data/camera_para.dat', codeList);		}		private function _onInit(e:Event):void {			//trace("SimpleCube.as _onInit() called")			var i:int;			mirror = !mirror;			// Create Plane with same size of the marker.			// マーカーと同じサイズを Plane を作ってみる。			var wmat:WireframeMaterial;			/*var wmat:WireframeMaterial = new WireframeMaterial(0xffff00, 1, 4); // with wireframe. / ワイヤーフレームで。			_plane = new Plane(wmat, 80, 80); // 80mm x 80mm。			_plane.rotationX = 180;*/			// single marker			//_markerNode.addChild(_plane); // attach to _markerNode to follow the marker. / _markerNode に addChild するとマーカーに追従する。			// ↓ERROR: DisplayObjectContainer.addChild : DisplayObject3D already has a parent, ie is already added to scene. 			for(i=0; i<_maxMarkerNum; i++)			{				wmat = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ワイヤーフレームで。				_plane = new Plane(wmat, 60, 60); // 80mm x 80mm。				_plane.rotationX = 180;				_markerNodeMulti[i].addChild(_plane);			}							// Place the light at upper front.			// ライトの設定。手前、上のほう。			var light:PointLight3D = new PointLight3D();			light.x = 0;			light.y = 1000;			light.z = -1000;						// Create Cube.			// Cube を作る。			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0xff22aa, 0x75104e); // Color is ping. / ピンク色。			for(i=0; i<_maxMarkerNum; i++)			{				_cube = new Cube(new MaterialsList({all: fmat}), 40, 40, 40); // 40mm x 40mm x 40mm				_cube.z = 20; // Move the cube to upper (minus Z) direction Half height of the Cube. / 立方体の高さの半分、上方向(-Z方向)に移動させるとちょうどマーカーにのっかる形になる。				//_markerNode.addChild(_cube);				_markerNodeMulti[i].addChild(_cube);			}										_oldDetectedNum = -1;						stage.addEventListener(MouseEvent.CLICK, _onClick);			addEventListener(Event.ENTER_FRAME, _onEnterFrame);		}				private function _onClick(e:MouseEvent):void {			mirror = !mirror;		}				private function _onEnterFrame(e:Event = null):void		{			// protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();					}	}}