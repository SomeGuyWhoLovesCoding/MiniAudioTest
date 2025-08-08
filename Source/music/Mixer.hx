package music;

import miniaudio.MiniAudio;
import miniaudio.StdVectorString;
import cpp.ConstCharStar;
import utils.Tools;
import miniaudio.include.IncludeNative;

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
		IncludeNative.include();
		MiniAudio.seekToPCMFrame(Tools.betterInt64FromFloat(value * 0.001) * sampleRate);
		return _time = MiniAudio.getPlaybackPosition();
	}

	static public function load(files:Array<String>):Void { // Don't rename this to `loadFiles` as it will conflict with the MiniAudio extern class
		IncludeNative.include();
		MiniAudio.loadFiles(files);
		_length = MiniAudio.getDuration();
	}

	static public function startMusic():Void {
		IncludeNative.include();
		MiniAudio.start();
	}

	static public function stopMusic():Void {
		IncludeNative.include();
		MiniAudio.stop();
	}

	static public function destroyMusic():Void {
		IncludeNative.include();
		MiniAudio.destroy();
	}

	static public function updateSmoothMusicTime(deltaTime:Float):Void {
		IncludeNative.include();
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