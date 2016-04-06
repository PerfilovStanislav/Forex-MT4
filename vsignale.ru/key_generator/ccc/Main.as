package ccc{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;	
	
	public class Main extends Sprite {		
		var d:Date;
		
		function Main():void {
			if (stage) init();
    		else addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event = null):void {	
			d = new Date();
			
			if (e) removeEventListener(Event.ADDED_TO_STAGE, init);
						
			txt1.addEventListener(Event.CHANGE, accountNumberChange);
			txt1.addEventListener(FocusEvent.FOCUS_IN, FocusIn);
			txt1.addEventListener(FocusEvent.FOCUS_OUT, FocusOut);
			
			txt1.restrict = "0-9";
			
			txt1.text = 'Account number';
			txt2.text = 'Key';
		}
		
		
		private function accountNumberChange(e:Event = null):void {
			if (e.target.text == '') txt2.text = 'Key';
			else {
				if (d.fullYear*100 + d.month < 201601) {
					var acc:int = parseInt(e.target.text);
					var len:int = String(acc).length;
					var sum:int = 1;
					
					for (var i:int=1; i<=len; i++) {				
						sum = int((sum + int (2117483647 / (173+((((acc+sum) % (Math.pow(13, i) % 2127483647))*i) % 2137483647)))) %  2147483647);
					}
					txt2.text = String(sum);
				}
			}
		} 
		
		private function FocusIn(e:FocusEvent = null):void {
			if (e.target.text == 'Account number') e.target.text = '';
		} 
		
		private function FocusOut(e:FocusEvent = null):void {
			if (e.target.text == '') e.target.text = 'Account number';
		} 
	}
	
}
