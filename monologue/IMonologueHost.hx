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
import monologue.MonologueTree.MonologueTreeNode;
import monologue.MonologueTree.TreeNodeText;

interface IMonologueHost 
{
	/**
	 * Implement this to display a text node in your application somehow
	 * @param	node
	 */
	public function showTextNode(node:TreeNodeText):Void;
	
	/**
	 * Implement this to display a custom node in your application somehow
	 * @param	node
	 */
	public function showCustomNode(node:MonologueTreeNode):Void;
	
	/**
	 * Notifies your application that a monologue node has changed a variable value
	 * @param	name
	 * @param	value
	 */
	public function onSetVariable(name:String, value:Dynamic):Void;
}