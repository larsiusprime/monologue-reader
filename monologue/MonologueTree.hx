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
using monologue.DynamicHelper;
using monologue.MonologueHelper;

/**
 * ...
 * @author 
 */
@:allow(com.leveluplabs.tdrpg.monologue)
class MonologueTree
{
	public var ID(default, null):Int;
	public var categoryID:Int,
	public var displayName:String,
	public var nodes:Array<MonologueTreeNode>;
	
	public function new(){}
	
	public static function fromJSON(json:Dynamic):MonologueTree
	{
		var mt = new MonologueTree();
		
		var ID:Int = Std.parseInt(json.jsonVar("id","-1"));
		var categoryID:String = Std.parseInt(json.jsonVar("categoryId", "-1"));
		var displayName:String = json.jsonVar("displayName");
		var nodes:Array<MonologueTreeNode> = json.parseArray("nodes", function(arr:Array<Dynamic>){
			var nodes:Array<MonologueTreeNode> = [];
			for (entry in arr)
			{
				var type = Std.string(json.jsonVar("type")).toTreeNodeType();
				var mNode:MonologueTreeNode = switch(type)
				{
					case BRANCH: MonologueTreeNodeBranch.fromJSON(entry);
					case TEXT: MonologueTreeNodeBranch.fromJSON(entry);
					case SET: MonologueTreeNodeBranch.fromJSON(entry);
					default: null;
				}
				
				mNode.locFlag = "$T" + ID + "N" + mNode.ID;
				
				if (mNode != null)
					nodes.push(mNode);
			}
			return nodes;
		});
	}
}

@:allow(com.leveluplabs.tdrpg.monologue)
class MonologueTreeNode
{
	public var ID(default, null):Int=-1;
	public var type(default, null):MonologueTreeNodeType;
	public var link(default, null):Int =-1;
	public var locFlag(default, null):String="";
}

@:allow(com.leveluplabs.tdrpg.monologue)
class MonologueTreeNodeText extends MonologueTreeNode
{
	public var name(default, null):String="";
	public var voice(default, null):String = "";
	
	public function new(){}
	
	public static function fromJSON(json:Dynamic):MonologueTreeNode
	{
		var node = new MonologueTreeNodeText();
		node.ID = json.jsonVar("id", "-1").toInt();
		node.type = Std.string(json.jsonVar("type")).toTreeNodeType();
		node.link = json.jsonVar("link", "-1").toInt();
		node.name = Std.string(json.jsonVar("name"));
		node.voice = Std.string(json.jsonVar("voice"));
	}
}

@:allow(com.leveluplabs.tdrpg.monologue)
class MonologueTreeNodeBranch extends MonologueTreeNode
{
	public var variable(default, null):Int = -1;
	public var value(default, null):Dynamic = null;
	public var condition(default, null):MonologueCondition=UNKNOWN;
	public var trueLink(default, null):Int=-1;
	public var falseLink(default, null):Int =-1;
	
	public function new(){}
	
	public static function fromJSON(json:Dynamic):MonologueTreeNode
	{
		var node = new MonologueTreeNodeBranch();
		node.ID = json.jsonVar("id", "-1").toInt();
		node.type = Std.string(json.jsonVar("type")).toTreeNodeType;
		node.link = json.jsonVar("link", "-1").toInt();
		node.variable = json.jsonVar("variable","-1").toInt();
		node.value = json.jsonVar("value","");
		node.condition = Std.string(json.jsonVar("condition")).toCondition;
		node.trueLink = json.jsonVar("trueLink", "-1").toInt();
		node.falseLink = json.jsonVar("falseLink", "-1").toInt();
	}
}

@:allow(com.leveluplabs.tdrpg.monologue)
class MonologueTreeNodeSet extends MonologueTreeNode
{
	public var variable(default, null):Int = -1;
	public var operation(default, null):MonologueOperator=UNKNOWN;
	public var value(default, null):String = "";
	
	public function new(){}
	
	public static function fromJSON(json:Dynamic):MonologueTreeNode
	{
		var node = new MonologueTreeNodeSet();
		node.ID = json.jsonVar("id", "-1").toInt();
		node.type = Std.string(json.jsonVar("type")).toTreeNodeType();
		node.link = json.jsonVar("link", "-1").toInt();
		node.variable = json.jsonVar("variable").toInt();
		node.operation = Std.string(json.jsonVar("operation")).toOperator;
		node.value = Std.string(json.jsonVar("value",""));
	}
}

enum MonologueTreeNodeType
{
	BRANCH;
	SET;
	TEXT;
	CUSTOM;
}

enum MonologueOperator
{
	SET;
	INCREMENT;
	DECREMENT;
	UNKNOWN;
}

enum MonologueCondition
{
	EQUAL;
	NOT_EQUAL;
	LESS_THAN;
	GREATER_THAN;
	LESS_THAN_EQUAL;
	GREATER_THAN_EQUAL;
	UNKNOWN;
}