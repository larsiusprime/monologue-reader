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
import monologue.MonologueTree.Condition;
import monologue.Monologue;
using monologue.DynamicHelper;

/**
 * ...
 * @author 
 */
@:allow(monologue)
class MonologueVariable
{
	public var ID(default,null):Int;
	public var displayName(default,null):String="";
	public var origin(default,null):String="";
	public var settable(default,null):Bool=true;
	public var gettable(default, null):Bool=true;
	
	public var type:MonologueVariableType;
	public var value(get, set):Dynamic;
	
	private var _bool:Bool = false;
	private var _int:Int = 0;
	private var _string:String = "";
	private var _float:Float = 0.0;
	
	public function new(){}
	
	public static function fromJSON(json:Dynamic):MonologueVariable
	{
		var mVar = new MonologueVariable();
		
		mVar.ID = json.jsonVar("id").toInt();
		mVar.displayName = Std.string(json.jsonVar("displayName"));
		mVar.origin = Std.string(json.jsonVar("origin"));
		mVar.settable = json.jsonVar("set").toBool();
		mVar.gettable = json.jsonVar("get").toBool();
		mVar.type = switch(Std.string(json.jsonVar("validation")))
		{
			case "bool": BOOL;
			case "int": INT;
			case "float": FLOAT;
			default: STRING;
		}
		
		return mVar;
	}
	
	public function test(value:Dynamic, condition:Condition):Bool
	{
		return switch(type)
		{
			case BOOL:   testEquivalent(_bool, value.toBool(), condition);
			case STRING: testEquivalent(_string, Std.string(value), condition);
			case INT:    testInt(_int, value.toInt(), condition);
			case FLOAT:  testFloat(_float, value.toFloat(), condition);
			default: false;
		}
	}
	
	@:generic
	private static function testEquivalent<T>(a:T, b:T, condition:Condition):Bool
	{
		return switch(condition)
		{
			case EQUAL:              a == b;
			case NOT_EQUAL:          a != b;
			default: false;
		}
	}
	
	private static function testInt(a:Int, b:Int, condition:Condition):Bool
	{
		return switch(condition)
		{
			case EQUAL:              a == b;
			case NOT_EQUAL:          a != b;
			case LESS_THAN:          (a < b);
			case GREATER_THAN:       (a > b);
			case LESS_THAN_EQUAL:    (a <= b);
			case GREATER_THAN_EQUAL: (a >= b);
			default: false;
		}
	}
	
	private static function testFloat(a:Float, b:Float, condition:Condition):Bool
	{
		return switch(condition)
		{
			case EQUAL:              a == b;
			case NOT_EQUAL:          a != b;
			case LESS_THAN:          (a < b);
			case GREATER_THAN:       (a > b);
			case LESS_THAN_EQUAL:    (a <= b);
			case GREATER_THAN_EQUAL: (a >= b);
			default: false;
		}
	}
	
	private function get_value():Dynamic
	{		
		return switch(type)
		{
			case BOOL: _bool;
			case INT: _int;
			case FLOAT: _float;
			default: _string;
		}
	}
	
	private function set_value(val:Dynamic):Dynamic
	{		
		switch(type)
		{
			case BOOL:
				_bool = val.toBool();
				return _bool;
			case INT: 
				_int = val.toInt();
				return _int;
			case FLOAT:
				_float = val.toFloat();
				return _float;
			case STRING:
				_string = Std.string(val);
				return _string;
		}
		return null;
	}
}

enum MonologueVariableType
{
	FLOAT;
	INT;
	BOOL;
	STRING;
}