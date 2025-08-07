package;

import lime.app.Application;
import haxe.Int64;
import music.Mixer;

class Main extends Application
{
	public function new()
	{
		super();

		Mixer.load(Sys.args());
		Mixer.startMusic();
	}

	var newDeltaTimeSeconds:Int = 0;
	var newDeltaTime:Float = 0;

	override function update(deltaTime:Int64) {
		// The if check is to prevent the div operation from running every frame even though `newDeltaTimeSeconds` will be 0 most of the time
		newDeltaTimeSeconds = deltaTime < 1000000000 ? 0 : Int64.div(deltaTime, 1000000000).low;
		newDeltaTime = newDeltaTimeSeconds + (Int64.mod(deltaTime, 1000000000).low * 0.000001);

		Mixer.updateSmoothMusicTime(newDeltaTime);
		super.update(deltaTime);
	}
}