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
import monologue.MonologueTree.Operator;
import monologue.MonologueTree.TreeNodeType;
import monologue.MonologueVariable.MonologueVariableType;
using monologue.DynamicHelper;

@:allow(monologue)
class Monologue
{
	private var name(default, null):String;
	private var variables:Array<MonologueVariable>;
	private var customVariables:Array<MonologueVariable>;
	private var voices:Array<String>;
	private var treeCategories:Array<String>;
	private var languages:Map<String,String>;
	private var trees:Array<MonologueTree>;
	private var translations:Array<Translation>;
	
	public function new(){}
	
	public static function fromJSON(json:Dynamic):Monologue
	{
		if (Reflect.hasField(json, "project"))
		{
			var project:Dynamic = Reflect.field(json, "project");
			
			var m:Monologue = new Monologue();
			
			m.name = Std.string(project.jsonVar("name"));
			
			m.variables = parseVariables(project, "variables");
			m.customVariables = parseVariables(project, "customVariables");
			m.voices = parseStrings(project, "voices");
			m.treeCategories = parseTreeCategories(project);
			m.languages = parseLanguages(project);
			m.trees = parseTrees(json);
			m.translations = parseTranslations(json);
			
			return m;
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
		else
		{
			mVar = new MonologueVariable();
			
			     if (Std.is(value, Bool  )) mVar.type = MonologueVariableType.BOOL;
			else if (Std.is(value, Int   )) mVar.type = MonologueVariableType.INT;
			else if (Std.is(value, Float )) mVar.type = MonologueVariableType.FLOAT;
			else if (Std.is(value, String)) mVar.type = MonologueVariableType.STRING;
			else return;
			
			var newID:Int = byID;
			
			if (newID < 0)
			{
				for (custom in customVariables)
				{
					if (custom.ID > newID)
					{
						newID = custom.ID;
					}
				}
			}
			
			mVar.ID = newID + 1;
			mVar.displayName = byName;
			mVar.value = value;
			
			customVariables.push(mVar);
		}
	}
	/********PRIVATE**********/
	
	private static function parseLanguages(json:Dynamic):Map<String,String>
	{
		return json.jsonArray("languages", function(arr:Array<Dynamic>){
			var langs = new Map<String,String>();
			for (lang in arr)
			{
				var code = Std.string(json.jsonVar("code"));
				var displayName = Std.string(json.jsonVar("displayName"));
				langs.set(code, displayName);
			}
			return langs;
		});
	}
	
	private static function parseTranslations(json:Dynamic):Array<Translation>
	{
		return json.jsonArray("translations", function(arr:Array<Dynamic>){
			var translations = [];
			for (entry in arr)
			{
				var trans:Translation = Translation.fromJSON(entry);
				if (trans != null)
					translations.push(trans);
			}
			return translations;
		});
	}
	
	private static function parseStrings(json:Dynamic, fieldName:String):Array<String>
	{
		return json.jsonArray(fieldName, function(arr:Array<Dynamic>){
			var mStrings = [];
			for (valEntry in arr)
			{
				var value:String = Std.string(valEntry.jsonVar("displayName"));
				if (value != "")
					mStrings.push(value);
			}
			return mStrings;
		});
	}
	
	private static function parseTrees(json:Dynamic):Array<MonologueTree>
	{
		return json.jsonArray("trees", function(arr:Array<Dynamic>){
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
	
	private static function parseTreeCategories(json:Dynamic):Array<String>
	{
		return json.jsonArray("treeCategories", function(arr:Array<Dynamic>){
			var cats = [];
			for (cat in arr)
			{
				var id:Int = json.jsonVar("id", "-1").toInt();
				var displayName:String = json.jsonVar("displayName");
				cats[id] = displayName;
			}
			return cats;
		});
	}
	
	private static function parseVariables(json:Dynamic, fieldName:String):Array<MonologueVariable>
	{
		return json.jsonArray(fieldName, function(arr:Array<Dynamic>){
			var mVariables = [];
			for (varEntry in arr)
			{
				var mVar = MonologueVariable.fromJSON(varEntry);
				if (mVar != null)
					mVariables.push(mVar);
			}
			return mVariables;
		});
	}
}