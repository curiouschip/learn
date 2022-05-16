---
weight: 10
title: "LÖVE Game"
---

# LÖVE Game

## Overview

The LÖVE Game project type allows you to make games based on the popular Lua library
[LÖVE](https://love2d.org).

## Getting Started

Here is a basic project skeleton that initialise LÖVE for use on Pip, supporting the
built-in gamepads (if attached). This code should go in `main.lua`.

```lua
local joystick

function love.load()
    love.mouse.setVisible(false)
    love.window.setMode(800, 480, {centered = true})

    for i, j in ipairs(love.joystick.getJoysticks()) do
    	local jname = j:getName()
    	if jname == "Pip Virtual Gamepad" then
      		print("axis count", j:getAxisCount())
      		io.flush()
      		joystick = j
      		break
    	end
  	end
end

function love.update(dt)
    
end

function love.draw()
    
end

```

## Project Layout

  - `main.lua` - code goes here
  - `assets/` - put images, sounds, etc. in this folder

## Controlling the LEDs

To add LED control to your LÖVE project, firstly download the <a href='pip.lua' download='pip.lua'>Pip Lua Library</a>,
and add it to your project with the filename `pip.lua`. Then, in your main code, load it as such:

```lua
local pip = require("pip")
```

You now have access to the following functions:

### `pip.leds.clear()`

Clear/turn off all LEDs.

### `pip.leds.setBrightness(brightness)`

Set the global brightness of all LEDs. `brightness` must be a number from 0-255 (inclusive); the
brightness value is used to scale values passed to future calls to the `set*` functions.

**Note:** calling `setBrightness()` does not affect the current state of the LEDs.

### `pip.leds.setAll(r, g, b)`

Set all LEDs to the given colour.

### `pip.leds.setOne(led, r, g, b)`

Set LED number `led` to the given colour. In Lua, Pip's LEDs are numbered left to right from 1-8.

## Notes

If you use `print()` for logging/debugging `io.flush()` must be called regularly to ensure liveness
of output. This is because LÖVE appears to delay/batch flushes when its output is not a TTY.

Communication with the LEDs is via serial port and is therefore quite slow in relation to the update
rate of a game. Measures should be taken to minimise the amount of communication, for example, by
only sending an update when the LED states are known to have changed.

## Examples

  - [Space Invaders](space-invaders.zip)

## Further Reading

  - [Official LÖVE Documentation](https://love2d.org/wiki/Main_Page)