package;

import lime.app.Application;
//import lime._internal.backend.native.NativeCFFI;
import miniaudio.MiniAudio;
import haxe.Int64;

class Main extends Application
{
	public static inline var sampleRate:Int = 44100;

	var playbackTrackingMethod:PlaybackTrackingMethod = HYBRID;

	private var _programPos:cpp.Float64;
	private var _driverPos:cpp.Float32;

	private var _playhead(default, null):Playhead = new Playhead();

	var time(get, set):Float;

	inline function get_time() {
		return _time;
	}

	var length(get, never):Float;

	inline function get_length() {
		return _length;
	}

	private var _time:Float;
	private var _length:Float;

	inline function set_time(value:Float) {
		MiniAudio.seekToPCMFrame(betterInt64FromFloat(value * 0.001) * sampleRate);
		return _time = MiniAudio.getPlaybackPosition();
	}

	public function new()
	{
		super();
		//NativeCFFI.miniaudio_init();
		var args:Array<String> = Sys.args();
		MiniAudio.loadFiles(args);
		_length = MiniAudio.getDuration();
		MiniAudio.start();
	}

	var newDeltaTimeSeconds:Int = 0;
	var newDeltaTime:Float = 0;

	override function update(deltaTime:Int64) {
		// The if check is to prevent the div operation from running every frame even though `newDeltaTimeSeconds` will be 0 most of the time
		newDeltaTimeSeconds = deltaTime < 1000000000 ? 0 : Int64.div(deltaTime, 1000000000).low;
		newDeltaTime = newDeltaTimeSeconds + (Int64.mod(deltaTime, 1000000000).low * 0.000001);

		if (MiniAudio.getMixerState() == 1) {
			var rawPlaybackPosition = MiniAudio.getPlaybackPosition();
			var diff = rawPlaybackPosition - _time;
			var subtract = diff * 0.002;
			if (diff > 50) {
				_time = rawPlaybackPosition;
			} else {
				_time += newDeltaTime;
				//Sys.println(subtract);
				_time -= subtract;
				Sys.println('Time: $time, Drift Adjustment Value: $subtract');
			}
		}

		super.update(deltaTime);
	}

	/**
		An optimized version of `haxe.Int64.fromFloat`. Only works on certain targets such as cpp, js, or eval.
	**/
	inline function betterInt64FromFloat(value:Float):Int64 {
		var high:Int = Math.floor(value / 4294967296);
		var low:Int = Math.floor(value);
		return Int64.make(high, low);
	}
}

/**
	Playback tracking method.
**/
private enum abstract PlaybackTrackingMethod(cpp.UInt8) {
	/**
		Playback position is retrieved from the current audio driver.
	**/
	var DRIVER = 0x40;

	/**
		Playback position is retrieved from the program.
		We don't recommend using this one.
	**/
	var PROGRAM = 0x01;

	/**
		Playback position is estimated.
	**/
	var HYBRID = 0x80;
}

/**
	Playback tracker.
**/
@:publicFields
private abstract Playhead(Array<Float>) from Array<Float> {
	var driver(get, set):Float;

	inline function get_driver():Float {
		return this[0];
	}

	inline function set_driver(value:Float):Float {
		return this[0] = value;
	}

	var program(get, set):Float;

	inline function get_program():Float {
		return this[1];
	}

	inline function set_program(value:Float):Float {
		return this[1] = value;
	}

	inline function new() {
		this = [0, 0];
	}
}