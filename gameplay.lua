local composer = require( "composer" );
local scene = composer.newScene();
cat = {};	--array for the cats, both yellow and grey
local spawnDelay = 2000;	--delay between spawns
local escapeDelay = 1500;	--life time of a character
local level = 1;
local obtainedScore = 0;	--score for level up
local chanceOfGrey = 10;	--chance of spawing an incorrect target
local slotInUse = {};	--is window being used? 1 = using, 0 = free
local sceneGroup;
local defeat = false;	--not yet defeat
local windows;
local pauseButton;
local combo = 1;
local totalBad = 1;
local crow, crow2;
local currentShot = 0;
local actualCombo = 0;
playSFX = true;
--Sprite Sheet Settings------------------------------
local badOption =
{       
	width = 7329/3,
	height = 2330,
	numFrames = 3,
    sheetContentWidth = 7329,
    sheetContentHeight = 2330,
}

local badData = 
{
	{name = "idle", start = 2, count = 2,time = 1000, },
	{name = "injure", start = 1, count = 1},
}

local badSheet = graphics.newImageSheet( "image/cat.png", badOption )

local goodOption =
{       
	width = 7329/3,
	height = 2061,
	numFrames = 3,
    sheetContentWidth = 7329,
    sheetContentHeight = 2061,
}

local goodData = 
{
	{name = "idle", start = 2, count = 2,time = 1000, },
	{name = "injure", start = 1, count = 1},
}

local goodSheet = graphics.newImageSheet( "image/cat2.png", goodOption )

local crowOption =
{       
	width = 930/2,
	height = 272,
	numFrames = 2,
    sheetContentWidth = 930,
    sheetContentHeight = 272,
}

local crowData = 
{
	{name = "idle", start = 1, count = 2,time = 1000,},
	--{name = "injure", start = 1, count = 1},
}

local crowSheet = graphics.newImageSheet( "image/crow.png", crowOption )

local panOption =
{       
	width = 721/3,
	height = 239,
	numFrames = 3,
    sheetContentWidth = 721,
    sheetContentHeight = 239,
}

local panData = 
{
	{name = "hit", start = 1, count = 3, time = 300,  loopCount = 1},
}

local panSheet = graphics.newImageSheet( "image/pan.png", panOption )
--Touch Event Listener---------------------------------------------------
function touchEventListener(event)	--touch event listener for the cats
	local function removeObj()	--Function for remove character from stage + free memory
		for i = 0, 9 do
			if event.target.id == i then	--reset the window so it can be use again
				slotInUse[i] = 0;
			end
		end
		event.target:removeSelf();
		event.target = nil;
	end
	
	if event.phase == "began" then
		if defeat == false then	--if the game is not lost
			event.target.state = "gone";	--event target is gone
			if event.target.type == "bad" then	--if hit a correct target
				local addScore = 50 * (1 + actualCombo/50);	--add 50score to total score
				score = score + addScore;
				currentShot = currentShot + 1;
				
				--if player is not shooting the target by following the spawn order
				if event.target.index > combo or event.target.index < combo then
					if actualCombo >= 1 then	--if player has stacked combo
						if playSFX then	--if sound effect is not muted
							local availableChannel = audio.findFreeChannel()	--find the avaiable channel
							audio.play(failComboSFX, { channel=availableChannel });	--play the failCombo sound effect on a free channel
						end
					end
					combo = 1;	--reset the number of times that player has followed the correct spawn order
					totalBad = 1;	--reset the spawn order
					actualCombo = 0;	--reset the combo
				else	--if the event target spawn order is the same as the current combo
				--[[
				(player start stacking combo after following the correct spawn order 3 times)
				if player has followed the correct spawn order for 3 times or more
				--]]
					if combo >= 3 then	
						actualCombo = actualCombo + 1;	--add actualCombo, and spawn the combo images
						spawnCombo(event.target.x + 35, event.target.y - 20, actualCombo);
					end
					
					--[[
						(Combo sound effect start playing after player has stacked more than 3 combo)
						if player has stacked more than 3 combo
					--]]
					if actualCombo > 3 then	
						if playSFX then
							local availableChannel = audio.findFreeChannel()
							audio.play(combo2SFX, { channel=availableChannel });
						end
					end
					
					combo = combo + 1;	--followed the correct spawn order
				end
			else	--if hit an incorrect target, play the game over sound effect
				if playSFX then
					local availableChannel = audio.findFreeChannel()
					audio.play(wrongSFX, { channel=availableChannel });
				end
				defeat = true;	--set the current state to defeat, and go to gameover scene after 0.75 seconds
				timer.performWithDelay(750, changeScene, 1);
			end
			
			--play the injury animation
			event.target:setSequence("injure");
			event.target:play();
			
			if playSFX then	--if not muted, play the shooting sound effect
				local availableChannel = audio.findFreeChannel()
				audio.play(hitSFX, { channel=availableChannel });
			end
			
			event.target:removeEventListener("touch", touchEventListener);	--remove eventlistener from the character
			transition.cancel(event.target);	--remove animation from character
			
			transition.to(event.target, {time=75, x=(event.target.x), y=(event.target.y - 12.5)})	--event target jumps
			
			-- then fall off from the stage
			if event.target.row == "first" then
				local targetLocation = 144+30;
				local distance = targetLocation - event.target.y;
				local animationTime = distance * 10;
				transition.to(event.target, {time = animationTime, x = (event.target.x), y = targetLocation, delay = 150});
			elseif event.target.row == "second" then
				local targetLocation = 295+30;
				local distance = targetLocation - event.target.y;
				local animationTime = distance * 10;
				transition.to(event.target, {time = animationTime, x = (event.target.x), y = targetLocation, delay = 150});
			end			
			
			timer.performWithDelay(750, removeObj, 1);	--remove character from stage
			-------------
			spawnMouse(event.target.x - 12, event.target.y - 40)	--show the mouse cursor (pan) for 0.3seconds
			timer.performWithDelay(301, removeMouse);
			-------------
			return true;
		end
	end
	return true;
end

function spawnMouse(x, y)
	local hand = display.newSprite(panSheet, panData);
	hand:scale(0.225, 0.225);
	hand.anchorX = 0.0;
	hand.anchorY = 0.0;
	hand.x = x;
	hand.y = y;
	
	hand:toFront();
	hand:play();
	sceneGroup:insert(hand);
	
	function removeMouse()
		if hand ~= nil then
			hand:removeSelf();
			hand = nil;
		end
	end
end

function spawnCombo(x, y, numberOfCombo)
	local combo = display.newImageRect("image/combo.png", 65, 55/3);
	local times = display.newImageRect("image/x.png", 50/3, 50/3);
	local numOfComboString = tostring(numberOfCombo);
	local numOf, numOf2, numOf3, numOf4;
	
	if numberOfCombo > 999 then
		numOf = display.newImageRect("image/"..numOfComboString:sub(1,1)..".png", 15, 20);
		numOf2 = display.newImageRect("image/"..numOfComboString:sub(2,2)..".png", 15, 20);
		numOf3 = display.newImageRect("image/"..numOfComboString:sub(3,3)..".png", 15, 20);
		numOf4 = display.newImageRect("image/"..numOfComboString:sub(4,4)..".png", 15, 20);
		
		numOf.anchorX = 0.5;
		numOf.anchorY = 0.5;
		numOf.x = x + times.width/2 + numOf.width/2;
		numOf.y = y - 10;
		numOf:rotate(-12.5);
		
		numOf2.anchorX = 0.5;
		numOf2.anchorY = 0.5;
		numOf2.x = numOf.x + numOf.width/2 + numOf2. width/2;
		numOf2.y = y - 15;
		numOf2:rotate(-12.5);
		
		numOf3.anchorX = 0.5;
		numOf3.anchorY = 0.5;
		numOf3.x = numOf2.x + numOf2.width/2 + numOf3. width/2;
		numOf3.y = y - 20;
		numOf3:rotate(-12.5);
		
		numOf4.anchorX = 0.5;
		numOf4.anchorY = 0.5;
		numOf4.x = numOf3.x + numOf3.width/2 + numOf4. width/2;
		numOf4.y = y - 25;
		numOf4:rotate(-12.5);
		
		combo.y = y - 35;
		
		sceneGroup:insert(numOf);
		sceneGroup:insert(numOf2);
		sceneGroup:insert(numOf3);
		sceneGroup:insert(numOf4);
	elseif numberOfCombo > 99 then
		numOf2 = display.newImageRect("image/"..numOfComboString:sub(1,1)..".png", 15, 20);
		numOf3 = display.newImageRect("image/"..numOfComboString:sub(2,2)..".png", 15, 20);
		numOf4 = display.newImageRect("image/"..numOfComboString:sub(3,3)..".png", 15, 20);
		
		numOf2.anchorX = 0.5;
		numOf2.anchorY = 0.5;
		numOf2.x = x + times.width/2 + numOf2.width/2;
		numOf2.y = y - 10;
		numOf2:rotate(-12.5)
		
		numOf3.anchorX = 0.5;
		numOf3.anchorY = 0.5;
		numOf3.x = numOf2.x + numOf2.width/2 + numOf3. width/2;
		numOf3.y = y - 15;
		numOf3:rotate(-12.5);
		
		numOf4.anchorX = 0.5;
		numOf4.anchorY = 0.5;
		numOf4.x = numOf3.x + numOf3.width/2 + numOf4. width/2;
		numOf4.y = y - 20;
		numOf4:rotate(-12.5);
		
		combo.y = y - 30;
		
		sceneGroup:insert(numOf2);
		sceneGroup:insert(numOf3);
		sceneGroup:insert(numOf4);
	elseif numberOfCombo > 9 then
		numOf3 = display.newImageRect("image/"..numOfComboString:sub(1,1)..".png", 15, 20);
		numOf4 = display.newImageRect("image/"..numOfComboString:sub(2,2)..".png", 15, 20);
		
		numOf3.anchorX = 0.5;
		numOf3.anchorY = 0.5;
		numOf3.x = x + times.width/2 + numOf3.width/2;
		numOf3.y = y - 5;
		numOf3:rotate(-15);
		
		numOf4.anchorX = 0.5;
		numOf4.anchorY = 0.5;
		numOf4.x = numOf3.x + numOf3.width/2 + numOf4. width/2;
		numOf4.y = y - 10;
		numOf4:rotate(-15);
		
		combo.y = y - 20;
		
		sceneGroup:insert(numOf3);
		sceneGroup:insert(numOf4);
	else
		numOf4 = display.newImageRect("image/"..numOfComboString:sub(1,1)..".png", 15, 20);
		numOf4.anchorX = 0.5;
		numOf4.anchorY = 0.5;
		numOf4.x = x + times.width/2 + numOf4.width/2;
		numOf4.y = y - 5;
		numOf4:rotate(-15);
		
		combo.y = y - 15;
		
		sceneGroup:insert(numOf4);
	end

	times.anchorX = 0.5;
	times.anchorY = 0.5;
	times.x = x;
	times.y = y;
	times:rotate(-12.5);
	
	combo.x = numOf4.x + combo.width/2 + numOf4.width/2;
	combo:rotate(-12.5);
	
	sceneGroup:insert(times);
	sceneGroup:insert(combo);

	function removeCombo()
		times:removeSelf();
		times=nil;
		
		combo:removeSelf();
		combo=nil;
		
		if numOf4 ~= nil then
			numOf4:removeSelf();
			numOf4=nil;
		end
		
		if numOf3 ~= nil then
			numOf3:removeSelf();
			numOf3=nil;
		end
		
		if numOf2 ~= nil then
			numOf2:removeSelf();
			numOf2=nil;
		end
		
		if numOf ~= nil then
			numOf:removeSelf();
			numOf=nil;
		end
	end
	
	timer.performWithDelay(1000, removeCombo);
end

--Function handles Change Scene-------------------------
function changeScene()
	composer.gotoScene("gameover", sceneFading);
	composer.removeScene("gameplay", true);
end

function init()	--reset all values
	level = 1;
	spawnDelay = 2500;
	escapeDelay = 2000;
	obtainedScore = 0;
	chanceOfGrey = 10;
	defeat = false;
	combo = 1;
	totalBad = 1;
	currentShot = 0;
	actualCombo = 0;
end

function clearScene()	--remove eventlistener, timer, display objects
	transition.cancel();
	Runtime:removeEventListener("enterFrame", update);	--remove enterframe event listener
	pauseButton:removeEventListener("touch", pauseHandler)
	
	if updateTimer[1] ~= nil then	--stop timer if exists(Spawn characters)
		timer.cancel(updateTimer[1]);
	end
	
	if updateTimer[2] ~= nil then
		timer.cancel(updateTimer[2]);	--stop timer if exists(Spawn characters)
	end
	
	if updateTimer[3] ~= nil then
		timer.cancel(updateTimer[3]);	--stop timer if exists(Spawn Characters)
	end
	
	if updateTimer[4] ~= nil then
		timer.cancel(updateTimer[4]);	--stop timer if exists(Spawn Characters)
	end
	
	if updateTimer[10] ~= nil then
		timer.cancel(updateTimer[10]);	--stop crow timer
	end
	
	if updateTimer[11] ~= nil then
		timer.cancel(updateTimer[11]);	--stop crow timer
	end
	
	winodws = nil;	--remove windows
	bg = nil;	--remove background
	showScore = nil;	--remove textfield (score)
	showLevel = nil;	--remove textfield (level)
	showHighScore();
	
	for i = 1, 10 do
		clearSlot(i);
	end
	
	for i = 1, table.maxn(cat) do
		if cat[i] ~= nil and cat[i].state ~= "gone" then
			cat[i]:removeSelf();
			cat[i]=nil;
		end
	end
end

function pauseHandler(event)
	if event.phase == "began" then
		for k, v in pairs(updateTimer) do
			timer.pause(v);	--pause spawn timer
		end
		
		transition.pause();	--pause all transition
		
		for i = table.maxn(cat)-10, table.maxn(cat) + 10 do	--latest 8 cats
			if i > 0 then
				if cat[i] ~= nil and cat[i].state ~= "gone" then
					cat[i]:removeEventListener("touch", touchEventListener);
				end
			end
		end
		composer.showOverlay("pause");
	end
end

--------------------------------------------------------
function clearSlot(nSlot)	--free the window
	slotInUse[nSlot] = 0;
end

function spawnTarget(spawnType, spawnLocation)	--spawn random character at random window after
	if defeat then	--stop spawning character if player already lose the game
		return true;
	end

	local catX = 0;
	local catY = 0;
	local slot = 0;
	local firstRow = 144;	--150
	local secondRow = 295;
	local temp;
	
	for i = 0, 9 do	--set the location for each window
		if spawnLocation == i+1 then
			if slotInUse[i+1] == 1 then	--if there is a cat at the window already
				if level < 17 then
				--and the current level is less than 17
					getRandom();	--immediately spawn another cat
					return true;
				else
					return true;
				end
			else
				if i < 5 then
					catX = 77 + 103*i;
					catY = firstRow;
				else
					catX = 77+ 103*(i-5);
					catY = secondRow;
				end
				slot = i+1;
				slotInUse[i+1] = 1;
			end
		end
	end
	
	local removeCat = function(obj)	--function to remove the cat
		if defeat then	--stop remove the cat if player already lose the game
			return true;
		end
		
		if obj.type == "bad" then	--if a correct target ran away
			if playSFX then
				local availableChannel = audio.findFreeChannel()
				audio.play(wrongSFX, { channel=availableChannel });
			end
			defeat = true;
			timer.performWithDelay(750, changeScene, 1);
		end
	
		local nSlot = obj.id;	--free the window
		clearSlot(nSlot);
		obj.state = "gone";
		obj:removeSelf();	--remove the target
		obj = nil;
	end
	
	if spawnType == 1 then 
		temp = display.newSprite(badSheet, badData);
		temp.type = "bad";
		temp.index = totalBad;
		totalBad = totalBad + 1;
		local availableChannel = audio.findFreeChannel()
		audio.play(spawnBad, { channel=availableChannel });
	elseif spawnType == 2 then
		temp = display.newSprite(goodSheet, goodData);
		temp.type = "good";
		local availableChannel = audio.findFreeChannel()
		audio.play(spawnGood, { channel=availableChannel });
		
	end
	
	temp:scale(0.0225, 0.0225);
	temp:setSequence("idle");
	temp:play();
	temp.anchorX = 0.5;	
	temp.anchorY = 0.5;
	temp.x = catX;
	temp.y = catY;
	
	if temp.y == 144 then
		temp.row = "first";
	elseif temp.y == 295 then
		temp.row = "second";
	end
	sceneGroup:insert(temp);

	temp:addEventListener("touch", touchEventListener);	--attach a touch event handle to the character
	temp:toBack();	--send the object to a previous layer
	temp.id = slot;		--attach the window number to the character
	cat[#cat+1] = temp;	
	
	transition.to(cat[#cat], {time=750, x=(catX), y=(catY-20)});	--move the character to 20pixel above the current location
	--move the character back to the previous location after a delay, remove the character after the transformation
	transition.to(cat[#cat], {time=750, delay = escapeDelay, x=(catX), y=(catY + 20), onComplete=removeCat})
end

--window/cat/background--layers

function getRandom()
	local rNum = math.random(100);
	local num = math.random(10);
	
	if rNum >= chanceOfGrey then
		spawnTarget(1, num);
	else
		spawnTarget(2, num);
	end
end

function crowFrom()
	local num = math.random(2);
	local num2 = math.random(2)
	
	if playSFX then
		local availableChannel = audio.findFreeChannel()
		audio.play(crowSFX, { channel=availableChannel });
	end
	
	if num2 == 1 then
		crow.appear = "top";
		crow.y = _H/2 - 50;
	elseif num2 == 2 then
		crow.appear = "bottom";
		crow.y = _H/2 + 100;
	end
	
	if num == 1 then
		crow.direction = "left";
		crow.xScale = 0.12;
		crow.x = _W + 50;
		transition.to(crow,{time = 2000, x = (-50), y = (crow.y)});
	elseif num == 2 then
		crow.direction = "right";
		crow.xScale = -0.12;
		crow.x = -50;
		transition.to(crow,{time = 2000, x = (_W + 50), y = (crow.y)});
	end
end

function crow2From()
	local num = math.random(2);
	local num2 = math.random(2)
	
	if playSFX then
		local availableChannel = audio.findFreeChannel()
		audio.play(crow2SFX, { channel=availableChannel });
	end
	
	if num2 == 1 then
		crow2.appear = "top";
		crow2.y = _H/2 - 50;
	elseif num2 == 2 then
		crow2.appear = "bottom";
		crow2.y = _H/2 + 100;
	end
	
	if num == 1 then
		crow2.direction = "left";
		crow2.xScale = 0.12;
		crow2.x = _W + 50;
		transition.to(crow2,{time = 2000, x = (-50), y = (crow2.y)});
	elseif num == 2 then
		crow2.direction = "right";
		crow2.xScale = -0.12;
		crow2.x = -50;
		transition.to(crow2,{time = 2000, x = (_W + 50), y = (crow2.y)});
	end
end

function update(event)
	if not defeat then
		windows:toBack();
		pauseButton:toFront();
	end
	
	if showScore ~= nil then	--update the score
		showScore:toFront();
		showScore.text = score;
	end
	
	if showLevel ~= nil then	--update the level
		showLevel:toFront();
		showLevel.text = "LEVEL:"..level;
	end

	--LEVEL UP ------
	if currentShot >= level then
		level = level + 1;
		if spawnDelay > 250 then	--spawn delay cannot be less than 250ms
			spawnDelay = spawnDelay - (50 + level*35);	--decrease the spawn delay
		end
		if chanceOfGrey < 35 then	--chance of spawning an incorrect target cannot be more than 50%
			chanceOfGrey = chanceOfGrey + 0.125 * level;	--increase the chance of spawning a grey cat
		end
		if escapeDelay > 350 then	--the life time of the cat cannot be less than 350ms
			escapeDelay = escapeDelay - (50 + level * 2.5);	--decrease the life time of the cats
		end
		currentShot = 0;
	end

	if updateTimer[1] == nil then
		updateTimer[1] = timer.performWithDelay(spawnDelay, getRandom, 0);	--update the timer
	end
	
	if level >=5 and updateTimer[2] == nil then	--add a new timer to spawn character if reaching level 5
		updateTimer[2] = timer.performWithDelay(spawnDelay, getRandom, 0);	--update the timer
	end
	
	if level >= 8 and updateTimer[3] == nil then	--add a new timer to spawn character if reaching level 8
		updateTimer[3] = timer.performWithDelay(spawnDelay, getRandom, 0);
	end
	
	if level >= 20 and updateTimer[4] == nil then
		updateTimer[4] = timer.performWithDelay(spawnDelay, getRandom, 0);
	end
	
	if updateTimer[10] == nil then
		updateTimer[10] = timer.performWithDelay((7 + math.random(10))*1000, crowFrom, 0);
	end
	
	if updateTimer[11] == nil then
		--updateTimer[11] = timer.performWithDelay((3 + math.random(8))*1000, crow2From, 0);
	end
	
	local function changeBGM()
		audio.play(bgm2, bgmOptions);
	end
end

function scene:create(event)	--create level
	sceneGroup = self.view;
	init();
	score = 0;
	
	windows = display.newImageRect("image/background5.png",_W,_H);	--add background image
	windows.anchorX = 0.5;
	windows.anchorY = 0.5;
	windows.x = _W/2;
	windows.y = _H/2; 
	
	bg = display.newImageRect("image/background4.png",_W,_H);	--add background image
	bg.anchorX = 0.5;
	bg.anchorY = 0.5;
	bg.x = _W/2;
	bg.y = _H/2;

	crow = display.newSprite(crowSheet, crowData);
	crow.anchorX = 0.5;
	crow.anchorY = 0.5;
	crow.x = _W + 100;
	crow.y = _H/2 - 50;
	crow:scale(0.12, 0.12);
	crow:play();
	
	crow2 = display.newSprite(crowSheet, crowData);
	crow2.anchorX = 0.5;
	crow2.anchorY = 0.5;
	crow2.x = _W + 100;
	crow2.y = _H/2 - 50;
	crow2:scale(0.12, 0.12);
	crow2:play();
	
	showScore = display.newText(score, _W/2, 20, myFontStyle, 30); 	--add score(value)
	showLevel = display.newText("LEVEL:"..level, 60, 20, myFontStyle, 30);	--add level(value)

	pauseButton = display.newImageRect("image/pause.png", 30,30);
	pauseButton.anchorX = 0.5;
	pauseButton.anchorY = 0.5;
	pauseButton.x = _W - 50;
	pauseButton.y = pauseButton.height/2 + 10;
	pauseButton:addEventListener("touch", pauseHandler);
	
	sceneGroup:insert(windows);
	sceneGroup:insert(bg);
	sceneGroup:insert(showScore);
	sceneGroup:insert(showLevel);
	sceneGroup:insert(pauseButton);
	sceneGroup:insert(crow);
	sceneGroup:insert(crow2);

	Runtime:addEventListener("enterFrame", update);	--add update event
	
	updateTimer[1] = nil;	--reset timer
	updateTimer[2] = nil;
	updateTimer[3] = nil;
	updateTimer[4] = nil;
	updateTimer[10] = nil;
	updateTimer[11] = nil;
end

function scene:destroy(event)
	clearScene();
end

scene:addEventListener( "create", scene);
scene:addEventListener( "destroy", scene);

return scene;