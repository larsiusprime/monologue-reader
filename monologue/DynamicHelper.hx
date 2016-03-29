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

class DynamicHelper
{

	/**
	 * Safely processes the values in an array field from this JSON object by applying a lambda
	 * @param	json	the JSON object you want to read from
	 * @param	fieldName	the field name you want to read
	 * @param	lambda	a function to process the array values
	 * @return	the processed data, or null if the field does not exist
	 */
	
	public static function jsonArray(json:Dynamic, fieldName:String, lambda:Array<Dynamic>->Dynamic):Dynamic
	{
		if (Reflect.hasField(json, fieldName))
		{
			var values = Reflect.field(json, fieldName);
			if (Std.is(values, Array))
			{
				return lambda(values);
			}
		}
		return null;
	}
	
	/**
	 * Safely reads a field value from this JSON object with a default fallback
	 * @param	j	the JSON object you want to read from
	 * @param	field	the field name you want to get
	 * @param	defaultValue	the default value to use if the field doesn't exist
	 * @return	the value in the field, or defaultValue if it doesn't exist
	 */
	
	public static function jsonVar(j:Dynamic, field:String, defaultValue:String=""):String
	{
		return Reflect.hasField(j, field) ? Reflect.field(j, field) : defaultValue;
	}
	
	/**
	 * Converts any basic value into a bool
	 * Int:      1  -> true, else  -> false
	 * Float:  1.0  -> true, else  -> false
	 * Bool:   true -> true, false -> false
	 * String: "true" or "1" -> true, else -> false
	 * null:   false
	 * all other values & types: always false
	 * 
	 * @param val the input value
	 * @return the converted bool value
	 */
	
	public static function toBool(val:Dynamic):Bool
	{
		var b:Bool = false;
		
		if (val == null)
			b = false;
		else if (Std.is(val, Int))
			b = cast(val, Int) == 1;
		else if (Std.is(val, Float))
			b = cast(val, Int) == 1.0;
		else if (Std.is(val, Bool))
			b = cast val;
		else if (Std.is(val, String))
		{
			var str:String = Std.string(val).toLowerCase();
			b = str == "true" || str == "1";
		}
		return b;
	}
	
	/**
	 * Converts any basic value into an int
	 * Int:    same
	 * Float:  truncates decimal
	 * Bool:   true -> 1, false -> 0
	 * String: runs Std.parseInt
	 * null:   0
	 * all other values & types: 0
	 * 
	 * @param	val the input value
	 * @return the converted int value
	 */
	
	public static function toInt(val:Dynamic):Int
	{
		var i:Int = 0;
		if (val == null)
			i = 0;
		else if (Std.is(val, Int))
			i = cast(val,Int);
		else if (Std.is(val, Float))
			i = Std.int(cast(val,Float));
		else if (Std.is(val, Bool))
			i = (cast(val, Bool) == true) ? 1 : 0;
		else if (Std.is(val, String))
			i = Std.parseInt(cast(val, String));
		return i;
	}
	
	/**
	 * Converts any basic value into a float
	 * Int:    same
	 * Float:  same
	 * Bool:   true -> 1.0, false -> 0.0
	 * String: runs Std.parseFloat
	 * null:   0.0
	 * all other values & types: 0.0
	 * 
	 * @param	val
	 * @return
	 */
	
	public static function toFloat(val:Dynamic):Float
	{
		if (val == null)
			_float = 0.0;
		else if (Std.is(val, Int))
		{
			var i:Int = cast val;
			_float = i;
		}
		else if (Std.is(val, Float))
			_float = cast(val, Float);
		else if (Std.is(val, Bool))
			_float = (cast(val, Bool) == true) ? 1.0 : 0.0;
		else if (Std.is(val, String))
			_float = Std.parseFloat(cast(val, String));
		return _float;
	}
}