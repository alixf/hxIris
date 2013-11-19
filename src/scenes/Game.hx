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

class Vegie extends Bitmap
{
	public var alive : Bool;
	var clock : Clock;
	var startX : Float;
	var endX : Float;
	var reach : Float;
	var delay : Float;
	var time : Float;
	var rot : Float;
	public var points : Int;

	public function new(id : Int, startX : Float, endX : Float, reach : Float, rot : Float, time : Float, delay : Float)
	{
		super(Assets.getBitmapData("assets/vegies/"+Game.VEGIESNAMES[id]+".png"));
		this.alive = true;
		this.clock = new Clock();
		this.clock.setFactor(1/time);
		this.reach = reach;
		this.startX = startX;
		this.endX = endX;
		this.rot = rot;
		this.time = time;
		this.delay = delay;
		this.points = Game.VEGIESPOINTS[id];
	}

	public function update()
	{
		var time = clock.getTime() - delay;
				
		var xx = time*(endX-startX)+startX;
		var yy = Lib.current.stage.stageHeight - (-(time*Math.sqrt(reach)*2-Math.sqrt(reach))*(time*Math.sqrt(reach)*2-Math.sqrt(reach))+reach);

		var m = new nme.geom.Matrix();
		m.identity();
		m.translate(-64, -64);
		m.rotate(time*rot / 180 * Math.PI);
		m.translate(64, 64);
		m.translate(xx, yy);	
		transform.matrix = m;
	}
}

class Game extends Scene
{
	var result : SceneType;

	var iris : Iris;
	var background : Bitmap;
	var aim : Bitmap;
	var vegies : Array<Vegie>;
	var waveClock : Clock;
	var waveTime : Float;
	var waveCount : Int;

	var points : Int;
	var combo : Int;

	var text : TextField;
	var hints : Sprite;

	var xAcc : Accumulator;
	var yAcc : Accumulator;

	static public var VEGIESNAMES =		["bell_pepper",	"broccoli",	"carrot",	"celery",	"eggplant",	"lettuce",	"mushroom",	"onion",	"potato",	"pumpkin",	"radish",	"sugar_snap",	"zucchini"];
	static public var VEGIESPOINTS =	[10,			15,			20,			25,			30,			35,			40,			45,			50,			55,			60,			65,				70];

	public function new(iris : Iris)
	{
		super();
		result = NONE;

		this.iris = iris;
		xAcc = new Accumulator(5);
		yAcc = new Accumulator(5);

		background = new Bitmap(Assets.getBitmapData("assets/background.png"));
		addChild(background);
		aim = new Bitmap(Assets.getBitmapData("assets/aim.png"));
		addChild(aim);

		vegies = new Array();
		waveClock = new Clock();
		waveCount = 1;
		buildWave(waveCount++, 10);

		points = 0;
		combo = 0;

		// Font
		var font = Assets.getFont("assets/arial.ttf");
		text = new TextField();
		text.defaultTextFormat = new TextFormat(font.fontName, 24);
		text.selectable = false;
		text.textColor = 0xFFFFFF;
		text.text = "Points : "+points+"\nCombo : "+combo;
		text.width = text.textWidth+6;
		text.height = text.textHeight+6;
		text.x = 15;
		text.y = 15;
		addChild(text);

		hints = new Sprite();
		hints.x = 0;
		hints.y = 0;
		hints.width = background.width;
		hints.height = background.height;
		addChild(hints);

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}
	
	override public function update() : SceneType
	{
		iris.update();
		xAcc.feed(iris.getPosition().x);
		yAcc.feed(iris.getPosition().y);
		var xx = (1-xAcc.value) * Lib.current.stage.stageWidth; 
		var yy = yAcc.value * Lib.current.stage.stageHeight;
		/*
		var xx = event.stageX;
		var yy = event.stageY;
		*/
		aim.x = xx - aim.width / 2;
		aim.y = yy - aim.height / 2;


		var hintsContent = hints.graphics;
		hintsContent.clear();
		hintsContent.lineStyle(3, 0xff0000);

		for(vegie in vegies)
		{
			var rect = vegie.getRect(Lib.current.stage);
			if(rect.contains(xx, yy))
			{
				if(vegie.alive)
				{
					vegie.alive = false;
					Actuate.tween(vegie, 1, {alpha : 0});
					Actuate.tween(vegie, 1, {scaleX : 2});
					Actuate.tween(vegie, 1, {scaleY : 2});
					combo++;
					var bonus = Std.int(vegie.points * (1+combo/10));
					points += bonus;

					var font = Assets.getFont("assets/arial.ttf");
					var text = new TextField();
					text.defaultTextFormat = new TextFormat(font.fontName, 32);
					text.selectable = false;
					text.textColor = 0xFFFFFF;
					text.text = "+"+bonus;
					text.width = text.textWidth+6;
					text.height = text.textHeight+6;
					text.x = xx - text.width / 2;
					text.y = yy - text.height;
					Actuate.tween(text, 1.5, {y : text.y-50});
					Actuate.tween(text, 1.5, {alpha : 0});
					Actuate.tween(text, 1.5, {scaleX : 1.5});
					Actuate.tween(text, 1.5, {scaleY : 1.5});
					addChild(text);
				}
			}
		}
		if(waveClock.getTime() > waveTime)
		{
			for(vegie in vegies)
			{
				if(vegie.alive)
					combo = 0;
			}

			if(waveCount > 10)
				waveCount = 1;
			buildWave(waveCount++, 10);
		}
		for(vegie in vegies)
			vegie.update();

		text.text = "Points : "+points+"\nCombo : "+combo;
		text.width = text.textWidth+6;
		text.height = text.textHeight+6;

		return result;
	}

	public function buildWave(vegieCount : Int, time : Float)
	{
		for(vegie in vegies)
			removeChild(vegie);

		vegies = new Array();
		waveTime = time;
		waveClock.reset();

		for(i in 0...vegieCount)
		{
			var vegie = new Vegie(Std.random(VEGIESNAMES.length),
								  	100 + Math.random() * (1180-100),
									100 + Math.random() * (1180-100),
									500 + Math.random() * (700-500),
									Math.random()*360,
									1.0 + Math.random() * (time-1.0),
									0.0);
			addChild(vegie);
			vegies.push(vegie);
		}
	}

	public function onKeyDown(event:KeyboardEvent):Void
	{
		if(event.charCode == 27)
			result = INTRO;
	}
}