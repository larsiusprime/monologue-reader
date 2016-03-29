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

/**
 * ...
 * @author 
 */
class MonologueHelper
{

	
	
	public static function toCondition(str:String):MonologueCondition
	{
		return switch(str)
		{
			case "==": EQUAL;
			case "!=": NOT_EQUAL;
			case "<": LESS_THAN;
			case ">": GREATER_THAN;
			case ">=": GREATER_THAN_EQUAL;
			case "<=": LESS_THAN_EQUAL;
			default: UNKNOWN;
		}
	}
	
	public static function toTreeNodeType(str:String):MonologueTreeNodeType
	{
		return switch(str.toLowerCase())
		{
			case "branch": BRANCH;
			case "text": TEXT;
			case "set": SET;
			default: UNKNOWN;
		}
	}
	
	public static function toOperator(str:String):MonologueOperator
	{
		return switch(str)
		{
			case "=": SET;
			case "-": DECREMENT;
			case "+": INCREMENT;
			default: UNKNOWN;
		}
	}
}