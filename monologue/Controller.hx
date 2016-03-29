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
import monologue.Tree.Condition;
import monologue.Tree.TreeNode;
import monologue.Tree.TreeNodeBranch;
import monologue.Tree.TreeNodeSet;
import monologue.Tree.TreeNodeText;
import monologue.Tree.TreeNodeType;
import de.polygonal.ds.Map;
import haxe.Json;
import monologue.IMonologueHost;
import monologue.Monologue;

 /**
 *
 * A Controller object for Monologue trees
 * 
 * @author 
 */

@:allow(monologue)
class Controller
{
	public var runState(default, null):TreeState;
	
	private var host:IMonologueHost;
	private var monologue:Monologue;
	
	private var currentNode:Int =-1;
	private var currentTree:Tree;
	
	public function new(params:MonologueParams)
	{
		host = params.host;
		monologue = Monologue.fromJSON(params.json);
		
		initVariables(params.variables);
	}
	
	/**
	 * Load a particular Monologue tree
	 * @param	tree	the name of the tree you want to load
	 * @param	category	the category this tree belongs to (optional)
	 * @param	variables	string-value pairs of variable values to initialize the tree's state with
	 */
	
	public function loadTree(tree:String, ?category:String = "", ?variables:Map<String, Dynamic>):Void
	{
		var categoryID:Int = monologue.treeCategories.indexOf(category);
		for (t in trees)
		{
			if ((t.ID == categoryID || category == "") && t.ID == tree)
			{
				currentTree = t;
				break;
			}
		}
		
		currentNode = currentTree.nodes[0];
		if (variables != null)
		{
			initVariables(variables);
		}
	}
	
	/**
	 * Run the monologue tree until we reach a stopping point (the end of the tree, an error, or a node to display)
	 * @return PAUSED: we're at a node that's meant to be displayed, TERMINATED: we've reached the end of the tree, ERROR: we couldn't find the next node or there was some other problem
	 */
	
	public function run():TreeState
	{
		if (currentNode == -1) return TERMINATED;
		
		var node = getNode(currentNode, currentTree);
		
		if (node == null) return ERROR;
		
		switch(node.type)
		{
			case TreeNodeType.TEXT: 
				runTextNode(node);
				currentNode = node.link;
				return PAUSED;
				
			case TreeNodeType.BRANCH:
				var branch:TreeNodeBranch = cast node;
				var result = runBranchNode(branch);
				if (result) 
					currentNode = branch.trueLink;
				else
					currentNode = branch.falseLink;
				
			case TreeNodeType.SET:
				var setNode:TreeNodeSet = cast node;
				runSetNode(setNode);
				currentNode = node.link;
				
			default:
				runCustomNode(node);
				currentNode = node.link;
				return PAUSED;
		}
		
		return run();
	}
	
	/*****PRIVATE********/
	
	private function getNode(ID:Int, tree:Tree):TreeNode
	{
		if (ID == -1)
		{
			return findRootNode(tree);
		}
		for (node in tree.nodes)
		{
			if (node.ID == ID)
			{
				return node;
			}
		}
		return null;
	}
	
	private function initVariables(vars:Map<String,Dynamic>):Void
	{
		//Initialize the monologue variables with values from the outside
		for (key in params.variables.keys())
		{
			monologue.setVariable(-1, key, params.variables.get(key));
		}
	}
	
	private function runBranchNode(node:TreeNodeBranch):Bool
	{
		var mVar = monologue.getVariable(node.variable);
		return mVar.test(node.value, node.condition);
	}
	
	private function runCustomNode(node:TreeNode):Bool
	{
		return host.showCustomNode(node);
	}
	
	private function runTextNode(node:TreeNodeText):Bool
	{
		return host.showTextNode(node);
	}
	
	private function runSetNode(node:TreeNodeSet):Bool
	{
		var mVar = monologue.getVariable(node.variable);
		if (mVar != null)
		{
			mVar.value = node.value;
			return true;
		}
		return false;
	}
}

enum TreeState
{
	PAUSED;
	TERMINATED;
	ERROR;
}

typedef MonologueParams = {
	var host:IMonologueHost;
	var json:Dynamic;
	var variables:Map<String,Dynamic>;
}