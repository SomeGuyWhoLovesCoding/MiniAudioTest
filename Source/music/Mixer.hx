package music;

import music.miniaudio.StdVectorString;
import cpp.ConstCharStar;
import utils.Tools;

@:buildXml('<include name="../../../miniaudioBuild.xml" />')
@:unreflective @:keep
@:include("./miniaudio/include/ma_thing.h")
extern class MiniAudio {
	@:native("destroy") static function destroy():Void;
	@:native("start") static function start():Void;
	@:native("stop") static function stop():Void;
	@:native("stopped") static function stopped():Int;

	@:runtime inline static function loadFiles(arr:Array<String>):Void {
		var vec = StdVectorString.fromStringArray(arr);
		//Sys.println("Loading files: " + vec.data());
		_loadFiles(vec);
	}
	@:native("loadFiles") static function _loadFiles(argv:StdVectorString):Void;

	@:native("getPlaybackPosition") static function getPlaybackPosition():Float;
	@:native("getDuration") static function getDuration():Float;
	@:native("getMixerState") static function getMixerState():Int;

	@:native("setPlaybackRate") static function setPlaybackRate(playbackRate:Float):Void;
	@:native("seekToPCMFrame") static function seekToPCMFrame(pos:cpp.Int64):Void;
	@:native("deactivate_decoder") static function deactivate_decoder(index:Int):Void;
	@:native("amplify_decoder") static function amplify_decoder(index:Int, volume:Float):Void;
}


/**
	# Music Playback Helper (Haxe + MiniAudio)

	This Haxe class is a **helper for managing music playback** using the **MiniAudio** library. It is tailored for **real-time applications**, such as games, and is designed with **performance and simplicity** in mind.

	---

	## 🎵 Core Features

	- Loads and manages **music files**
	- Allows starting and stopping of **music playback**
	- Tracks and adjusts **current playback time** to prevent drift
	- Smoothly updates playback time using **delta time**

	---

	## ⚙️ Design Details

	- Uses a default **sample rate of 44100 Hz** (can be adjusted)
	- Maintains:
	- Current **playback position**
	- Total **length** of the track
	- Utilizes the `MiniAudio` class for **low-level audio operations**

	### Main Methods:
	- `loadFiles()` – Initialize music from file paths
	- `startMusic()` / `stopMusic()` – Control playback
	- `destroyMusic()` – Clean up resources
	- `updateSmoothMusicTime()` – Prevent timing drift

	---

	## 🧠 Usage Considerations

	- Designed for **single-threaded use** (not thread-safe)
	- Optimized for **performance** (minimal overhead)
	- Intended for **real-time** playback (e.g., game loop)
	- Requires `MiniAudio` to be **properly initialized**
	- Should be used alongside other **music modules**
	- Handle **errors gracefully**, especially with file operations
	- Always call `destroyMusic()` when playback is no longer needed

	---

	## 📌 Notes

	- Acts as a **high-level abstraction** for music playback
	- Does **not** perform low-level audio processing directly
 */
class Mixer {
	public static inline var sampleRate:Int = 44100;

	static var time(get, set):Float;

	inline static function get_time() {
		return _time;
	}

	static var length(get, never):Float;

	inline static function get_length() {
		return _length;
	}

	private static var _time:Float;
	private static var _length:Float;

	static function set_time(value:Float) {
		MiniAudio.seekToPCMFrame(Tools.betterInt64FromFloat(value * 0.001) * sampleRate);
		return _time = MiniAudio.getPlaybackPosition();
	}

	static public function load(files:Array<String>):Void { // Don't rename this to `loadFiles` as it will conflict with the MiniAudio extern class
		MiniAudio.loadFiles(files);
		_length = MiniAudio.getDuration();
	}

	static public function startMusic():Void {
		MiniAudio.start();
	}

	static public function stopMusic():Void {
		MiniAudio.stop();
	}

	static public function destroyMusic():Void {
		MiniAudio.destroy();
	}

	static public function updateSmoothMusicTime(deltaTime:Float):Void {
		if (MiniAudio.getMixerState() == 1) {
			var rawPlaybackPosition = MiniAudio.getPlaybackPosition();
			var diff = rawPlaybackPosition - _time;
			var subtract = diff * 0.002;
			if (diff > 50) {
				_time = rawPlaybackPosition;
			} else {
				_time += deltaTime;
				//Sys.println(subtract);
				_time -= subtract;
				Sys.println('Time: $time, Drift Adjustment Value: $subtract');
			}
		}
	}
}