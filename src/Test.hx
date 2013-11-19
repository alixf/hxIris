import cpp.Lib;
import haxe.io.Bytes;
import haxe.io.BytesData;
import of.Context;
using of.Context.Functions;

class Test extends of.app.BaseApp
{
	var webcam			: VideoGrabber;
	var width			: Int;
	var height			: Int;
	var faceAngle 		: Float;
	var faceDistance	: Float;

	var videoData:BytesData;
	var videoTexture:Texture;

	static var GREEN = {r:117, g:196, b:83, t:0.1};
	static var YELLOW = {r:200, g:200, b:30, t:0.15};
	static var MAGENTA = {r:234, g:44, b:178, t:0.15};
	static var BLUE = {r:84, g:154, b:227, t:0.1};

	override public function setup():Void
	{
		webcam	= new VideoGrabber();
		width	= 640;
		height	= 480;
		
		webcam.setVerbose(true);
		webcam.initGrabber(width,height);
		
		videoData 	= Bytes.alloc(width * height * 3).getData();
		videoTexture = new Texture();
		videoTexture.allocate(width, height, Constants.GL_RGB);
	}
	
	override public function update():Void
	{
		background(100,100,100);
		
		webcam.grabFrame();
		
		if (webcam.isFrameNew())
		{
			var pixels = webcam.getPixels();
			var pixelCount = width*height;

			for (i in 0...pixelCount)
			{
				var index:Int = i*3;
				var r:Int = cast pixels[index];
				var g:Int = cast pixels[index+1];
				var b:Int = cast pixels[index+2];
				videoData[index] = cast (cast(r, Int)*0.2);
				videoData[index+1] = cast (cast(g, Int)*0.2);
				videoData[index+2] = cast (cast(b, Int)*0.2);
			}
			
			//var green = getAverage(117, 196, 83, 0.1);
			//circle(green.x, green.y, videoData, 117, 196, 83);
			
			var yellow = getAverage(pixels, videoData, YELLOW.r, YELLOW.g, YELLOW.b, YELLOW.t);
			circle(yellow.x, yellow.y, videoData, YELLOW.r, YELLOW.g, YELLOW.b);
			
			var magenta = getAverage(pixels, videoData, MAGENTA.r, MAGENTA.g, MAGENTA.b, MAGENTA.t);
			circle(magenta.x, magenta.y, videoData, MAGENTA.r, MAGENTA.g, MAGENTA.b);

			//var blue = getAverage(84, 154, 227, 0.1);
			//circle(blue.x, blue.y, videoData, 84, 154, 227);

			var p1 = yellow;
			var p2 = magenta;

			faceDistance = 1 - (Math.sqrt((p2.x-p1.x)*(p2.x-p1.x)+(p2.y-p1.y)*(p2.y-p1.y)) / (Math.sqrt(width*width+height*height)+1));
			faceAngle = Math.atan2(p2.y-p1.y, p2.x-p1.x);

			videoTexture.loadData(videoData, width, height, Constants.GL_RGB);
		}
	}

	public function circle(px, py, pixels, r, g, b)
	{
		for(x in px-10...px+10)
		{
			for(y in py-10...py+10)
			{
				var d = Math.sqrt((y-py)*(y-py)+(x-px)*(x-px));
				if(d < 10 && d > 7.5)
				{
					pixels[(y*width+x)*3] = cast r;
					pixels[(y*width+x)*3+1] = cast g;
					pixels[(y*width+x)*3+2] = cast b;
				}
			}
		}
	}

	public function getAverage(pixels, videoData, r, g, b, threshold)
	{
		var pixelCount = width*height;

		// var bbox = {t : height, b : 0, l : width, r : 0};
		var center = {x : 0, y : 0}
		var count = 0;

		// Reference color
		var rr:Int = r;
		var rg:Int = g;
		var rb:Int = b;

		for (i in 0...pixelCount)
		{
			// pixel position
			var x:Int = i % width;
			var y:Int = cast (i / width);

			// Pixel's index
			var index:Int = i*3;

			// Pixel's components
			var r:Int = cast pixels[index];
			var g:Int = cast pixels[index+1];
			var b:Int = cast pixels[index+2];

			var difference = (abs(rr-r)/255 + abs(rg-g)/255 + abs(rb-b)/255)/3;
			if(difference < threshold)
			{
				videoData[index] = cast rr;
				videoData[index+1] = cast rg;
				videoData[index+2] = cast rb;
				/*
				if(bbox.t > y) bbox.t = y;
				if(bbox.b < y) bbox.b = y;
				if(bbox.l > x) bbox.l = x;
				if(bbox.r < x) bbox.r = x;
				*/
				count++;
				center.x += x;
				center.y += y;
			}
		}
		/*
		// Draw bounding bbox
		if(bbox.r > bbox.l && bbox.b > bbox.t)
		{
			for(i in bbox.l...bbox.r)
			{
				videoData[(bbox.t*width+i)*3] = cast r;
				videoData[(bbox.t*width+i)*3+1] = cast g;
				videoData[(bbox.t*width+i)*3+2] = cast b;
				videoData[(bbox.b*width+i)*3] = cast r;
				videoData[(bbox.b*width+i)*3+1] = cast g;
				videoData[(bbox.b*width+i)*3+2] = cast b;
			}
			for(i in bbox.t...bbox.b)
			{
				videoData[(i*width+bbox.l)*3] = cast r;
				videoData[(i*width+bbox.l)*3+1] = cast g;
				videoData[(i*width+bbox.l)*3+2] = cast b;
				videoData[(i*width+bbox.r)*3] = cast r;
				videoData[(i*width+bbox.r)*3+1] = cast g;
				videoData[(i*width+bbox.r)*3+2] = cast b;
			}
		}
		*/
		return {x:Std.int(center.x/count), y:Std.int(center.y/count)};
	}
	
	override public function draw():Void
	{
		setHexColor(0xffffff);
		webcam.draw(0,0);
		videoTexture.draw(width,0, width, height);
	}
	
	override public function keyPressed(key:Int):Void
	{
		// in fullscreen mode, on a pc at least, the 
		// first time video settings the come up
		// they come up *under* the fullscreen window
		// use alt-tab to navigate to the settings
		// window. we are working on a fix for this...
		
		if (key == 's'.charCodeAt(0) || key == 'S'.charCodeAt(0))
		{
			webcam.videoSettings();
		}
	}
	
	public static function main():Void
	{
		AppRunner.setupOpenGL(new of.app.AppGlutWindow(), 1280, 480, Constants.OF_WINDOW);
		AppRunner.runApp(new Test());
	}
}