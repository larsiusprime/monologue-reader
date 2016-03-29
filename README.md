# monologue-reader
A Haxe parser &amp; controller library for the Monologue editor

Usage:
 
 ```haxe 
 var myData = Json.parse(getTextSomehow("data.mpf"));
 
 //you need some external context that implements IMonologueHost and is
 //responsible for doing the actual dialogue rendering:
  
 var myState = getMyStateSomehow();
  
 //you provide variable values in string-value pairs in a Map, like:
 //("hasPotion":false,numCoins:3,isBig:true), etc
  
 var myVars = getGameVariablesSomehow();
  
 //then you pass all that stuff in:
 
 var controller = new MonologueController({host:myState, json:myData, variables:myVars});
  
 //then load up a tree and run the first node:
 
 controller.loadTree("tutorial");
 controller.run();
 ```
 
 MonologueController will process nodes until it reaches a text node or custom node, at which point it will return ```PAUSED``` and fire a callback to the host to display the node. After the user has clicked "okay" or whatever, it is up to the host to call run() again on the MonologueController to continue to the next node in the sequence. If ```controller.run()``` returns ```TERMINATED```, the current tree has reached a terminal state.
