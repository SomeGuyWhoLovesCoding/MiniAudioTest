// Taken from the genkit_miniaudio repository at https://github.com/alchemy-haxe/genkit_miniaudio/tree/main

package miniaudio.include;

@:keep
@:buildXml("
<xml>
	<pragma once=\"true\" />
	<set name=\"PROJECT_DIR\" value=\"${this_dir}/Source\" />

	<files id=\"haxe\">
		<compilerflag value=\"-I${PROJECT_DIR}/miniaudio\" />
	</files>

	<files id=\"miniaudio\">
		<compilerflag value=\"-I${PROJECT_DIR}/miniaudio\" />
		<compilerflag value=\"-I${PROJECT_DIR}/miniaudio/include\" />
		<compilerflag value=\"-I${PROJECT_DIR}/miniaudio/signalsmith-stretch\" />
	</files>

	<target id=\"haxe\">
		<files id=\"miniaudio\" />
	</target>
</xml>
")

@:cppFileCode('
    #include "./ma_thing.h"
')
class IncludeNative {

    public inline static function include() {}
    
}