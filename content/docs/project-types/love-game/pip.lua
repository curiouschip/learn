local socket = require("socket")
socket.unix = require("socket.unix")

local conn = assert(socket.unix())
conn:connect('/opt/pip/var/run/serialmux')

function readMessage()
  length = conn:receive(2)
  length = string.byte(length, 2)
  conn:receive(length)
end

function writeMessage(data)
  conn:send(string.char(0, string.len(data)))
  conn:send(data)
end

local pip = {leds = {}}
local ledBrightness = 32

function pip.leds.clear()
  -- 0x03	: peripherals subsystem
  -- 1		: correlation ID
  -- 2		: LEDs peripheral
  -- 1		: opcode = clear
  -- 0		: no args
  writeMessage(string.char(0x03, 1, 2, 1, 0))
  readMessage()
end

function scale(v)
  return math.floor((v/255)*ledBrightness)
end

function pip.leds.setBrightness(b)
  ledBrightness = b
end

function pip.leds.setAll(r, g, b)
  -- 0x03	: peripherals subsystem
  -- 1		: correlation ID
  -- 2		: LEDs peripheral
  -- 2		: opcode = set-all
  -- 3		: 3 bytes of args
  -- r		: red
  -- g		: green
  -- b		: blue
  writeMessage(string.char(0x03, 1, 2, 2, 3, scale(r), scale(g), scale(b)))
  readMessage()
end

function pip.leds.setOne(i, r, g, b)
  -- 0x03	: peripherals subsystem
  -- 1		: correlation ID
  -- 2		: LEDs peripheral
  -- 3		: opcode = set-mask
  -- 4		: 4 bytes of args
  -- m		: mask (single bit set denoting LED offset)
  -- r		: red
  -- g		: green
  -- b		: blue
  writeMessage(string.char(0x03, 1, 2, 3, 4, bit.lshift(1, i-1), scale(r), scale(g), scale(b)))
  readMessage()
end

return pip