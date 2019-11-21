local composer = require( "composer" );
local scene = composer.newScene();

local bg, bg2, bg3, bg4, bg5, bg6;

local function restartEvent(event)	--restart
	audio.stop(1);
	composer.gotoScene("menu", sceneFading);
	composer.removeScene("gameover", true);
	transition.cancel();
end

function bgLoop()
	bg.y = 0;
	transition.to(bg, {y = (bg.height), time = 7000, onComplete = bgLoop});
end

function bg2Loop()
	bg2.y = 0 - bg2.height + 0.5;
	transition.to(bg2, {y = (0), time = 7000, onComplete = bg2Loop});
end

local dollOption = 
{
	width = 482/4,
	height = 115,
	numFrames = 4,
	sheetContentHeight = 115,
	sheetContentWidth = 482,
}

local dollData = 
{
	{name = "idle", start = 1, count = 4,time = 1750},
}

local dollSheet = graphics.newImageSheet("image/doll.png", dollOption);

local goOption = 
{
	width = 1308/2,
	height = 119,
	numFrames = 2,
	sheetContentHeight = 119,
	sheetContentWidth = 1308,
}

local goData = 
{
	{name = "idle", start = 1, count = 2,time = 500},
}

local goSheet = graphics.newImageSheet("image/gameover.png", goOption);

function scene:create( event )	
	local sceneGroup = self.view;
	showHighScore();
	
	local thisScore = score;
	
	bg = display.newImageRect("image/endBg.png", _W, _H*2);
	bg.anchorX = 0.5;
	bg.anchorY = 0.0;
	bg.x = _W/2;
	bg.y = 0;
	sceneGroup:insert(bg);
	transition.to(bg, {y = (bg.height), time = 7000, onComplete = bgLoop});
	
	bg2 = display.newImageRect("image/endBg.png", _W, _H*2);
	bg2.anchorX = 0.5;
	bg2.anchorY = 0.0;
	bg2.x = _W/2;
	bg2.y = 0 - bg2.height + 0.5;
	sceneGroup:insert(bg2);
	transition.to(bg2, {y = (0), time = 7000, onComplete = bg2Loop});

	bg3 = display.newImageRect("image/window.png", _W/2 + 30, _H + 10)
	bg3.anchorX = 0.5;
	bg3.anchorY = 0.5;
	bg3.x = _W/2;
	bg3.y = _H/2;
	sceneGroup:insert(bg3);
	
	bg4 = display.newImageRect("image/2cats.png", 115, 190);
	bg4.anchorX = 0.5;
	bg4.anchorY = 0.5;
	bg4.x = _W/2 + 108;
	bg4.y = _H - bg4.height/2 - 12;
	sceneGroup:insert(bg4);
	
	bg6 = display.newSprite(goSheet, goData);
	bg6.anchorX = 0.5;
	bg6.anchorY = 0.5;
	bg6:scale(0.3, 0.3);
	bg6.x = _W/2;
	bg6.y = 75;
	bg6:play();
	sceneGroup:insert(bg6);
	
	bg5 = display.newSprite(dollSheet, dollData);
	bg5.anchorX = 0.5;
	bg5.anchorY = 0.5;
	bg5:scale(0.75, 0.75);
	bg5.x = _W/2 + 98;
	bg5.y = _H - bg4.height/2 - 12 - 127;
	bg5:play();
	sceneGroup:insert(bg5);
	
	local restartButton = display.newImageRect("image/restart.png", 60, 60);	--add restart button
	restartButton.anchorX = 0.5;
	restartButton.anchorY = 0.5;
	restartButton.x = _W/2;
	restartButton.y = _H/2 + 75;
	restartButton:addEventListener("tap", restartEvent);
	sceneGroup:insert(restartButton);
		
	local best = display.newImageRect("image/bestscore.png", 110,110/6);	--add best score(word)
	best.anchorX = 0.5;
	best.anchorY = 0.5;
	best.x = _W/2;
	best.y = _H/2 - 50;
	sceneGroup:insert(best);
	
	local showBest = display.newText("", _W/2, _H/2 - 25, myFontStyle, 24);	--add best score(value)
	showBest.text = bestScore;
	showBest:setFillColor(0,0,0);
	sceneGroup:insert(showBest);
	
	local score = display.newImageRect("image/score.png", 60,20);	--add score(word)
	score.anchorX = 0.5;
	score.anchorY = 0.5;
	score.x = _W/2;
	score.y = _H/2 + 5;
	sceneGroup:insert(score);
	
	local showScore = display.newText("", _W/2, _H/2 + 25, myFontStyle, 24);	--add score(value)
	showScore.text = thisScore;
	showScore:setFillColor(0,0,0);
	sceneGroup:insert(showScore);
	
end

function scene:destroy(event)
	local sceneGroup = self.view;
end

scene:addEventListener( "create", scene);
scene:addEventListener( "destroy", scene )

return scene;