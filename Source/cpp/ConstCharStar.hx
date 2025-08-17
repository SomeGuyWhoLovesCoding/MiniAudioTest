package cpp;

#if cpp
extern abstract ConstCharStar(RawConstPointer<Char>) to(RawConstPointer<Char>) {
	inline function new(s:String)
		this = untyped s.__s;

	@:from
	static public inline function fromString(s:String):ConstCharStar
		return new ConstCharStar(s);

	@:to extern public inline function toString():String
		return new String(untyped this);

	@:to extern public inline function toPointer():RawConstPointer<Char>
		return this;
}
#elseif hl
typedef ConstCharStarPtr = hl.Abstract<"const char*">;
abstract ConstCharStar(ConstCharStarPtr) {
    static function fromString(s:String):ConstCharStar {
        return ;
    }
}
#end