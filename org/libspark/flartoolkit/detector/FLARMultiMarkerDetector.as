﻿/*  * PROJECT: FLARToolKit * -------------------------------------------------------------------------------- * This work is based on the NyARToolKit developed by *   R.Iizuka (nyatla) * http://nyatla.jp/nyatoolkit/ * * The FLARToolKit is ActionScript 3.0 version ARToolkit class library. * Copyright (C)2008 Saqoosha * * This program is free software; you can redistribute it and/or * modify it under the terms of the GNU General Public License * as published by the Free Software Foundation; either version 2 * of the License, or (at your option) any later version. *  * This program is distributed in the hope that it will be useful, * but WITHOUT ANY WARRANTY; without even the implied warranty of * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the * GNU General Public License for more details. *  * You should have received a copy of the GNU General Public License * along with this framework; if not, write to the Free Software * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA *  * For further information please contact. *	http://www.libspark.org/wiki/saqoosha/FLARToolKit *	<saq(at)saqoosha.net> *  */package org.libspark.flartoolkit.detector {		import flash.display.BitmapData;	import flash.filters.ColorMatrixFilter;	import flash.geom.Point;	import flash.geom.Rectangle;		import org.libspark.flartoolkit.FLARException;	import org.libspark.flartoolkit.core.FLARSquare;	import org.libspark.flartoolkit.core.FLARSquareDetector;	import org.libspark.flartoolkit.core.FLARSquareStack;	import org.libspark.flartoolkit.core.IFLARSquareDetector;	import org.libspark.flartoolkit.core.match.FLARMatchPatt_Color_WITHOUT_PCA;	import org.libspark.flartoolkit.core.param.FLARParam;	import org.libspark.flartoolkit.core.pickup.FLARDynamicRatioColorPatt_O3;	import org.libspark.flartoolkit.core.pickup.IFLARColorPatt;	import org.libspark.flartoolkit.core.raster.FLARRaster_BitmapData;	import org.libspark.flartoolkit.core.raster.IFLARRaster;	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.FLARRasterFilter_BitmapDataThreshold;	import org.libspark.flartoolkit.core.transmat.FLARTransMat;	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;	import org.libspark.flartoolkit.core.transmat.IFLARTransMat;	import org.libspark.flartoolkit.core.types.FLARIntSize;		/**	 * 複数のマーカーを検出し、それぞれに最も一致するARコードを、コンストラクタで登録したARコードから 探すクラスです。	 * 最大300個を認識しますが、ゴミラベルを認識したりするので100個程度が限界です。	 * 	 */	 /**	 * 복수의 마커를 검출해, 각각 가장 일치하는 AR코드를, constructor　 　 으로 등록한 AR코드로부터 찾는 클래스입니다.	 * 최대 300개를 인식합니다만, 쓰레기 라벨을 인식하거나 하므로 100개 정도가 한계입니다.	 * 	 */	public class FLARMultiMarkerDetector {		private static const AR_SQUARE_MAX:int = 300;		private var _sizeCheckEnabled:Boolean = true;		private var _is_continue:Boolean = false;		private var _match_patt:FLARMatchPatt_Color_WITHOUT_PCA;		private var _square_detect:IFLARSquareDetector;		private const _square_list:FLARSquareStack = new FLARSquareStack(AR_SQUARE_MAX);		private var _codes:Array; // FLARCode[]		protected var _transmat:IFLARTransMat;		private var _marker_width:Array; // double[]		private var _number_of_code:int;		private var _globalThresholdLevel:int;		// 検出結果の保存用		//private var _patt:IFLARColorPatt;		// test		public var _patt:IFLARColorPatt;		private var _result_holder:FLARMultiMarkerDetectorResultHolder = new FLARMultiMarkerDetectorResultHolder();		/**		 * 複数のマーカーを検出し、最も一致するARCodeをi_codeから検索するオブジェクトを作ります。		 * 		 * @param i_param		 * カメラパラメータを指定します。		 * @param i_code	FLARCode[] 		 * 検出するマーカーのARCode配列を指定します。配列要素のインデックス番号が、そのままgetARCodeIndex関数で 得られるARCodeインデックスになります。 例えば、要素[1]のARCodeに一致したマーカーである場合は、getARCodeIndexは1を返します。		 * 先頭からi_number_of_code個の要素には、有効な値を指定する必要があります。		 * @param i_marker_width	double[] 		 * i_codeのマーカーサイズをミリメートルで指定した配列を指定します。 先頭からi_number_of_code個の要素には、有効な値を指定する必要があります。		 * @param i_number_of_code		 * i_codeに含まれる、ARCodeの数を指定します。		 * @throws FLARException		 */		 /**		 * 복수의 마커를 검출해, 가장 일치하는 ARCode를 i_code로부터 검색하는 오브젝트를 만듭니다.		 * 		 * @param i_param		 * 카메라 파라미터를 지정합니다.		 * @param i_code	FLARCode[] 		 * 검출하는 마커의 ARCode 배열을 지정합니다.배열 요소의 인덱스 번호가, 그대로 getARCodeIndex 함수로 얻을 수 있는 ARCode 인덱스가 됩니다.		 * 예를 들면, 요소[1]의 ARCode에 일치한 마커인 경우는, getARCodeIndex는 1을 돌려줍니다.		 * 선두로부터 i_number_of_code개의 요소에는, 유효한 값을 지정할 필요가 있습니다.		 * @param i_marker_width	double[] 		 * i_code의 마카사이즈를 밀리미터로 지정한 배열을 지정합니다. 선두로부터 i_number_of_code개의 요소에는, 유효한 값을 지정할 필요가 있습니다.		 * @param i_number_of_code		 * i_code에 포함되는, ARCode의 수를 지정합니다.		 * @throws FLARException		 */		 //public function FLARSingleMarkerDetector(i_param:FLARParam, i_code:FLARCode, i_marker_width:Number)		public function FLARMultiMarkerDetector(i_param:FLARParam, i_code:Array, i_marker_width:Array, i_number_of_code:int) {			const scr_size:FLARIntSize = i_param.getScreenSize();			// 解析オブジェクトを作る			this._square_detect = new FLARSquareDetector(i_param.getDistortionFactor(), scr_size);			this._transmat = new FLARTransMat(i_param);			// 比較コードを保存			this._codes = i_code;			// 比較コードの解像度は全部同じかな？（違うとパターンを複数種つくらないといけないから）			// 비교 코드의 해상도는 전부 같은가?(다르면 패턴을 복수종 재배하지 않으면 안 되니까)			const cw:int = i_code[0].getWidth();			const ch:int = i_code[0].getHeight();			for (var i:int = 1; i < i_number_of_code; i++) {				if (cw != i_code[i].getWidth() || ch != i_code[i].getHeight()) {					// 違う解像度のが混ざっている。					//throw new FLARException();					throw new FLARException("all patterns in an application must be the same width and height.");				}			}			// 評価パターンのホルダを作る // 평가 패턴의 홀더를 만든다			//this._patt = new FLARColorPatt_O3(cw, ch);				//var borderWidth:Number = (100 - 60) / 10;	// 60: Marker percentage			//var borderHeight:Number = (100 - 60) / 10;			this._patt = new FLARDynamicRatioColorPatt_O3(cw, ch, 50/10, 50/10);			this._number_of_code = i_number_of_code;			this._marker_width = i_marker_width;			// 評価器を作る。 // 평가기를 만든다.			this._match_patt = new FLARMatchPatt_Color_WITHOUT_PCA();			//２値画像バッファを作る //2치 화상 버퍼를 만든다//			this._bin_raster = new FLARBinRaster(scr_size.w, scr_size.h);			this._bin_raster = new FLARRaster_BitmapData(scr_size.w, scr_size.h);			}		private var _bin_raster:IFLARRaster;//		private var _tobin_filter:FLARRasterFilter_ARToolkitThreshold = new FLARRasterFilter_ARToolkitThreshold(100);		private var _tobin_filter:FLARRasterFilter_BitmapDataThreshold = new FLARRasterFilter_BitmapDataThreshold(100);		/**		 * i_imageにマーカー検出処理を実行し、結果を記録します。		 * 		 * @param i_raster		 * マーカーを検出するイメージを指定します。		 * @param i_thresh		 * 検出閾値を指定します。0～255の範囲で指定してください。 通常は100～130くらいを指定します。		 * @return 見つかったマーカーの数を返します。 マーカーが見つからない場合は0を返します。		 * @throws FLARException		 */		 /**		 * i_image에 마커 검출 처리를 실행해, 결과를 기록합니다.		 * 		 * @param i_raster		 * 마커를 검출하는 이미지를 지정합니다.		 * @param i_thresh		 * 검출 반응을 일으키는 최소의 물리량을 지정합니다.0255의 범위에서 지정해 주세요. 통상은 100~130 정도를 지정합니다.		 * @return 발견된 마커의 수를 돌려줍니다. 마커가 발견되지 않는 경우는 0을 돌려줍니다.		 * @throws FLARException		 */		public function detectMarkerLite(i_raster:IFLARRgbRaster, i_threshold:int):int {			// サイズチェック			if(this._sizeCheckEnabled && !this._bin_raster.getSize().isEqualSizeO(i_raster.getSize())) {				throw new FLARException("サイズ不一致(" + this._bin_raster.getSize() + ":" + i_raster.getSize());			}			// ラスタを２値イメージに変換する.			// SOC: threshold incoming image according to brightness.			//		passing -1 for threshold allows developers to apply custom thresholding algorithms			//		prior to passing source image to FLARToolkit.			if (i_threshold != -1) {				// apply FLARToolkit thresholding				this._tobin_filter.setThreshold(i_threshold);				this._tobin_filter.doFilter(i_raster, this._bin_raster);	// input=i_raster:IFLARRgbRaster																			// output=this._bin_raster:IFLARRaster					} else {				// copy source BitmapData as-is, without applying FLARToolkit thresholding				/*				dstBitmapData.copyPixels(srcBitmapData, srcBitmapData.rect, new Point());*/				var srcBitmapData:BitmapData = FLARRgbRaster_BitmapData(i_raster).bitmapData;				var dstBitmapData:BitmapData = FLARRaster_BitmapData(this._bin_raster).bitmapData;				var histoArray:Array;								// set the global threshold level				if(!PV3DARApp.gIsFirstDetectionDone)				{					histoArray = srcBitmapData.histogram(srcBitmapData.rect);	// R G B Alpha					var histoSum:int=0;					var pixelCnt:int=0;					for(i=0; i<256; i++)					{						pixelCnt += histoArray[0][i];						histoSum += (histoArray[0][i]*i);					}					_globalThresholdLevel = int(histoSum/pixelCnt);					trace("threshold: "+_globalThresholdLevel);				}								//var tempBitmapData:BitmapData = new BitmapData(srcBitmapData.width, srcBitmapData.height, false, 0x00);	// empty bitmapdata				var tempGrayBitmapData:BitmapData = new BitmapData(srcBitmapData.width, srcBitmapData.height, false, 0x00);					// gray image				tempGrayBitmapData.applyFilter(srcBitmapData, srcBitmapData.rect, new Point(),											new ColorMatrixFilter([0.2989, 0.5866, 0.1145, 0, 0, 0.2989, 0.5866, 0.1145, 0, 0, 0.2989, 0.5866, 0.1145, 0, 0, 0, 0, 0, 1, 0]));				// thresholding whole image 				dstBitmapData.fillRect(dstBitmapData.rect, 0x00);				dstBitmapData.threshold(tempGrayBitmapData, tempGrayBitmapData.rect, new Point(), '<=', _globalThresholdLevel, 0xffffffff, 0xff);												if(PV3DARApp.gIsFirstDetectionDone)				{					var rectTarget:Rectangle = new Rectangle();					var x1:int; var x2:int; var x3:int; var x4:int;					var y1:int; var y2:int; var y3:int; var y4:int;					var maxLength:int;					var centerX:int; var centerY:int;					var lengthArray:Array = new Array();					//var histoArray;					var localAverage:int=0;	var cnt:int=0;					var localAverageT1:int=0; var localAverageT2:int=0; var localAverageNew:int;					var cntT1:int;	var cntT2:int;					for(i=0; i<PV3DARApp._detectedNumFinal.length; i++)					{						x1 = PV3DARApp._detectedMarkers[i].square.imvertex[0].x;						y1 = PV3DARApp._detectedMarkers[i].square.imvertex[0].y;						x2 = PV3DARApp._detectedMarkers[i].square.imvertex[1].x;						y2 = PV3DARApp._detectedMarkers[i].square.imvertex[1].y;						x3 = PV3DARApp._detectedMarkers[i].square.imvertex[2].x;						y3 = PV3DARApp._detectedMarkers[i].square.imvertex[2].y;						x4 = PV3DARApp._detectedMarkers[i].square.imvertex[3].x;						y4 = PV3DARApp._detectedMarkers[i].square.imvertex[3].y;						centerX = int((x1+x2+x3+x4)/4); centerY = int((y1+y2+y3+y4)/4);						lengthArray.push((centerX-x1)*(centerX-x1)+(centerY-y1)*(centerY-y1));						lengthArray.push((centerX-x2)*(centerX-x2)+(centerY-y2)*(centerY-y2));						lengthArray.push((centerX-x3)*(centerX-x3)+(centerY-y3)*(centerY-y3));						lengthArray.push((centerX-x4)*(centerX-x4)+(centerY-y4)*(centerY-y4));						lengthArray.sort(Array.NUMERIC);						maxLength = int(Math.sqrt(lengthArray[3])*1.2);						rectTarget.x = centerX-maxLength;						rectTarget.y = centerY-maxLength;						rectTarget.width = rectTarget.height = maxLength+maxLength;						// check rectagle range						if(rectTarget.x<0)	rectTarget.x=0;						if(rectTarget.y<0)	rectTarget.y=0;						if((centerX+maxLength)>srcBitmapData.width)		rectTarget.width = srcBitmapData.width-centerX-1;						if((centerY+maxLength)>srcBitmapData.height)	rectTarget.height = srcBitmapData.height-centerY-1;												localAverage = 0;	cnt=0;						histoArray = tempGrayBitmapData.histogram(rectTarget);	// R G B Alpha	(People say histogram function is very slow)						for(var j:int=0; j<256; j++)						{							cnt += histoArray[0][j];							localAverage += histoArray[0][j]*j;						}						localAverage = int(localAverage/cnt);						// bimodal histogram						//while(1)						for (var maxIterate:int=0; maxIterate<4; maxIterate++)	// max 4 loops						{							localAverageT1 = localAverageT2 = cntT1 = cntT2 = 0;							for(j=0; j<256; j++)							{								if(histoArray[0][j] >= localAverage)								{									cntT1 += histoArray[0][j];									localAverageT1 += histoArray[0][j]*j;								}								else								{									cntT2 += histoArray[0][j];									localAverageT2 += histoArray[0][j]*j;								}							}							localAverageT1 = int(localAverageT1/cntT1);							localAverageT2 = int(localAverageT2/cntT2);							localAverageNew = int((localAverageT1+localAverageT2)*0.5);							if( Math.abs(localAverage-localAverageNew) <=10 )							{								localAverage = localAverageNew;								//trace("break!");								break;							}							else	localAverage = localAverageNew;						}									//trace("Average: "+localAverage);						dstBitmapData.threshold(tempGrayBitmapData, rectTarget, new Point(rectTarget.x, rectTarget.y), '<=', localAverage, 0xffffffff, 0xff);					}					lengthArray = null;					rectTarget = null;				}						}						var l_square_list:FLARSquareStack = this._square_list;			// スクエアコードを探す			// SOC: begin by detecting all possible markers ('square' outlines (may be rotated in any of three axes relative to camera))			this._square_detect.detectMarker(this._bin_raster, l_square_list);				const number_of_square:int = l_square_list.getLength();			// コードは見つかった？			if (number_of_square < 1) {				// ないや。おしまい。				// SOC: if no markers found, exit				return 0;			}			// 保持リストのサイズを調整			// SOC: ensure enough FLARMultiMarkerDetectorResult instances to hold all possible detected markers			this._result_holder.reservHolder(number_of_square);			// 1スクエア毎に、一致するコードを決定していく			// SOC: loop through all found squares and compare each with all possible patterns			var i:int; var j:int;			var square:FLARSquare;			var code_index:int;			var confidence:Number;			var direction:int;			var i2:int;			var c2:Number;			for (i = 0; i < number_of_square; i++) {				square = l_square_list.getItem(i) as FLARSquare;				// 評価基準になるパターンをイメージから切り出す				// SOC: attempt to read a possible pattern from this found square				// detect squares in binary image, matching square and marker in RGB image				if (!this._patt.pickFromRaster(i_raster, square)) {					// イメージの切り出しは失敗することもある。					// SOC: if a pattern cannot be extracted, skip to next square					continue;				}								// パターンを評価器にセット				// SOC: not clear on this part...				if (!this._match_patt.setPatt(this._patt)) {					// 計算に失敗した。					throw new FLARException();				}				// コードと順番に比較していく				// SOC: first, match against first pattern				code_index = 0;				_match_patt.evaluate(_codes[0]);	// matching square picked from raster and armarkers				confidence = _match_patt.getConfidence();				direction = _match_patt.getDirection();				//trace(i,0, confidence,"(",square.label.area,")");				for (i2 = 1;i2 < this._number_of_code; i2++) {					// コードと比較する					// SOC: then, match against each additional pattern, looking for the best possible match					_match_patt.evaluate(_codes[i2]);					c2 = _match_patt.getConfidence();					//trace(i, i2, c2,"(",square.label.area,")");					if (confidence > c2) {						continue;					}					// より一致するARCodeの情報を保存					// SOC: if a better match, store values					code_index = i2;					direction = _match_patt.getDirection();					confidence = c2;				}				// i番目のパターン情報を保存する。				// i번째의 패턴 정보를 보존한다.				// SOC: store the values corresponding to the best pattern match				var result:FLARMultiMarkerDetectorResult = this._result_holder.result_array[i];				result._codeId = code_index;				result._confidence = confidence;				result._direction = direction;				result._square = square;						}									return number_of_square;		}		/**		 * i_indexのマーカーに対する変換行列を計算し、結果値をo_resultへ格納します。 直前に実行したdetectMarkerLiteが成功していないと使えません。		 * 		 * @param i_index		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。		 * @param o_result		 * 結果値を受け取るオブジェクトを指定してください。		 * @throws FLARException		 */		 /**		 * i_index의 마커에 대한 변환 행렬을 계산해, 결과치를 o_result에 격납합니다. 직전에 실행한 detectMarkerLite가 성공하지 않았다고 사용할 수 없습니다.		 * 		 * @param i_index		 * 마커의 인덱스 번호를 지정합니다. 직전에 실행한 detectMarkerLite의 반환값 미만 한편 0이상일 필요가 있습니다.		 * @param o_result		 * 결과치를 받는 오브젝트를 지정해 주세요.		 * @throws FLARException		 */		public function getTransmationMatrix(i_index:int, o_result:FLARTransMatResult):void {			const result:FLARMultiMarkerDetectorResult = this._result_holder.result_array[i_index];			// 一番一致したマーカーの位置とかその辺を計算			if (_is_continue) {				_transmat.transMatContinue(result.square, result.direction, _marker_width[result.codeId], o_result);			} else {				_transmat.transMat(result.square, result.direction, _marker_width[result.codeId], o_result);			}			return;		}		public function getResult(i_index:int):FLARMultiMarkerDetectorResult		{			return this._result_holder.result_array[i_index];		}		/**		 * i_indexのマーカーの一致度を返します。		 * 		 * @param i_index		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。		 * @return マーカーの一致度を返します。0～1までの値をとります。 一致度が低い場合には、誤認識の可能性が高くなります。		 * @throws FLARException		 */		 /**		 * i_index의 마커의 일치도를 돌려줍니다.		 * 		 * @param i_index		 * 마커의 인덱스 번호를 지정합니다. 직전에 실행한 detectMarkerLite의 반환값 미만 한편 0이상일 필요가 있습니다.		 * @return 마커의 일치도를 돌려줍니다.01까지의 값을 받습니다. 일치도가 낮은 경우에는, 오인식의 가능성이 높아집니다.		 * @throws FLARException		 */		public function getConfidence(i_index:int):Number {			return this._result_holder.result_array[i_index].confidence;		}		/**		 * i_indexのマーカーの方位を返します。		 * 		 * @param i_index		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。		 * @return 0,1,2,3の何れかを返します。		 */		public function getDirection(i_index:int):int {			return this._result_holder.result_array[i_index].direction;		}		/**		 * i_indexのマーカーのARCodeインデックスを返します。		 * 		 * @param i_index		 * マーカーのインデックス番号を指定します。 直前に実行したdetectMarkerLiteの戻り値未満かつ0以上である必要があります。		 * @return		 */		public function getARCodeIndex(i_index:int):int {			// SOC: incorrect property name.			//return this._result_holder.result_array[i_index].arcode_id;			return this._result_holder.result_array[i_index].codeId;		}		/**		 * getTransmationMatrixの計算モードを設定します。		 * 		 * @param i_is_continue		 * TRUEなら、transMatContinueを使用します。 FALSEなら、transMatを使用します。		 */		public function setContinueMode(i_is_continue:Boolean):void {			this._is_continue = i_is_continue;		}				/**		 * 入力画像のサイズチェックをする／しない的な。（デフォルトではチェックする）		 */		public function get sizeCheckEnabled():Boolean {			return this._sizeCheckEnabled;		}		public function set sizeCheckEnabled(value:Boolean):void {			this._sizeCheckEnabled = value;		}				/**		 * SOC: added accessor for thresholded BitmapData of source image,		 * for use in debugging.		 */		public function get thresholdedBitmapData () :BitmapData {			try {				return FLARRaster_BitmapData(this._bin_raster).bitmapData;			} catch (e:Error) {				return null;			}						return null;		}				public function get labelingBitmapData () :BitmapData {			return FLARSquareDetector(this._square_detect).labelingBitmapData;		}	}}