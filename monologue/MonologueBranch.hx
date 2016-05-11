package monologue;

import monologue.MonologueTree.Condition;
using monologue.DynamicHelper;
using monologue.MonologueHelper;

/**
 * Roméo Jr. Labonté (romeo@q-bit.ca)
 * @author 
 */
@:allow(monologue)
class MonologueBranch
{
	public var variable(default, null):Int = -1;
	public var condition(default, null):Condition = null;
	public var value(default, null):Dynamic = null;
	public var link(default, null):Int = -1;
	
	public function new() {}
	
	public static function fromJSON(json:Dynamic):MonologueBranch
	{
		var branch:MonologueBranch = new MonologueBranch();
		
		branch.variable = json.jsonVar("variable", "-1").toInt();
		branch.condition = Std.string(json.jsonVar("condition")).toCondition();
		branch.value = json.jsonVar("value", "");
		branch.link = json.jsonVar("link", "-1").toInt();
		
		return branch;
	}
}