package miniaudio;

@:include("./ma_thing.cpp")
@:buildXml('<include name="../../../build.xml" />')
extern class MiniAudio {
	@:native("init") public static function init():Void;
	@:native("destroy") public static function destroy():Void;
	@:native("start") public static function start():Void;
	@:native("stop") public static function stop():Void;
	@:native("setPlaybackRate") public static function setPlaybackRate(playbackRate:Float):Void;
	@:native("seekToPCMFrame") public static function seekToPCMFrame(pos:cpp.Int64):Void;
	@:native("stopped") public static function stopped():Int;
	@:runtime inline static function loadFiles(arr:Array<String>):Void {
		var vec = StdVectorString.fromStringArray(arr);
		//Sys.println("Loading files: " + vec.data());
		_loadFiles(vec);
	}
	@:native("loadFiles") public static function _loadFiles(argv:StdVectorString):Void;
	@:native("getPlaybackPosition") public static function getPlaybackPosition():Float;
	@:native("deactivate_decoder") public static function deactivate_decoder(index:Int):Void;
	@:native("amplify_decoder") public static function amplify_decoder(index:Int, volume:Float):Void;
}