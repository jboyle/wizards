package
{
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	
	public class FLARDetectedMarkerInfo
	{
		internal var _codeId:int;
		internal var _direction:int;
		internal var _confidence:Number;
		internal var _square:FLARSquare;
		internal var _transMat:FLARTransMatResult;
		
		public function FLARDetectedMarkerInfo(id:int=0,
												direction:int=0,
												confidence:Number=NaN,
												square:FLARSquare=null,
												transMat:FLARTransMatResult=null)
		{
			this._codeId = id;
			this._direction = direction;
			this._confidence = confidence;
			this._square = square;
			this._transMat = transMat;
		}
		
		public function get codeId():int { return _codeId; }
		public function get direction():int { return _direction; }
		public function get confidence():Number { return _confidence; }
		public function get square():FLARSquare { return _square; }
		public function get transMat():FLARTransMatResult { return _transMat;}
	}
}
