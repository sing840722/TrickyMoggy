local composer = require( "composer" );
local scene = composer.newScene();
local sceneGroup;
local bad;
local good;
local startButton;
local howButton;
local bg,bg2,bg3;

local function gotoGameplay()
	composer.gotoScene("gameplay", sceneFading);	--go to gameplay
	composer.removeScene("menu", true);	--remove menu
end

local function gotoTutorial()
	composer.gotoScene("tutorial", sceneFading);	--go to tutorial
	composer.removeScene("menu", true);	--remove menu
	audio.stop(1);
end

local function refreshButton()
	howButton:setSequence("release");
end

local function buttonEventHandler(event)	--start button handler
	event.target:setSequence("press");
	event.target:play();
	bad = nil;
	good = nil;
	
	audio.seek(0, buttonSFX);
	audio.play(buttonSFX);
	
	bg = nil;
	bg2 = nil;
	
	Runtime:removeEventListener("enterFrame", bgUpdate);
	
	if event.target == startButton then
		timer.performWithDelay(100, gotoGameplay);
	elseif event.target == howButton then
		--timer.performWithDelay(100, refreshButton);	--debug only
		timer.performWithDelay(100, gotoTutorial);	--go to tutorial
	end
end

--Sprite Sheet Settings--------------------------------------
local badOption =
{       
	width = 2346/4,
	height = 588,
	numFrames = 4,
    sheetContentWidth = 2346,
    sheetContentHeight = 588,
}

local badData = 
{
	{name = "idle", start = 1, count = 4,time = 500, loopCount = 1},
	{name = "finish", start = 1, count = 1,},
}

local badSheet = graphics.newImageSheet( "image/cat3.png", badOption )
	-------------------------------------
local goodOption =
{       
	width = 2346/4,
	height = 588,
	numFrames = 4,
    sheetContentWidth = 2346,
    sheetContentHeight = 588,
}

local goodData = 
{
	{name = "idle", start = 1, count = 4,time = 500, loopCount = 1},
	{name = "finish", start = 1, count = 1,},
}

local goodSheet = graphics.newImageSheet( "image/cat4.png", goodOption )
	-----------------------------
local startOption = 
{
	width = 782/2,
	height = 91,
	numFrames = 2,
	sheetContentHeight = 91,
	sheetContentWidth = 782,
}

local startData = 
{
	{name = "release", start = 1, count = 1,},
	{name = "press", start = 2, count = 1,},
}

local startSheet = graphics.newImageSheet("image/start.png", startOption);
	------------------------------
local howOption = 
{
	width = 782/2,
	height = 91,
	numFrames = 2,
	sheetContentHeight = 91,
	sheetContentWidth = 782,
}

local howData = 
{
	{name = "release", start = 1, count = 1,},
	{name = "press", start = 2, count = 1,},
}

local howSheet = graphics.newImageSheet("image/how.png", howOption);
--Button Sound Effect---------------------------------


--Function handle Animatino-------------------------
local function badAnimation()
	if bad ~= nil then
		bad:setSequence("idle");
		bad:play();
	end
end

local function goodAnimation()
	if good ~= nil then
		good:setSequence("idle");
		good:play();
	end
end

local function animationLoop(event)
	if event.phase == "ended" then
		event.target:setSequence("finish");
		
		if event.target == bad then
			timer.performWithDelay(2000, badAnimation);
		elseif event.target == good then
			timer.performWithDelay(2000, goodAnimation);
		end
	end
end

function bgUpdate()
	if bg2 ~= nil and bg ~= nil then
		bg2.y = bg.y - _H*2 + 2;
		
		if bg.y < _H*2 then
			bg.y = bg.y + 1;
		else
			bg.y = 0;
		end
	end
end
---------------------------------------------------

function scene:create( event )
	local sceneGroup = self.view;	--object in a scene group will be removed when the removing the scene
	
	showHighScore();

	bg = display.newImageRect("image/menuBg4.png", _W, _H*2);
	bg.anchorX = 0.5;
	bg.anchorY = 0.0;
	bg.x = _W/2;
	bg.y = 0;
	sceneGroup:insert(bg);

	bg2 = display.newImageRect("image/menuBg4.png", _W, _H*2);
	bg2.anchorX = 0.5;
	bg2.anchorY = 0.0;
	bg2.x = _W/2;
	bg2.y = 0 - bg2.height + 0.5;
	sceneGroup:insert(bg2);

	bad = display.newSprite( badSheet, badData);
	bad.anchorX = 0.5;
	bad.anchorY = 0.5;
	bad.x = 154;
	bad.y = _H - 69;
	bad:scale(0.152, 0.152);
	bad:play();
	bad:addEventListener("sprite", animationLoop);
	sceneGroup:insert(bad);
	
	good = display.newSprite(goodSheet, goodData);
	good.anchorX = 0.5;
	good.anchorY = 0.5;
	good.x = _W - 153.5
	good.y = _H - 62.5;
	good:scale(0.15, 0.15);
	good:play();
	good:addEventListener("sprite", animationLoop);
	sceneGroup:insert(good);
	
	bg3 = display.newImageRect("image/nocat.png", _W, _H);
	bg3.anchorX = 0.5;
	bg3.anchorY = 0.5;
	bg3.x = _W/2;
	bg3.y = _H/2;
	sceneGroup:insert(bg3);
	
	startButton = display.newSprite( startSheet, startData);
	startButton.anchorX = 0.5;
	startButton.anchorY = 0.5;
	startButton.x = _W/2;
	startButton.y = _H/2 - 30;
	startButton:addEventListener("tap", buttonEventHandler);
	startButton:scale(0.535, 0.535);
	sceneGroup:insert(startButton);
	
	howButton = display.newSprite(howSheet, howData);
	howButton.anchorX = 0.5;
	howButton.anchorY = 0.5;
	howButton.x = _W/2;
	howButton.y = _H/2 + 35;
	howButton:addEventListener("tap", buttonEventHandler);
	howButton:scale(0.535, 0.535);
	sceneGroup:insert(howButton);
	
	
	local best = display.newImageRect("image/bestscore.png", 150,30);	--best score (word)
	best.anchorX = 0.5;
	best.anchorY = 0.5;
	best.x = best.width/2;
	best.y = best.height/2 + 4;
	sceneGroup:insert(best);
	
	
	local showBest = display.newText("BEST SCORE: BESTSCORE"..bestScore, 190, 18, myFontStyle, 38);	--best score (number)
	showBest:setFillColor(0, 0, 0);
	--showBest.x = 210 + showBest.width/2;
	showBest.x = showBest.width/2;
	showBest.text = bestScore;
	showBest.align = "center"
	sceneGroup:insert(showBest);
	
	if audio.isChannelPlaying(1) then	--if background music is playing
	else	--if background msuic is not playing
		audio.play(bgm, bgmOptions);	--play background music
	end
	
	Runtime:addEventListener("enterFrame", bgUpdate);
end

function scene:destroy(event)
	local sceneGroup = self.view;
end

scene:addEventListener( "create", scene);
scene:addEventListener( "destroy", scene )

return scene;