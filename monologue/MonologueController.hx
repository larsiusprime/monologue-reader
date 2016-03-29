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
import com.leveluplabs.tdrpg.monologue.MonologueController.MonologueControllerState;
import monologue.MonologueTree.MonologueCondition;
import monologue.MonologueTree.MonologueTreeNode;
import monologue.MonologueTree.MonologueTreeNodeBranch;
import monologue.MonologueTree.MonologueTreeNodeSet;
import monologue.MonologueTree.MonologueTreeNodeText;
import monologue.MonologueTree.MonologueTreeNodeType;
import de.polygonal.ds.Map;
import haxe.Json;
import monologue.IMonologueHost;
import monologue.Monologue;

 /**
 *
 * A Controller object for Monologue trees
 * 
 * Usage:
 ***************
 * 
 * var myData = Json.parse(getTextSomehow("data.mpf"));
 *
 * //you need some external context that implements IMonologueHost and is
 * //responsible for doing the actual dialogue rendering:
 * 
 * var myState = getMyStateSomehow();
 * 
 * //you provide variable values in string-value pairs in a Map, like:
 * //("hasPotion":false,numCoins:3,isBig:true), etc
 * 
 * var myVars = getGameVariablesSomehow();
 * 
 * //then you pass all that stuff in:
 * 
 * var controller = new MonologueController({host:myState, json:myData, variables:myVars});
 * 
 * //then load up a tree and run the first node:
 * 
 * controller.loadTree("tutorial");
 * controller.run();
 * 
 ***************
 * 
 * MonologueController will process nodes until it reaches a text node or
 * custom node, at which point it will return PAUSED and fire a callback to the
 * host to display the node. After the user has clicked "okay" or whatever, it
 * is up to the host to call run() again on the MonologueController to continue
 * to the next node in the sequence. If controller.run() returns TERMINATED,
 * the current tree has reached a terminal state.
 * 
 * @author 
 */

@:allow(com.leveluplabs.tdrpg.monologue)
class MonologueController
{
	public var runState(default, null):MonologueControllerState;
	
	private var host:IMonologueHost;
	private var monologue:Monologue;
	
	private var currentNode:Int =-1;
	private var currentTree:MonologueTree;
	
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
	
	public function run():MonologueControllerState
	{
		if (currentNode == -1) return TERMINATED;
		
		var node = getNode(currentNode, currentTree);
		
		if (node == null) return ERROR;
		
		switch(node.type)
		{
			case MonologueTreeNodeType.TEXT: 
				runTextNode(node);
				currentNode = node.link;
				return PAUSED;
				
			case MonologueTreeNodeType.BRANCH:
				var branch:MonologueTreeNodeBranch = cast node;
				var result = runBranchNode(branch);
				if (result) 
					currentNode = branch.trueLink;
				else
					currentNode = branch.falseLink;
				
			case MonologueTreeNodeType.SET:
				var setNode:MonologueTreeNodeSet = cast node;
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
	
	private function getNode(ID:Int, tree:MonologueTree):MonologueTreeNode
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
	
	private function runBranchNode(node:MonologueTreeNodeBranch):Bool
	{
		var mVar = monologue.getVariable(node.variable);
		return mVar.test(node.value, node.condition);
	}
	
	private function runCustomNode(node:MonologueTreeNode):Bool
	{
		return host.showCustomNode(node);
	}
	
	private function runTextNode(node:MonologueTreeNodeText):Bool
	{
		return host.showTextNode(node);
	}
	
	private function runSetNode(node:MonologueTreeNodeSet):Bool
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

enum MonologueControllerState
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