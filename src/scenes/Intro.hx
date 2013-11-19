package scenes;

import nme.Lib;
import nme.Assets;
import nme.Assets;
import nme.display.Sprite;
import nme.display.Bitmap;
import nme.display.BitmapData;
import com.eclecticdesignstudio.motion.Actuate;

class Intro extends Scene
{
	var result : SceneType;

	var background : Bitmap;
	var logo : Bitmap;
	var nextButton : Button;
	var quitButton : Button;

	public function new()
	{
		super();
		result = NONE;
		
		// Background
		background = new Bitmap(new BitmapData(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, false, 0xDDDDDD));

		// Logo
		logo = new Bitmap(Assets.getBitmapData("assets/hxIris-logo.png"));
		logo.x = (background.width-logo.width)/2;
		logo.y = (background.height-logo.height)/20;

		// Next button
		nextButton = new Button("Next", 32, 0x202020, 0xFFFFFF);
		nextButton.x = Lib.current.stage.stageWidth - nextButton.width - 15;
		nextButton.y = Lib.current.stage.stageHeight - nextButton.height - 15;

		// Quit button
		quitButton = new Button("Quit", 32, 0x202020, 0xFFFFFF);
		quitButton.x = 15;
		quitButton.y = Lib.current.stage.stageHeight - quitButton.height - 15;

		// Animation
		var duration = 0.5;
		Actuate.apply(logo, {alpha : 0});
		Actuate.tween(logo, duration, {alpha : 1});
		Actuate.apply(nextButton, {alpha : 0});
		Actuate.tween(nextButton, duration, {alpha : 1});
		Actuate.apply(nextButton, {alpha : 0});
		Actuate.tween(nextButton, duration, {alpha : 1});

		// Actions
		nextButton.onClick = function()
		{
			Actuate.tween(logo, duration, {alpha : 0}).onComplete(goToCalibration);
			Actuate.tween(nextButton, duration, {alpha : 0});
			Actuate.tween(quitButton, duration, {alpha : 0});
		}
		quitButton.onClick = function()
		{
			Actuate.tween(logo, duration, {alpha : 0}).onComplete(goToExit);
			Actuate.tween(nextButton, duration, {alpha : 0});
			Actuate.tween(quitButton, duration, {alpha : 0});
		}

		// Add to scene
		addChild(background);
		addChild(logo);
		addChild(nextButton);
		addChild(quitButton);
	}
	
	override public function update() : SceneType
	{
		return result;
	}

	public function goToCalibration()
	{
		result = CALIBRATION;
	}
	public function goToExit()
	{
		result = EXIT;
	}
}