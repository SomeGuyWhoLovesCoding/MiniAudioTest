package;

import lime.app.Application;
import haxe.Int64;
import music.Mixer;
import lime.ui.KeyCode;

class Main extends Application
{
	override function onWindowCreate()
	{
		Mixer.load(Sys.args());
		Mixer.startMusic();

		window.onKeyDown.add(function(keycode, keymod) {
			switch (keycode) {
				case KeyCode.RETURN: // Space
					if (Mixer.isPlaying()) {
						Mixer.stopMusic();
					} else {
						Mixer.startMusic();
					}
				case KeyCode.UP: // Up Arrow
					Mixer.time += 1000;
				case KeyCode.DOWN: // Down Arrow
					Mixer.time -= 1000;
				case KeyCode.LEFT_BRACKET: // Lower playback rate
					Mixer.speed -= 0.1;
				case KeyCode.RIGHT_BRACKET: // Higher playback rate
					Mixer.speed += 0.1;
				case KeyCode.ESCAPE: // Escape
					Mixer.destroyMusic();
					Sys.exit(0);
				default:
			}
		});
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