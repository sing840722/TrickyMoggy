--multitouch-------------------
system.activate( "multitouch" )
display.setStatusBar(display.HiddenStatusBar);

--Plug in-----------------------
local composer = require( "composer" );

--Global variable-----------------------------
myFontStyle = "BradBunR";
_H = display.contentHeight;
_W = display.contentWidth;
score = 0;
bestScore = 0;
updateTimer = {};	--array for timer
--changedBGM = false;
--Change Scene Option-------------------------------
sceneFading =
{
    effect = "fade",
    time = 150,
}

--Sound---------------------------------------------
bgmOptions ={channel = 1, loops = -1, }	--infinity loop
audio.setVolume(1, {channel = 1});	--bg

bgm = audio.loadSound("audio/BGM/bgm.mp3");
hitSFX = audio.loadSound("audio/SE/badSFX.mp3");
combo1SFX = audio.loadSound("audio/SE/combo1SFX.mp3");
combo2SFX = audio.loadSound("audio/SE/combo2SFX.mp3");
crowSFX = audio.loadSound("audio/SE/crowSFX.mp3");
buttonSFX = audio.loadSound("audio/SE/buttonSFX.mp3");
wrongSFX = audio.loadSound("audio/SE/wrongSFX.mp3");
spawnGood = audio.loadSound("audio/SE/spawnGood.mp3");
spawnBad = audio.loadSound("audio/SE/spawnBad.mp3");
--File I/O-------------------------------------
local json = require("json")--
    
function saveTable(t, filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local file = io.open(path, "w")
    
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end

function loadTable(filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    
    if file then
         -- read all contents of file into a string
         local contents = file:read( "*a" )
         myTable = json.decode(contents);
         io.close( file )
         return myTable 
    end
    
    return nil
end

myGameSettings = loadTable("myGameSettings.json")

function resetMyGameSettings (parameters)
    myGameSettings  = {};
	myGameSettings["highScore"] = 0;
    saveTable(myGameSettings, "myGameSettings.json")
end

if(myGameSettings) then
    --[[
    resetMyGameSettings()
    ]]
else
    --There are no settings. This is the first time the user launches the game
    --Create the default settings
    resetMyGameSettings()
end

showHighScore = function ()
    local myGameSettings = loadTable("myGameSettings.json")
	
	if score > bestScore then
		bestScore = score;
	end
	
    if bestScore > myGameSettings["highScore"] then
        myGameSettings["highScore"] = bestScore
        saveTable(myGameSettings, "myGameSettings.json")
    else
		bestScore = myGameSettings["highScore"];
	end
end
------------------------------------------------------------

function keepPlayingAudio() 
	-- Set the audio mix mode to allow sounds from the app to mix with other sounds from the device 
	if audio.supportsSessionProperty == true then 
		print("supportsSessionProperty is true") 
		audio.setSessionProperty(audio.MixMode, audio.AmbientMixMode) 
	end 
	-- Store whether other audio is playing. It's important to do this once and store the result now, 
	-- as referring to audio.OtherAudioIsPlaying later gives misleading results, since at that point 
	-- the app itself may be playing audio 
	isOtherAudioPlaying = false 
	if audio.supportsSessionProperty == true then 
		if not(audio.getSessionProperty(audio.OtherAudioIsPlaying) == 0) then 
			--print("I think there is other Audio Playing") 
			isOtherAudioPlaying = true 
		end 
	end 
end


--[[
--Video-----------------------------------------
local video = native.newVideo( display.contentCenterX, display.contentCenterY, _W, _H);

local function videoListener( event )
	if event.phase == "ended" then
		video:removeSelf()
		video = nil;
		composer.gotoScene("menu");
	end
end

local function videoTouchEvent(event)
	Runtime:removeEventListener("touch", videoTouchEvent);
	video:seek(video.totalTime);
end

video:load( "video/menu2.mp4", system.DocumentsDirectory )
video:seek(0)

video:addEventListener( "video", videoListener )
Runtime:addEventListener("touch", videoTouchEvent);
video:play()
--------------------------------------------------
--]]

keepPlayingAudio();

composer.gotoScene("menu");	--go to menu	--for debugging

return scene;