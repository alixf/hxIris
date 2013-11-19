import nme.Lib;
import nme.display.Sprite;
import nme.events.Event;

import scenes.Scene;
import scenes.SceneType;
import scenes.Intro;
import scenes.Calibration;
import scenes.Game;
import scenes.Game2;

class Main
{
	var scene : Scene;
	var iris : Iris;

	public function new()
	{
		iris = new Iris(Iris.MAGENTA, Iris.YELLOW);

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, update);

		scene = new Intro();
		Lib.current.stage.addChild(scene);
	}

	public function update(event : Event) : Void
	{
		switch(scene.update())
		{
		case EXIT :
			Lib.exit();
		case INTRO :
			Lib.current.stage.removeChild(scene);
			scene = new Intro();
			Lib.current.stage.addChild(scene);
		case CALIBRATION :
			Lib.current.stage.removeChild(scene);
			scene = new Calibration(iris);
			Lib.current.stage.addChild(scene);
		case GAME1 :
			Lib.current.stage.removeChild(scene);
			scene = new Game(iris);
			Lib.current.stage.addChild(scene);
		case GAME2 :
			Lib.current.stage.removeChild(scene);
			scene = new Game2(iris);
			Lib.current.stage.addChild(scene);
		default :
		}
	}
}