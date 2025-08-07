package;

import lime.app.Application;
//import lime._internal.backend.native.NativeCFFI;
import miniaudio.MiniAudio;
import cpp.RawPointer;
import cpp.ConstCharStar;

class Main extends Application
{
	public function new()
	{
		super();
		//NativeCFFI.miniaudio_init();
		MiniAudio.init();
		var args:Array<String> = Sys.args();
		MiniAudio.loadFiles(args);
		MiniAudio.start();
	}

	override function update(deltaTime:haxe.Int64) {
		super.update(deltaTime);
		Sys.println(MiniAudio.getPlaybackPosition());
	}
}