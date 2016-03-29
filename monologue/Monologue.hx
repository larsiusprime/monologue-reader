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
import monologue.MonologueTree.MonologueCondition;
import monologue.MonologueTree.MonologueOperator;
import monologue.MonologueTree.MonologueTreeNodeType;
using monologue.DynamicHelper;

@:allow(com.leveluplabs.tdrpg.monologue)
class Monologue
{
	public var name(default, null):String;
	public var variables:Array<MonologueVariable>;
	public var customVariables:Array<MonologueVariable>;
	public var voices:Array<String>;
	public var treeCategories:Array<String>;
	public var languages:Map<String,String>;
	public var trees:Array<MonologueTree>;
	public var translations:Array<MonologueTranslation>;
	
	public function new(){}
	
	public static function fromJSON(json:Dynamic):Monologue
	{
		if (Reflect.hasField(json, "project"))
		{
			var project = Reflect.field(json, "project");
			
			var m:Monologue = new Monologue();
			
			m.name = json.readJ("name");
			
			m.variables = parseVariables(json, "variables");
			m.customVariables = parseVariables(json, "customVariables");
			m.voices = parseStrings(json, "voices");
			m.treeCategories = parseTreeCategories(json);
			m.languages = parseLanguages(json);
			m.trees = parseTrees(json);
			m.translations = parseTranslations(json);
		}
		return null;
	}
	
	public function getVariable(byID:Int=-1, byName:String=""):MonologueVariable
	{
		for (mVar in variables)
		{
			if (byID != -1 && mVar.ID == byID)
			{
				return mVar;
			}
			if (byName != "" && mVar.displayName == byName)
			{
				return mVar;
			}
		}
		for (mVar in customVariables)
		{
			if (byID != -1 && mVar.ID == byID)
			{
				return mVar;
			}
			if (byName != "" && mVar.displayName == byName)
			{
				return mVar;
			}
		}
		return null;
	}
	
	public function setVariable(byID:Int =-1, byName:String = "", value:Dynamic):Void
	{
		var mVar = getVariable(byID, byName);
		if (mVar != null)
		{
			mVar.value = value;
		}
	}
	/********PRIVATE**********/
	
	private static function parseLanguages(json:Dynamic):Map<String,String>
	{
		return parseArray(json, "languages", function(arr:Array<Dynamic>){
			var langs = new Map<String,String>();
			for (lang in arr)
			{
				var code:String = cat.readJ("code");
				var displayName:String = cat.readJ("displayName");
				langs.set(code, displayName);
			}
			return langs;
		});
	}
	
	private static function parseTranslations(json:Dynamic):Array<MonologueTranslation>
	{
		return parseArray(json, "translations", function(arr:Array<Dynamic>){
			var translations = [];
			for (entry in arr)
			{
				var trans:MonologueTranslation = MonologueTranslation.fromJSON(entry);
				if (trans != null)
					translations.push(trans);
			}
			return translations;
		});
	}
	
	private static function parseStrings(json:Dynamic, fieldName:String):Array<String>
	{
		return parseArray(json, fieldName, function(arr:Array<Dynamic>){
			for (valEntry in arr)
			{
				var value:String = valEntry.readJ("displayName");
				if (value != "")
					mStrings.push(value);
			}
			return mStrings;
		});
	}
	
	private static function parseTrees(json:Dynamic):Array<MonologueTree>
	{
		return parseArray(json, "trees", function(arr:Array<Dynamic>){
			var trees = [];
			for (entry in arr)
			{
				var tree:MonologueTree = MonologueTree.fromJSON(entry);
				if (tree != null)
					trees.push(tree);
			}
			return trees;
		});
	}
	
	private static function parseTreeCategories(json:Dynamic):Map<Int,String>
	{
		return parseArray(json, "treeCategories", function(arr:Array<Dynamic>){
			var cats = [];
			for (cat in arr)
			{
				var id:Int = Std.parseInt(cat.readJ("id", "-1"));
				var displayName:String = cat.readJ("displayName");
				cats[id] = displayName;
			}
			return cats;
		});
	}
	
	private static function parseVariables(json:Dynamic, fieldName:String):Array<MonologueVariable>
	{
		return parseArray(json, fieldName, function(arr:Array<Dynamic>){
			for (varEntry in arr)
			{
				var mVariables = [];
				var mVar = MonologueVariable.fromJSON(varEntry);
				if (mVar != null)
					mVariables.push(mVar);
			}
			return mVariables;
		});
	}
}