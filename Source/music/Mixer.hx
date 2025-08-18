package music;

import miniaudio.MiniAudio;
import miniaudio.StdVectorString;
import utils.Tools;

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
@:publicFields
class Mixer {
	static inline var sampleRate:Int = 44100;

	static var time(get, set):Float;

	inline static function get_time() {
		return _time;
	}

	static var length(get, never):Float;

	inline static function get_length() {
		return _length;
	}

	static var speed(default, set):Float = 1;

	static function set_speed(value:Float) {
		speed = Math.max(value, 0.1);
		MiniAudio.setPlaybackRate(speed);
		return speed;
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
		// Can't do it in pure c++ on hl so I removed this exact code from the hxcpp version to put this in here.
		if (MiniAudio.getMixerState() == MixerState.FINISHED) {
			MiniAudio.seekToPCMFrame(0);
		}
		MiniAudio.start();
	}

	static public function stopMusic():Void {
		MiniAudio.stop();
	}

	static public function destroyMusic():Void {
		MiniAudio.destroy();
	}

	static public function updateSmoothMusicTime(deltaTime:Float):Void {
		if (isPlaying()) {
			var rawPlaybackPosition = MiniAudio.getPlaybackPosition();
			_time += deltaTime;
			var multiply = 0.01; // Default drift adjustment value
			if (_time > rawPlaybackPosition) {
				while (_time - rawPlaybackPosition > multiply && /* Make sure not to overload your drift fixer */ multiply < 0.75) {
					multiply += 0.01; // Double the adjustment value if the drift is too large
				}
				var subtract = (_time - rawPlaybackPosition) * (multiply * speed);
				_time -= subtract;
			}
			Sys.println('Time: $time, Drift Adjustment Value: $multiply');
		}
	}

	static function isPlaying():Bool {
		return MiniAudio.getMixerState() == MixerState.PLAYING;
	}

	static function isStopped():Bool {
		return MiniAudio.stopped() == 1;
	}
}

enum abstract MixerState(Int) from Int to Int {
	/**
		- `0` - Stopped
		- `1` - Playing
		- `2` - Paused
		- `3` - Finished
	 */
	var PLAYING = 1;
	var STOPPED = 2;
	var FINISHED = 3;
}