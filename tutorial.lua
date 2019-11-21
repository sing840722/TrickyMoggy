local composer = require( "composer" );
local scene = composer.newScene();

local function gotoMenu()
	composer.gotoScene("menu", sceneFading);	--go to menu
	composer.removeScene("tutorial", true);	--remove tutorial
end

local function videoTouchEvent(event)
	Runtime:removeEventListener("touch", videoTouchEvent);
	--[[
	video:removeEventListener("video", videoListener);
	video:seek(video.totalTime);
	video:removeSelf()
	video = nil;
	--]]
	timer.performWithDelay(100, gotoMenu);
end

function scene:create( event )
	local sceneGroup = self.view;	--object in a scene group will be removed when the removing the scene
	howtoplay = display.newImageRect("image/howtoplay.png", _W, _H)
	howtoplay.anchorX = 0.5;
	howtoplay.anchorY = 0.5;
	howtoplay.x = _W/2;
	howtoplay.y = _H/2;
	sceneGroup:insert(howtoplay);

	
	Runtime:addEventListener("touch", videoTouchEvent);
	--Video-----------------------------------------
	--[[
	local video = native.newVideo( display.contentCenterX, display.contentCenterY, _W, _H);
	
	local function videoListener( event )
		if event.phase == "ended" then
			video:seek(0);
			video:play();
		end
	end
	
	video:load( "video/howtoplay.mp4", system.DocumentsDirectory )
	video:seek(0)

	video:addEventListener( "video", videoListener )
	
	video:play()
	--]]
end

function scene:destroy(event)
	local sceneGroup = self.view;
end

scene:addEventListener( "create", scene);
scene:addEventListener( "destroy", scene )

return scene;