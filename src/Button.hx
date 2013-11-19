import nme.Lib;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.BitmapData;
import nme.events.MouseEvent;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.geom.Rectangle;

enum State
{
	NORMAL;
	HOVER;
	CLICKED;
}

class Button extends Sprite
{

	var state : State;
	var text : TextField;
	var background : Bitmap;

	public var onClick : Void -> Void;
	public var onHover : Void -> Void;
	public var onLeave : Void -> Void;

	public function new(text, textSize, color, textColor)
	{
		super();
		buttonMode = true;

		state = NORMAL;
		var font = Assets.getFont("assets/arial.ttf");

		// Text
		this.text = new TextField();
		this.text.defaultTextFormat = new TextFormat(font.fontName, textSize);
		this.text.selectable = false;
		this.text.textColor = textColor;
		this.text.text = text;
		this.text.width = this.text.textWidth + 6;
		this.text.height = this.text.textHeight + 6;

		// Background
		background = new Bitmap(new BitmapData(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, false, color));
		background.width = this.text.width;
		background.height = this.text.height;

		addChild(background);
		addChild(this.text);

		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
		Lib.current.stage.addEventListener(MouseEvent.CLICK, click);

		// Init callbacks
		onClick = function(){};
		onHover = function(){};
		onLeave = function(){};
	}

	public function click(event: MouseEvent)
	{
		var rect = new Rectangle(x, y, width, height);
		if(rect.contains(event.stageX, event.stageY))
		{
			state = CLICKED;
			onClick();
		}
	}

	public function move(event: MouseEvent)
	{
		var rect = new Rectangle(x, y, width, height);
		if(rect.contains(event.stageX, event.stageY) && state != HOVER)
		{
			state = HOVER;
			onHover();
		}
		else if(state != NORMAL)
		{
			state = NORMAL;
			onLeave();
		}
	}
}