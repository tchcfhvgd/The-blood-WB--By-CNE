public var fullTBHealthBar:Bool = false;
public var TBHealthBar:FlxSprite;


var good:Dynamic = {
	healthLerp: (health != null ? health : 1)
}

function postCreate() {

    TBHealthBar=new FunkinSprite().loadGraphic(Paths.image('game/TBHealthBar'));
    TBHealthBar.scale.set(0.6, 0.6);
    TBHealthBar.alpha = 1;
    TBHealthBar.updateHitbox();
    TBHealthBar.x = 151.5;
    TBHealthBar.y = Options.downscroll ? 292 : 368;
    TBHealthBar.cameras = [camHUD];
    insert(members.indexOf(healthBar)+1, TBHealthBar);

    remove(healthBarBG);
    healthBar.scale.x = 1.18;
    healthBar.scale.y = 1.4;
    healthBar.setParent(good, "healthLerp");
    
    strumLines.members[0].onHit.add(function(event) {
    	event.preventStrumGlow();
    	
    	health -= health > 0.03111111 ? 0.03 : 0;
    	
    	event.note.__strum.press(event.note.nextSustain != null ? event.note.strumTime : (event.note.strumTime - Conductor.crochet / 2) + (1 / event.note.__strum.animation._animations.get("confirm").frameRate) * event.note.__strum.animation._animations.get("confirm").numFrames * 1000);
    });

//oiiaoiiiiai
//kjkjjajakjkjjajakjkjgadldododo
}

function update(elapsed:Float) {
	good.healthLerp = FlxMath.lerp(good.healthLerp, health, 0.2);
}