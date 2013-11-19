package scenes;

import nme.Lib;
import nme.Assets;
import nme.events.Event;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.events.MouseEvent;
import nme.events.KeyboardEvent;
import com.eclecticdesignstudio.motion.Actuate;

class Calibration extends Scene
{
	var iris : Iris;
	var result : SceneType;

	var background : Bitmap;
	var nextButton : Button;
	var next2Button : Button;
	var previousButton : Button;

	var camPreview : Bitmap;
	var colorToSet : Int;
	var lPatch : Bitmap;
	var rPatch : Bitmap;
	var title : TextField;
	var stats : TextField;
	var hints : Sprite;
	var icon : Bitmap;
	var xAcc : Accumulator;
	var yAcc : Accumulator;
	var aAcc : Accumulator;
	var zAcc : Accumulator;

	public function new(iris : Iris)
	{
		super();
		result = NONE;
		this.iris = iris;
		colorToSet = 0;

		// Background
		background = new Bitmap(new BitmapData(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, false, 0xDDDDDD));

		// Next2 button
		next2Button = new Button("Example 2", 32, 0x202020, 0xFFFFFF);
		next2Button.x = Lib.current.stage.stageWidth - next2Button.width - 15;
		next2Button.y = Lib.current.stage.stageHeight - next2Button.height - 15;
		// Next button
		nextButton = new Button("Example 1", 32, 0x202020, 0xFFFFFF);
		nextButton.x = Lib.current.stage.stageWidth - next2Button.width - nextButton.width - 15 - 15;
		nextButton.y = Lib.current.stage.stageHeight - nextButton.height - 15;

		// Previous button
		previousButton = new Button("Previous", 32, 0x202020, 0xFFFFFF);
		previousButton.x = 15;
		previousButton.y = Lib.current.stage.stageHeight - previousButton.height - 15;

		// Webcam preview
		camPreview = new Bitmap(new BitmapData(640, 480, false, 0xffffff));
		camPreview.x = Lib.current.stage.stageWidth/2 - camPreview.width/2;
		camPreview.y = 50;

		// Patches
		lPatch = new Bitmap(new BitmapData(210, 50, false, iris.getLeftPointColor().toInt()));
		lPatch.x = camPreview.x;
		lPatch.y = camPreview.y + camPreview.height + 25;
		rPatch = new Bitmap(new BitmapData(210, 50, false, iris.getRightPointColor().toInt()));
		rPatch.x = camPreview.x + camPreview.width - rPatch.width;
		rPatch.y = camPreview.y + camPreview.height + 25;

		// Font
		var font = Assets.getFont("assets/arial.ttf");

		// Title
		title = new TextField();
		title.defaultTextFormat = new TextFormat(font.fontName, 24);
		title.selectable = false;
		title.textColor = 0;
		title.text = "Calibration";
		title.width = title.textWidth*1.2;
		title.height = title.textHeight*1.2;
		title.x = Lib.current.stage.stageWidth/2 - title.textWidth/2;
		title.y = 10;

		// Statistics
		stats = new TextField();
		stats.defaultTextFormat = new TextFormat(font.fontName, 18);
		stats.selectable = false;
		stats.textColor = 0x202020;
		stats.text = "Stats loading ...";
		stats.width = stats.textWidth*1.2;
		stats.height = stats.textHeight*1.2;
		stats.x = camPreview.x + camPreview.width + 10;
		stats.y = camPreview.y;

		// Hints
		hints = new Sprite();
		hints.x = camPreview.x;
		hints.y = camPreview.y;
		hints.width = camPreview.width;
		hints.height = camPreview.height;

		xAcc = new Accumulator(3);
		yAcc = new Accumulator(3);
		aAcc = new Accumulator(3);
		zAcc = new Accumulator(3);

		// Icon
		icon = new Bitmap(Assets.getBitmapData("assets/nme.png"));
		icon.x = 1000;
		icon.y = 400;

		// Events
		Lib.current.stage.addEventListener(MouseEvent.CLICK, onClick);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

		// Animation
		var duration = 0.5;
		Actuate.apply(camPreview, {alpha : 0});
		Actuate.tween(camPreview, duration, {alpha : 1});
		Actuate.apply(lPatch, {alpha : 0});
		Actuate.tween(lPatch, duration, {alpha : 1});
		Actuate.apply(rPatch, {alpha : 0});
		Actuate.tween(rPatch, duration, {alpha : 1});
		Actuate.apply(title, {alpha : 0});
		Actuate.tween(title, duration, {alpha : 1});
		Actuate.apply(stats, {alpha : 0});
		Actuate.tween(stats, duration, {alpha : 1});
		Actuate.apply(hints, {alpha : 0});
		Actuate.tween(hints, duration, {alpha : 1});
		Actuate.apply(icon, {alpha : 0});
		Actuate.tween(icon, duration, {alpha : 1});
		Actuate.apply(nextButton, {alpha : 0});
		Actuate.tween(nextButton, duration, {alpha : 1});
		Actuate.apply(next2Button, {alpha : 0});
		Actuate.tween(next2Button, duration, {alpha : 1});
		Actuate.apply(previousButton, {alpha : 0});
		Actuate.tween(previousButton, duration, {alpha : 1});

		// Actions
		nextButton.onClick = function()
		{
			Actuate.tween(camPreview, duration, {alpha : 0}).onComplete(goToGame1);
			Actuate.tween(lPatch, duration, {alpha : 0});
			Actuate.tween(rPatch, duration, {alpha : 0});
			Actuate.tween(title, duration, {alpha : 0});
			Actuate.tween(stats, duration, {alpha : 0});
			Actuate.tween(hints, duration, {alpha : 0});
			Actuate.tween(icon, duration, {alpha : 0});
			Actuate.tween(nextButton, duration, {alpha : 0});
			Actuate.tween(next2Button, duration, {alpha : 0});
			Actuate.tween(previousButton, duration, {alpha : 0});
		}
		next2Button.onClick = function()
		{
			Actuate.tween(camPreview, duration, {alpha : 0}).onComplete(goToGame2);
			Actuate.tween(lPatch, duration, {alpha : 0});
			Actuate.tween(rPatch, duration, {alpha : 0});
			Actuate.tween(title, duration, {alpha : 0});
			Actuate.tween(stats, duration, {alpha : 0});
			Actuate.tween(hints, duration, {alpha : 0});
			Actuate.tween(icon, duration, {alpha : 0});
			Actuate.tween(nextButton, duration, {alpha : 0});
			Actuate.tween(next2Button, duration, {alpha : 0});
			Actuate.tween(previousButton, duration, {alpha : 0});
		}
		previousButton.onClick = function()
		{
			Actuate.tween(camPreview, duration, {alpha : 0}).onComplete(goToIntro);
			Actuate.tween(lPatch, duration, {alpha : 0});
			Actuate.tween(rPatch, duration, {alpha : 0});
			Actuate.tween(title, duration, {alpha : 0});
			Actuate.tween(stats, duration, {alpha : 0});
			Actuate.tween(hints, duration, {alpha : 0});
			Actuate.tween(icon, duration, {alpha : 0});
			Actuate.tween(nextButton, duration, {alpha : 0});
			Actuate.tween(next2Button, duration, {alpha : 0});
			Actuate.tween(previousButton, duration, {alpha : 0});
		}

		// Add to scene
		addChild(background);
		addChild(camPreview);
		addChild(lPatch);
		addChild(rPatch);
		addChild(title);
		addChild(stats);
		addChild(hints);
		addChild(icon);
		addChild(nextButton);
		addChild(next2Button);
		addChild(previousButton);		
	}

	override public function update() : SceneType
	{
		// Clear hints
		var hintsContent = hints.graphics;
		hintsContent.clear();

		if(iris.update())
		{
			// Update data
			var p1 = iris.getPoint1();
			var p2 = iris.getPoint2();
			var pos = iris.getPosition();
			var a = iris.getFaceAngle();
			var z = iris.getFaceDistance();

			// Feed accumulators
			xAcc.feed(pos.x);
			yAcc.feed(pos.y);
			aAcc.feed(a);
			zAcc.feed(z);

			// Update statistics
			stats.text = "Statistics : \n";
			stats.text += "p1  = ("+p1.x+";"+p1.y+")"+"\n";
			stats.text += "p2  = ("+p2.x+";"+p2.y+")"+"\n";
			stats.text += "pos = ("+pos.x+";"+pos.y+")"+"\n";
			stats.text += "a   = "+a+"\n";
			stats.text += "z   = "+z+"\n";
			stats.text += "\n";
			stats.text += "Smoothed values : \n";
			stats.text += "pos = ("+xAcc.value+";"+yAcc.value+")"+"\n";
			stats.text += "a   = "+aAcc.value+"\n";
			stats.text += "z   = "+zAcc.value+"\n";
			stats.width = stats.textWidth*1.2;
			stats.height = stats.textHeight*1.2;
		
			// Draw hints
			hintsContent.lineStyle(3, 0xff0000);
			hintsContent.moveTo(p1.x * camPreview.width, p1.y * camPreview.height);
			hintsContent.lineTo(p2.x * camPreview.width, p2.y * camPreview.height);
			hintsContent.lineStyle(1.5, iris.getLeftPointColor().toInt());
			hintsContent.drawCircle(p1.x * camPreview.width, p1.y * camPreview.height, 10);
			hintsContent.lineStyle(1.5, iris.getRightPointColor().toInt());
			hintsContent.drawCircle(p2.x * camPreview.width, p2.y * camPreview.height, 10);
		}
		

		// Update webcam preview
		var pixelsSrc = iris.getPixels();
		for(x in 0...iris.width)
		{
			for(y in 0...iris.height)
			{
				var i = (y*iris.width+x)*3;
				var color = (127 << 24) + ((cast pixelsSrc[i]) << 16) + ((cast pixelsSrc[i+1]) << 8) + (cast pixelsSrc[i+2]);
				camPreview.bitmapData.setPixel(x, y, color);
			}
		}

		// Update icon
		var m = new nme.geom.Matrix();
		m.identity();
		m.translate(-40, -40);
		m.rotate(-aAcc.value);
		m.translate(40, 40);
		m.scale(1.5-zAcc.value, 1.5-zAcc.value);
		m.translate(1000 + (256 - xAcc.value * 256), 400 + yAcc.value * 192);
		icon.transform.matrix = m;

		return result;
	}

	public function onClick(event: MouseEvent)
	{
		if (event.stageX >= camPreview.x && event.stageX < camPreview.x+camPreview.width &&
			event.stageY >= camPreview.y && event.stageY < camPreview.y+camPreview.height)
		{
			var x = Std.int(event.stageX - camPreview.x);
			var y = Std.int(event.stageY - camPreview.y);
			var color = camPreview.bitmapData.getPixel(x, y);

			if(colorToSet == 0)
			{
				iris.setLeftPointColor(Iris.Color.fromInt(color));
				lPatch.bitmapData.fillRect(lPatch.bitmapData.rect, color);
				colorToSet = 1;
			}
			else
			{
				iris.setRightPointColor(Iris.Color.fromInt(color));
				rPatch.bitmapData.fillRect(rPatch.bitmapData.rect, color);
				colorToSet = 0;
			}
		}
	}

	public function onKeyDown(event:KeyboardEvent):Void
	{
		if (event.charCode == 's'.charCodeAt(0) || event.charCode == 'S'.charCodeAt(0))
		{
			iris.openSettings();
		}
	}

	public function goToGame1()
	{
		result = GAME1;
	}
	public function goToGame2()
	{
		result = GAME2;
	}

	public function goToIntro()
	{
		result = INTRO;
	}
}