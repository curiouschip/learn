local pip = require("pip")
local gamelib = require("gamelib")

gfx = {
  alienShip = love.graphics.newImage('assets/alienShip.png'),
  background = love.graphics.newImage('assets/background.png'),
  font = love.graphics.newImage('assets/font.png'),
  missileAlien = love.graphics.newImage('assets/missileAlien.png'),
  missilePlayer = love.graphics.newImage('assets/missilePlayer.png'),
  playerShip = love.graphics.newImage('assets/playerShip.png')
}

sfx = {
  boom = love.audio.newSource('assets/boom.wav', 'static'),
  dead = love.audio.newSource('assets/dead.wav', 'static'),
  laser = love.audio.newSource('assets/laser.wav', 'static')
}

local font = gamelib.Font:new(gfx.font, {
  characterWidth = 16,
  characterHeight = 16,
  lines = 1,
  charactersPerLine = 96,
  characterCount = 96,
  startOffset = 32,
  variants = {'blue', 'silver', 'gold'}
})

GAME_OVER_TIME = 1
ALIEN_SHOOT_CHANCE = 0.001
PLAYER_SHOOT_DELAY = 0.5
ALIEN_SPEED = 120
PLAYER_SPEED = 390
START_LIVES = 4
LIFE_COLOR = {0, 40, 0}
BORDER = 15
PLAYER_MISSILE_SPEED = 300
ALIEN_MISSILE_SPEED = 400
ROTATE_MISSILES = false

local joystick,
  rotation,
  gameOverTimer,
  player,
  aliens,
  playerMissiles,
  alienMissiles,
  score,
  aliensMovingRight,
  leftEdge,
  rightEdge,
  ledBuffer

function drawOne(e)
  love.graphics.draw(e.image, e.position.x, e.position.y)
end

function drawAll(es)
  es:forEach(function(e, i, state) drawOne(e) end)
end

function moveOne(e, dt)
  e.position.x = e.position.x + (e.speed.x * dt)
  e.position.y = e.position.y + (e.speed.y * dt)
end

function moveAll(es, dt)
  es:forEach(function(e, i, state) moveOne(e, dt) end)
end

function cull(lst)
  gamelib.cull(lst)
end

function canFire()
  return (love.timer.getTime() - player.lastShotAt) > PLAYER_SHOOT_DELAY
end

function setup(lives)
  if lives == nil then
    lives = START_LIVES
    score = 0
  end
  
  if lives == 0 then
    gameOverTimer = GAME_OVER_TIME
    return
  else
    gameOverTimer = 0
  end

  leftEdge = gamelib.entity({shape = 'rect', position = { x = BORDER - 100, y = 0 }, size = { width = 100, height = 480 }})
  rightEdge = gamelib.entity({shape = 'rect', position = { x = 800 - BORDER, y = 0 }, size = { width = 100, height = 480 }})

  player = gamelib.entity({
    image = gfx.playerShip,
    lastShotAt = 0,
    position = {
      x = 400 - gfx.playerShip:getWidth() / 2,
      y = 480 - (BORDER + 16 + BORDER) - gfx.playerShip:getHeight()
    },
    speed = {
      x = 0,
      y = 0
    },
    shape = 'rect',
    size = {
      width = gfx.playerShip:getWidth(),
      height = gfx.playerShip:getHeight()
    },
    lives = lives
  })

  aliens = gamelib.EntityList:new()
  local alienStartX = BORDER
  local alienStartY = BORDER
  local alienHSpacing = 10 + gfx.alienShip:getWidth()
  local alienVSpacing = 10 + gfx.alienShip:getHeight()
  for row = 0,3 do
    for col = 0,7 do
      local thisAlien = gamelib.entity({
        image = gfx.alienShip,
        position = {
          x = alienStartX + (alienHSpacing * col),
          y = alienStartY + (alienVSpacing * row)
        },
        speed = { x = ALIEN_SPEED, y = 0 },
        shape = 'rect',
        size = {
          width = gfx.alienShip:getWidth(),
          height = gfx.alienShip:getHeight()
        }
      })
      aliens:add(thisAlien)
    end
  end

  playerMissiles = gamelib.EntityList:new()
  alienMissiles = gamelib.EntityList:new()
  aliensMovingRight = true
  rotation = 0
end

function love.load()
  love.mouse.setVisible(false)
  love.window.setTitle("Space Invaders")
  love.window.setMode(800, 480, {centered = true})

  ledBuffer = {}
  for l = 1,8 do
    ledBuffer[l] = {0,0,0}
  end
  
  for i, j in ipairs(love.joystick.getJoysticks()) do
    local jname = j:getName()
    if jname == "Pip Virtual Gamepad" then
      print("axis count", j:getAxisCount())
      io.flush()
      joystick = j
      break
    end
  end
  
  setup()
end

function wantsToMoveLeft()
  return love.keyboard.isDown("left") or (joystick and joystick:getAxis(1) < 0)
end

function wantsToMoveRight()
  return love.keyboard.isDown("right") or (joystick and joystick:getAxis(1) > 0)
end

function wantsToFire()
  return love.keyboard.isDown("space") or (joystick and joystick:isDown(2))
end

function love.update(dt)
  if gameOverTimer > 0 then
    gameOverTimer = gameOverTimer - dt
    if gameOverTimer < 0 then
      setup()
    end
    return
  end
  
  if wantsToMoveLeft() then
    player.speed.x = -PLAYER_SPEED
  elseif wantsToMoveRight() then
    player.speed.x = PLAYER_SPEED
  else
    player.speed.x = 0
  end

  if wantsToFire() and canFire() then
    player.lastShotAt = love.timer.getTime()
    playerMissiles:add(gamelib.entity({
      image = gfx.missilePlayer,
      position = {
        x = player.position.x + (player.size.width / 2) - (gfx.missilePlayer:getWidth() / 2),
        y = player.position.y - (gfx.missilePlayer:getHeight() - 10)
      },
      speed = { x = 0, y = -PLAYER_MISSILE_SPEED },
      shape = 'rect',
      size = {
        width = gfx.missilePlayer:getWidth(),
        height = gfx.missilePlayer:getHeight()
      }
    }))
    sfx.laser:play()
  end

  aliens:forEach(function(alien, i)
    if love.math.random() < ALIEN_SHOOT_CHANCE then
      alienMissiles:add(gamelib.entity({
        image = gfx.missileAlien,
        position = {
          x = (alien.position.x + alien.size.width / 2) - gfx.missileAlien:getWidth(),
          y = alien.position.y + alien.image:getHeight()
        },
        speed = {
          x = 0,
          y = ALIEN_MISSILE_SPEED
        },
        shape = 'rect',
        size = {
          width = gfx.missileAlien:getWidth(),
          height = gfx.missileAlien:getHeight(),
        }
      }))
    end
  end)

  moveOne(player, dt)
  if player.position.x < BORDER then
    player.position.x = BORDER
  elseif player.position.x >= (800 - BORDER - player.size.width) then
    player.position.x = 800 - BORDER - player.size.width
  end

  moveAll(aliens, dt)
  moveAll(playerMissiles, dt)
  moveAll(alienMissiles, dt)

  if gamelib.collide(player, alienMissiles) or gamelib.collide(player, aliens) then
    sfx.dead:play()
    setup(player.lives - 1)
    return
  end

  gamelib.collide(aliens, playerMissiles, function(alien, missile)
    aliens:remove(alien)
    playerMissiles:remove(missile)
    sfx.boom:play()
    score = score + 10
  end)

  -- Shift aliens down + change direction if edge is hit
  change = (aliensMovingRight and gamelib.collide(aliens, rightEdge)) or ((not aliensMovingRight) and gamelib.collide(aliens, leftEdge))
  if change then
    aliensMovingRight = not aliensMovingRight
    aliens:forEach(function(e, i)
      e.speed.x = e.speed.x * -1
      e.position.y = e.position.y + 20
    end)
  end

  cull(alienMissiles)
  cull(playerMissiles)

  aliens:purge()
  alienMissiles:purge()
  playerMissiles:purge()

  if aliens:isEmpty() then
    setup(player.lives)
  end
end

local lastLives = -1

function love.draw()
  local drawLEDs = true
  if gameOverTimer > 0 then
    for i = 1,8 do
      local r = 16 + math.floor(love.math.random() * 24)
      ledBuffer[i][1] = r
      ledBuffer[i][2] = math.floor(love.math.random() * (r /2 ))
      ledBuffer[i][3] = 0
    end
  elseif player.lives ~= lastLives then
    lastLives = player.lives
    for i = 1,8 do
      if player.lives >= i then
        ledBuffer[i][1] = LIFE_COLOR[1]
        ledBuffer[i][2] = LIFE_COLOR[2]
        ledBuffer[i][3] = LIFE_COLOR[3]
      else
        ledBuffer[i][1] = 0
        ledBuffer[i][2] = 0
        ledBuffer[i][3] = 0
      end
    end
  else
    drawLEDs = false
  end
  
  if drawLEDs then
    for i = 1,8 do
      pip.leds.setOne(i, ledBuffer[i][1], ledBuffer[i][2], ledBuffer[i][3])
    end
  end
  
  love.graphics.draw(gfx.background, 0, 0)
  drawAll(aliens)
  drawOne(player)
  drawAll(playerMissiles)
  drawAll(alienMissiles)

  gamelib.setFont(font, 1)
  gamelib.print(BORDER, 480 - (BORDER + 16), "SCORE: " .. score)

  if gameOverTimer > 0 then
    gamelib.setFont(font, 3)
    gamelib.print(304, 240, "GAME OVER!!!")
  end
end
