/**
 * Copyright (c) 2016 Level Up Labs, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */

package monologue;

/**
 * ...
 * @author 
 */
@:allow(com.leveluplabs.tdrpg.monologue)
class MonologueTranslation
{
	public var code:String;
	public var data:Map<String,String>;
	
	public function new()
	{
		code = "";
		data = new Map<String,String>();
	}
	
	public static function fromJSON(json:Dynamic):MonologueTranslation
	{
		var mt = new MonologueTranslation();
		
		for (field in Reflect.fields(json))
		{
			var value = Reflect.field(json, field);
			if (Std.is(value, Array))
			{
				mt.code = field;
				var arr:Array<Dynamic> = cast value;
				for (entry in arr)
				{
					var flag:String = Reflect.hasField(entry, "flag") ? cast(Reflect.field(entry, "flag"), String) : "";
					var content:String = Reflect.hasField(entry, "content") ? cast(Reflect.field(entry, "content"), String) : "";
					if (flag != "")
					{
						mt.data.set(flag, content);
					}
				}
			}
		}
		
		return mt;
	}
}