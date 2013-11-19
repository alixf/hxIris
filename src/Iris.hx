import cpp.Lib;
import haxe.io.Bytes;
import haxe.io.BytesData;
import of.Context;
using of.Context.Functions;

class Color
{
	public function new(r, g, b, t)
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.t = t;
	}

	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var t:Float;

	public function toInt() : Int
	{
		return (255 << 24) + (this.r << 16) + (this.g << 8) + this.b;
	}

	public static function fromInt(int : Int) : Iris.Color
	{
		var R_MASK = 255<<16;
		var G_MASK = 255<<8;
		var B_MASK = 255;
		return new Iris.Color((int & R_MASK)>>16, (int & G_MASK)>>8, (int & B_MASK), 0.075);
	}
}

class Point
{
	public function new(x, y)
	{
		this.x = x;
		this.y = y;
	}

	public var x:Float;
	public var y:Float;
}

class Iris
{
	public static var GREEN		= new Color(117,196,83,0.1);
	public static var YELLOW	= new Color(255,255,57,0.15);
	public static var MAGENTA	= new Color(255,86,159,0.075);
	public static var BLUE 		= new Color(84,154,227,0.1);

	var webcam			: VideoGrabber;
	public var width(default, null) : Int;
	public var height(default, null) : Int;
	var color1			: Color;
	var color2			: Color;
	var p1				: Point;
	var p2				: Point;
	var position		: Point;
	var faceAngle 		: Float;
	var faceDistance	: Float;
	var frameSuccess 	: Bool;

	public function new(c1, c2)
	{
		webcam	= new VideoGrabber();
		width	= 640;
		height	= 480;
		color1  = c1;
		color2  = c2;
		p1 		= new Point(0,0);
		p2 		= new Point(0,0);
		position = new Point(0,0);
		
		webcam.setVerbose(true);
		webcam.setDesiredFrameRate(60);
		webcam.initGrabber(width,height);
	}
	
	public function update() : Bool
	{
		webcam.grabFrame();
		frameSuccess = webcam.isFrameNew();
		
		if (frameSuccess)
		{
			var pixels = webcam.getPixels();
			var pixelCount = width*height;
		
			p1 = getAverage(pixels, color1.r, color1.g, color1.b, 0.1);
			p2 = getAverage(pixels, color2.r, color2.g, color2.b, 0.1);

			faceDistance = 1 - (Math.sqrt((p2.x-p1.x)*(p2.x-p1.x)+(p2.y-p1.y)*(p2.y-p1.y)) / (Math.sqrt(width*width+height*height)+1));
			faceAngle = Math.atan2(p2.y-p1.y, p2.x-p1.x);
			
			p1.x /= width;
			p1.y /= height;
			p2.x /= width;
			p2.y /= height;
			position.x = p1.x+p2.x/2;
			position.y = p1.y+p2.y/2;
		}

		return frameSuccess;
	}

	public function circle(pixels, x, y, r, g, b)
	{
		for(xx in x-10...x+10)
		{
			for(yy in y-10...y+10)
			{
				var d = Math.sqrt((yy-y)*(yy-y)+(xx-x)*(xx-x));
				if(d < 10 && d > 7.5)
				{
					pixels[(yy*width+xx)*3] = cast r;
					pixels[(yy*width+xx)*3+1] = cast g;
					pixels[(yy*width+xx)*3+2] = cast b;
				}
			}
		}
	}

	public function getAverage(pixels, r, g, b, threshold)
	{
		var center = {x : 0, y : 0}
		var count = 0;

		for (i in 0...width*height)
		{
			// Pixel
			var index:Int = i * 3;
			var x:Int = i % width;
			var y:Int = cast (i / width);
			var pr:Int = cast pixels[index];
			var pg:Int = cast pixels[index+1];
			var pb:Int = cast pixels[index+2];

			var difference = (Math.abs(r-pr)/255 + Math.abs(g-pg)/255 + Math.abs(b-pb)/255) / 3;
		
			if(difference < threshold)
			{
				count++;
				center.x += x;
				center.y += y;
			}
		}

		if(count == 0)
		{
			frameSuccess = false;
			return new Point(0, 0);
		}
		return new Point(center.x/count, center.y/count);
	}

	public function getFaceAngle()
	{
		return faceAngle;
	}
	public function getFaceDistance()
	{
		return faceDistance;
	}
	public function getPixels()
	{
		return webcam.getPixels();
	}

	public function getLeftPointColor()
	{
		return color1;
	}
	public function getRightPointColor()
	{
		return color2;
	}
	public function setLeftPointColor(color)
	{
		color1 = color;
	}
	public function setRightPointColor(color)
	{
		color2 = color;
	}
	public function openSettings()
	{
		webcam.videoSettings();
	}
	public function getPoint1()
	{
		return p1;
	}
	public function getPoint2()
	{
		return p2;
	}
	public function getPosition()
	{
		return position;
	}
}