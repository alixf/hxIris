package scenes;

import nme.Lib;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.geom.Rectangle;
import nme.events.MouseEvent;
import nme.events.KeyboardEvent;
import com.eclecticdesignstudio.motion.Actuate;

class Object extends Bitmap
{
	public var xx : Float;
	public var yy : Float;
	public var depth : Float;

	public function new(bitmapData : BitmapData, x : Float, y : Float, depth : Float)
	{
		super(bitmapData);
		this.xx = x;
		this.yy = y;
		this.x = x;
		this.y = y;
		this.depth = depth;
	}
}

class Game2 extends Scene
{
	var result : SceneType;

	var iris : Iris;
	var xAcc : Accumulator;
	var yAcc : Accumulator;

	var o1 : Object;
	var o2 : Object;
	var o3 : Object;

	public function new(iris : Iris)
	{
		super();
		result = NONE;

		this.iris = iris;
		xAcc = new Accumulator(5);
		yAcc = new Accumulator(5);

		o3 = new Object(new BitmapData(100, 200, false, 0xFF0080), 600, 300, 100);
		o2 = new Object(new BitmapData(100, 200, false, 0x80FF00), 600, 300, 10);
		o1 = new Object(new BitmapData(100, 200, false, 0x0080FF), 600, 300, 5);

		addChild(o1);
		addChild(o2);
		addChild(o3);

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}
	
	override public function update() : SceneType
	{

		iris.update();
		xAcc.feed(iris.getPosition().x);
		yAcc.feed(iris.getPosition().y);

		o1.x =  o1.xx + ((1 / o1.depth) * -((xAcc.value*2)-1) * Lib.current.stage.stageWidth / 2);
		o1.y =  o1.yy + ((1 / o1.depth) * ((yAcc.value*2)-1) * Lib.current.stage.stageWidth / 2);
		o2.x =  o2.xx + ((1 / o2.depth) * -((xAcc.value*2)-1) * Lib.current.stage.stageWidth / 2);
		o2.y =  o2.yy + ((1 / o2.depth) * ((yAcc.value*2)-1) * Lib.current.stage.stageWidth / 2);
		o3.x =  o3.xx + ((1 / o3.depth) * -((xAcc.value*2)-1) * Lib.current.stage.stageWidth / 2);
		o3.y =  o3.yy + ((1 / o3.depth) * ((yAcc.value*2)-1) * Lib.current.stage.stageWidth / 2);

		return result;
	}

	public function onKeyDown(event:KeyboardEvent):Void
	{
		if(event.charCode == 27)
			result = INTRO;
	}
} 