package com.wizards.levels.scenarios.views
{
	import com.wizards.levels.View;
	import flash.display.MovieClip;
	
	public class V2S_trainingView extends View
	{
		public function V2S_trainingView()
		{
			super();
			var trainingSymbol:MovieClip = new TrainingSymbol1();
			trainingSymbol.x = 400; trainingSymbol.y=300;
			this.addChild(trainingSymbol);
		}
		
		override public function update():void
		{
			super.update();
			
		}

	}
}