package states;

import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import flixel.*;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
#if sys
import sys.FileSystem;
#end


class BiosMenuState extends MusicBeatState {
	
	var bg:FlxSprite;
	var background:FlxSprite;
    var imageSprite:FlxSprite;
	
    var imagePath:Array<String>;
    var charDesc:Array<String>;
    var charName:Array<String>;
	var bgColors:Array<String>;

	var curSelected:Int = -1;
    var currentIndex:Int = 0;

    var descriptionText:FlxText;
    var characterName:FlxText;

	override function create() {
		
		#if ACHIEVEMENTS_ALLOWED Achievements.unlock('lore'); #end
		FlxG.sound.playMusic(Paths.music('breakfast'), 1);

		FlxG.mouse.visible = false;

		background = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        background.setGraphicSize(Std.int(background.width * 1.2));
		background.color = 0xFF683FFD;
        background.screenCenter();
        add(background);

		// i took this from psych's engine code lol
		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33000000, 0x0));
		grid.velocity.set(30, 30);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Bios Menu", null);
		#end
		
		// EDIT YOU IMAGES HERE / DONT FORGET TO CREATE A FOLDER IN images CALLED bios IT SHOULD LOOK LIKE THIS 'images/bios'
		// REMINDER!!! THE IMAGES MUST BE 518x544, IF NOT, THEY WONT FIT ON THE SCREEN!!
		imagePath = ["bios/Dex", "bios/New", "bios/Gabby", "bios/Fresh", "bios/Step","bios/Maki"];

		// DESCRIPTION HERE
        charDesc = [
			//Dex
			"Dex the Dog [A.K.A Dex Dousky]: Son of\nthe royal family of StarVillage, an\nisland that once floated using the\npower of chaotic stars. Dex fell from\nthe island with the Star Pendant, which\ncontains the seven chaos stars, and\nlost his memory. He was adopted by\nGabby the Crow. His Star Pendant can\nchange it forms into whatever the\nuser desires and also grants a\ntransformation called the Star Form.\nDex greatly admires a certain speedy\nblue hedgehog, making him a role model\nto follow.", 
			//New
			"New The folf [A.K.A New Dousky, or just\nDousky]: Dex's adopted brother and also\na hybrid of a wolf and fox, With a\npassion for adventures, New always\nfollows his brother everywhere, helping\nhim with gadgets or even himself, as\nhe can use his tail and a special hammer\nthat a certain pink hedgehog gave to\nhim. He's also one of the first\nDouskies. Nobody knows who his real\nparents are or where he came from.", 
			//Gabby
			"Gabby the Crow [A.K.A Gabby Dousky]: is a\ncrow and a mystic with extensive\nknowledge of spells and incredible\nflying skills. She and Fresh are a\ncouple, and New is their adopted son.\nGabby first encountered Dex when he was\nyoung, on the day he fell from\nStarVillage. She was flying peacefully\nwhen Dex suddenly fell on her, but\nfortunately, they were both saved by\nthe stars, softening their fall.\nLuckily, this didn't affect her memory\nlike it did Dex’s. Confused and now\nwith a child who didn’t know his\nparents' names or where he lived,\nGabby decided to adopt him. She and\nFresh accompany Dex and New whenever\nthey can.", 
			//Fresh
			"Fresh the Kitsune [A.K.A Fresh Dousky]: is\na kitsune who has lived for many years on\nMobius, where he met Gabby and New. Like\nGabby, he knows many spells and forms of\nmagic. He is also a great storyteller and\nhas extensive knowledge about the world\nhe inhabits. As Dex grew up with the\nDouskies, Fresh gifted him a pair of shoes\nidentical to his own.", 
			//Step
			"Step the Dino [A.K.A Step Tipevos]: is a\ndinosaur who, much like the blue\nhedgehog, protects those he loves in\nhis village of Iceland Mountain. He\nmet Dex on an ordinary day when Dex was\nsearching for the Chaotic Star, which\nwas near the village. It felt like love\nat first sight, and Step didn’t hesitate\nto help Dex with his mission. Step knew\nwhere the star was because it had once\nbeen used to protect the village. In the\nend, the two became great friends, and\nStep started accompanying Dex even more.\nOh, he's Dex's boyfriend now.", 
			//Maki
			"Maki: I gotta work on that btw"];

		// NAME HERE, it will show as the first text
        charName = ["Dex Dousky", "New Dousky", "Gabby Dousky","Fresh Dousky","Step Tipevos", "Maki The lemur"];


		// SET UP THE FIRST IMAGE YOU WANT TO SEE WHEN ENTERING THE MENU
		imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image("bios/Dex"));
        add(imageSprite);


		characterName = new FlxText(610, 20, charName[currentIndex]);
        characterName.setFormat(Paths.font("ZONE.ttf"), 46, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		characterName.antialiasing = true;
		characterName.borderSize = 4;
        add(characterName);

		descriptionText = new FlxText(610, 100, charDesc[currentIndex]);
        descriptionText.setFormat(Paths.font("OH MY FUCKING GOD WORK YOU DAMN STUPID FONT.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descriptionText.antialiasing = true;
		descriptionText.borderSize = 3;
        add(descriptionText);

		var arrows = new FlxSprite(218, 30).loadGraphic(Paths.image('bios/assets/biosThing'));
		add(arrows);

		super.create();
	}

	override function update(elapsed:Float) {
		
		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) 
			{
				currentIndex--;
				if (currentIndex < 0)
				{
					currentIndex = imagePath.length - 1;
				}
				remove(imageSprite);
				imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image(imagePath[currentIndex]));
				add(imageSprite);
				descriptionText.text = charDesc[currentIndex];
				characterName.text = charName[currentIndex];
				FlxG.sound.play(Paths.sound('scroll_Test'));  
	
			}
			else if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)
			{
				currentIndex++;
				if (currentIndex >= imagePath.length)
				{
					currentIndex = 0;
				}
				remove(imageSprite);
				imageSprite = new FlxSprite(55, 99).loadGraphic(Paths.image(imagePath[currentIndex]));
				add(imageSprite);
				descriptionText.text = charDesc[currentIndex];
				characterName.text = charName[currentIndex];  
				FlxG.sound.play(Paths.sound('scroll_Test'));    
		
			}
			if (controls.BACK)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new MainMenuState());
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
				}
		
		super.update(elapsed);
	}
}