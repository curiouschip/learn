Items = {
	'apple',
	'banana',
	'can',
	'coin',
	'foil',
	'key',
	'spoon',
	'water'
}

EnableImages = true
EnableSounds = true
UseTimer = true
ShowDuration = 1.0
WinDuration = 1.0
ShowGap = 0.5

--
--
--

Seq = {}
Images = {}
Sounds = {}
ImageSize = 150
ButtonSize = 180
BigSize = 300
Buttons = {
	{100,180}, {300,180}, {500,180}, {700,180},
	{100,380}, {300,380}, {500,380}, {700,380}
}

for i, item in ipairs(Items) do
	Images[i] = love.graphics.newImage('assets/' .. item .. '.png')
	Sounds[i] = love.audio.newSource('assets/' .. item .. '.mp3', 'static')
end

font = love.graphics.newFont("assets/font.ttf", 32)
love.graphics.setFont(font)

currentState = 'intro'
stateVars = {}
timeInState = 0
guessProgress = 1

function setState(newState)
	currentState = newState
	stateVars = {}
	if States[newState].enter then
		States[newState].enter(stateVars)
	end
	timeInState = 0
end

States = {
	intro = {
		touch = function(x, y)
			Seq = {}
			addRandomItemToSequence()
			setState('showSequence')
		end,
		update = function(dt, vars)
			-- nothing
		end,
		draw = function(vars)
			love.graphics.setColor(0.0, 0.0, 1.0, 1)
			love.graphics.rectangle("fill", 0, 0, 800, 480)
			love.graphics.setColor(1.0, 1.0, 0.0, 1)
			love.graphics.printf("Repeat the sequence\nshown on the screen\nusing the touchscreen\nor cap touch board", 0, 180, 800, 'center')
		end
	},
	showSequence = {
		enter = function(vars)
			vars.index = 1
			vars.s = true
			vars.p = 0
			vars.e = getDurationForSequenceIndex(1, ShowDuration)
			playSoundAtSequenceIndex(1)
		end,
		update = function(dt, vars)
			vars.p = vars.p + dt
			if vars.p >= vars.e then
				if vars.s then
					vars.s = false
					vars.p = 0
					vars.e = ShowGap
				else
					vars.s = true
					vars.index = vars.index + 1
					if vars.index > table.getn(Seq) then
						setState('enterSequence')
					else
						vars.p = 0
						vars.e = getDurationForSequenceIndex(vars.index, ShowDuration)
						playSoundAtSequenceIndex(vars.index)
					end
				end
			end
		end,
		draw = function(vars)
			if vars.s and EnableImages then
  				drawCenteredItem(Seq[vars.index])
			end
		end
	},
	enterSequence = {
		enter = function(vars)
			guessProgress = 1
		end,
		touch = function(x, y)
			local guess = -1
			for i, btn in ipairs(Buttons) do
				if inButton(btn, x, y) then
					guess = i
					break
				end
			end
			doGuess(guess)
		end,
		keypress = function(key, scancode)
			doGuess(string.byte(key) - string.byte("1") + 1)
		end,
		update = function(dt, vars)
			
		end,
		draw = function(vars)
			love.graphics.setColor(1.0, 1.0, 0.0, 1)
			love.graphics.print("Pick item " .. tostring(guessProgress), 15, 30)
			drawSelectorScreen()
		end
	},
	win = {
		enter = function(vars)
		    addRandomItemToSequence()
			local dur = getDurationForSequenceIndex(table.getn(Seq), WinDuration - 1.0)
			dur = dur + 1.0
			vars.duration = dur
		end,
		update = function(dt, vars)
			if timeInState > vars.duration then
				setState('showSequence')
			end
		end,
		draw = function(vars)
			love.graphics.setColor(0.0, 0.0, 1.0, 1)
			love.graphics.rectangle("fill", 0, 0, 800, 480)
			love.graphics.setColor(0.0, 1.0, 0.0, 1)
			love.graphics.printf("WIN!", 0, 220, 800, 'center')
		end
	},
	gameOver = {
		update = function(dt, vars)
			if timeInState > 3 then
				setState('intro')
			end
		end,
		draw = function(vars)
			love.graphics.setColor(1.0, 0.0, 0.0, 1)
			love.graphics.rectangle("fill", 0, 0, 800, 480)
			love.graphics.setColor(1.0, 1.0, 0.0, 1)
			love.graphics.printf("GAME OVER!", 0, 220, 800, 'center')
		end
	}
}

function love.load()
    love.mouse.setVisible(false)
end

function love.update(dt)
    timeInState = timeInState + dt
	States[currentState]["update"](dt, stateVars)
end

function love.draw()
	States[currentState]["draw"](stateVars)
end

function love.keypressed(key, scancode, isRepeat)
	if isRepeat then
		return
	end
	hnd = States[currentState].keypress
	if hnd then
		hnd(key, scancode)
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	hnd = States[currentState].touch
	if hnd then
		hnd(x, y)
	end
end

function doGuess(guess)
	if guess < 1 or guess > 8 then
		return
	end
	playSound(guess)
	if guess == Seq[guessProgress] then
		guessProgress = guessProgress + 1
		if guessProgress > table.getn(Seq) then
			setState('win')
		end
	else
		setState('gameOver')
	end	
end

function drawCenteredItem(i)
	local img = Images[i]
	local scaleX = BigSize / img:getWidth()
	local scaleY = BigSize / img:getHeight()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(img, 400 - BigSize/2, 240 - BigSize/2, 0, scaleX, scaleY)
end

function drawSelectorScreen()
	for btn = 1,table.getn(Items) do
		local img = Images[btn]
		local scaleX = ImageSize / img:getWidth()
		local scaleY = ImageSize / img:getHeight()
		local pos = Buttons[btn]
		local left = pos[1] - ButtonSize / 2
		local top = pos[2] - ButtonSize / 2
		love.graphics.setColor(0.2, 0.2, 0.3, 1)
		love.graphics.rectangle("fill", left, top, ButtonSize, ButtonSize, 20, 20)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(img, pos[1] - ImageSize / 2, pos[2] - ImageSize / 2, 0, scaleX, scaleY)
		love.graphics.print(tostring(btn), left + 10, top + 10)
	end
end

function addRandomItemToSequence()
	v = love.math.random(table.getn(Items))
	table.insert(Seq, v)
end

function getDurationForSequenceIndex(i, defaultValue)
	item = Seq[i]
	dur = defaultValue
	if EnableSounds and dur < Sounds[item]:getDuration() then
		dur = Sounds[item]:getDuration()
	end
	return dur
end

function playSoundAtSequenceIndex(i)
	playSound(Seq[i])
end
		
function inButton(btn, x, y)
	local left = btn[1] - ButtonSize / 2
	local right = btn[1] + ButtonSize / 2
	local top = btn[2] - ButtonSize / 2
	local bottom = btn[2] + ButtonSize / 2
	if x < left or x > right or y < top or y > bottom then
		return false
	else
		return true
	end
end

function playSound(i)
	if not EnableSounds then
		return
	end
	stopSounds()
	s = Sounds[i]
	if s then
		s:play()
	end
end

function stopSounds()
	for i, s in ipairs(Sounds) do
		s:stop()
	end	
end