/**
 * 用于读取并解析歌曲信息，并储存到expr里面（很水就是了
 */
class InfoParser {
	public var content:String;
	public var expr:Dynamic;

	public function new(content:String) {
		this.content = content;
		
		parseString(content);
	}
	
	public function parseString(c:String):Dynamic {
		var ca:Array<String> = c.split("\n");
		
		if(ca.length > 0) {
			//不太确定i=>v能否在class结构体起作用
			var keyGroup:Array<String> = [];
			var valueGroup:Array<String> = [];
		
			for(st in ca) {
				var i = -1;
				
				while(i < st.length - 1) {
					i ++;
					
					var char:String = st.charAt(i);
					
					if(isLetter(char)) {
						var existMao:Bool = false;
					
						var preKey:String = char;
						var preValue:String;
						var preIndex:Int = 0;
					
						while(true) {
							preIndex ++;
							var abab = st.charAt(preIndex + i);
							
							if(isSpace(abab)) {
								continue;
							}
							
							if(isLetter(abab) || isMath(abab))
								if(!existMao)
									preKey += abab;
								else {
									if(preValue == null)
										preValue = abab;
									else preValue += abab;
								}
							else if(abab == "_") {
								if(existMao) {
									preValue += " ";
								}
							}else if(abab == ":") {
								existMao = true;
							}else if(abab == null || abab == "") {
								if(existMao) {
									if(preKey != null)
										keyGroup.push(preKey);
									
									if(preValue != null)
										valueGroup.push(preValue);
								}
								
								break;
							}
						}
						
						break;
					}
				}
			}
			
			if(keyGroup.length > 0)
				for(key in keyGroup) {
					if(expr == null)
						expr = {};
				
					Reflect.setField(expr, key, valueGroup[keyGroup.indexOf(key)]);
				}
		}else {
			expr = {};
			return expr;
		}
	}
	
	public function isNotMandatoryChar(char:String):Bool
		return (!isSpace(char) && !isMath(char) && !isLetter(char) && char != "");
	
	public function isSpace(char:String):Bool
		return char == " ";
	
	public function isMath(char:String):Bool 
		return "0123456789".split("").contains(char);
	
	public function isLetter(char:String, ?big:Bool):Bool {
		var letterList:String = "abcdefghijklmnopqrstuvwxyz";
	
		return (big == null ? (letterList.split("").contains(char) || letterList.toUpperCase().split("").contains(char)) : (big ? letterList.toUpperCase().split("").contains(char) : letterList.split("").contains(char)));
	}
}