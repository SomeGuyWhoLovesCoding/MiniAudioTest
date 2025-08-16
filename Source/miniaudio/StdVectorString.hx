package miniaudio;

#if cpp
import cpp.RawPointer;
import cpp.ConstCharStar;

@:keep
@:unreflective
@:structAccess
@:include('vector')
@:native('std::vector<const char*>')
extern class StdVectorString
{
    @:native('std::vector<const char*>')
    static function create() : StdVectorString;

    @:runtime inline static function fromStringArray(arr:Array<String>):StdVectorString {
        var vec = StdVectorString.create();
        for (s in arr) {
            vec.push_back(ConstCharStar.fromString(s));
        }
        return vec;
    }

    function push_back(_string : ConstCharStar) : Void;

    function data() : RawPointer<ConstCharStar>;

    function size() : Int;
}
#elseif hl
typedef ConstCharStar = hl.Abstract<"const char*">;
@:native('std::vector<const char*>')
class StdVectorString
{
    public static function create() : StdVectorString {return null;}

    @:runtime inline public static function fromStringArray(arr:Array<String>):StdVectorString {
        var vec = StdVectorString.create();
        for (s in arr) {
            vec.push_back(untyped s.bytes);
        }
        return vec;
    }

    public function push_back(_string : ConstCharStar) : Void {}

    public function data() : hl.Ref<ConstCharStar> {return null;}

    public function size() : Int {return 0;};
}
#end