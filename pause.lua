local composer = require("composer");
local scene = composer.newScene()
local resumeIcon, musicIcon, soundIcon;

local resumeOption =
{       
	width = 616/2,
	height = 85,
	numFrames = 2,
    sheetContentWidth = 616,
    sheetContentHeight = 85,
}

local resumeData = 
{
	{name = "release", start = 1, count = 1},
	{name = "press", start = 2, count = 1,},
}

local resumeSheet = graphics.newImageSheet( "image/resume.png", resumeOption )

local musicOption =
{       
	width = 176/2,
	height = 88,
	numFrames = 2,
    sheetContentWidth = 176,
    sheetContentHeight = 88,
}

local musicData = 
{
	{name = "release", start = 1, count = 1},
	{name = "press", start = 2, count = 1},
}

local musicSheet = graphics.newImageSheet( "image/speaker.png", musicOption )

local soundOptions = 
{
	width = 176/2,
	height = 88,
	numFrames = 2,
	sheetContentWidth = 176,
	sheetContentHeight = 88
}
local soundSheet = graphics.newImageSheet( "image/sound.png", soundOptions);
	
local soundData = 
{
	{name = "release", start = 1, count = 1},
	{name = "press", start = 2, count = 1};
}

local function buttonHandler(event)
	if event.phase == "began" then
		if event.target == resumeIcon then
			event.target:setSequence("press");
			event.target:play();
			timer.performWithDelay(500, resume);
		elseif event.target == musicIcon then
			if event.target.state == "pressed" then
				audio.setVolume(1.0, {channel = 1});
				event.target:setSequence("release");
				event.target.state = "released";
			elseif event.target.state == "released" then
				audio.setVolume(0.0, {channel = 1});
				event.target:setSequence("press");
				event.target.state = "pressed";
			end
			event.target:play();
		elseif event.target == soundIcon then
			if event.target.state == "pressed" then
				playSFX = true;
				event.target:setSequence("release");
				event.target.state = "released";
			elseif event.target.state == "released" then
				playSFX = false;
				event.target:setSequence("press");
				event.target.state = "pressed";
			end
			event.target:play();
		end
	end
end	
	
function scene:create(event)
	local sceneGroup = self.view;
	
	local mask = display.newImageRect("image/whitetrans.png",_W,_H/2.5);
	mask.anchorX = 0.5;
	mask.anchorY = 0.5;
	mask.x = _W/2;
	mask.y = _H/2 + 10;
	sceneGroup:insert(mask);
	
	local pauseText = display.newImageRect("image/paused.png", 135, 35);
	pauseText.anchorX = 0.5;
	pauseText.anchorY = 0.5;
	pauseText.x = _W/2;
	pauseText.y = _H/2 - 29;
	sceneGroup:insert(pauseText);

	
	resumeIcon = display.newSprite(resumeSheet, resumeData);
	resumeIcon.anchorX = 0.5;
	resumeIcon.anchorY = 0.5;
	resumeIcon.x = _W/2;
	resumeIcon.y = _H/2 + 7;
	resumeIcon:scale(0.3, 0.3);
	resumeIcon:addEventListener("touch", buttonHandler);
	sceneGroup:insert(resumeIcon);
	
	musicIcon = display.newSprite( musicSheet, musicData);
	musicIcon.anchorX = 0.5;
	musicIcon.anchorY = 0.5;
	musicIcon.x = _W/2 - 20;
	musicIcon.y = _H/2 + 45;
	musicIcon:scale(0.3, 0.3);
	if audio.getVolume({channel=1}) == 1 then
		musicIcon.state = "released";
		musicIcon:setSequence("release");
	elseif audio.getVolume({channel=1}) == 0 then
		musicIcon.state = "pressed";
		musicIcon:setSequence("press");
	end
	musicIcon:play();
	musicIcon:addEventListener("touch", buttonHandler);
	sceneGroup:insert(musicIcon);
	
	soundIcon = display.newSprite( soundSheet, soundData);
	soundIcon.anchorX = 0.5;
	soundIcon.anchorY = 0.5;
	soundIcon.x = _W/2 + 20;
	soundIcon.y = _H/2 + 45;
	soundIcon:scale(0.3, 0.3);
	
	if playSFX then
		soundIcon.state = "released";
		soundIcon:setSequence("release");
	elseif not playSFX then
		soundIcon.state = "pressed";
		soundIcon:setSequence("press");
	end
	soundIcon:play();
	soundIcon:addEventListener("touch", buttonHandler);	
	sceneGroup:insert(soundIcon);
end

function resume()
	composer.hideOverlay( "fade", 100 )

	for k, v in pairs(updateTimer) do
        timer.resume(v);
    end
	
	transition.resume();
	
	for i = table.maxn(cat) - 10, table.maxn(cat) + 10 do	--latest 8 cats
		if i > 0 then
			if cat[i] ~= nil and cat[i].state ~= "gone" then
				cat[i]:addEventListener("touch", touchEventListener);
			end
		end
	end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object
	
    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        --parent:resumeGame()
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )

return scene