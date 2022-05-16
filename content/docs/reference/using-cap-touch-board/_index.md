---
title: "Using Cap-touch board"
---

# Using Cap-touch Board

The cap-touch board supports multiple modes:

  - Keyboard (Numeric and Cursor) - emits standard USB keyboard events
  - Serial - sends status reports over serial
  - Gamepad - acts as a standard USB gamepad with X, Y (pad), Z (slider) axes and four buttons
  - MIDI - sends MIDI note/pitch-bend data

The easiest way to integrate the cap-touch board with your project is to put it into
either of the Keyboard modes. In both of these modes the cap-touch board acts as
a standard USB keyboard and produces events that can be consumed by your program
in the usual way.

Whether you use Numeric or Cursor mode will depend on the type of project you're working on.
For projects involving selection of items, numeric mode is recommend, wheras for games or
user interfaces, cursor mode might be more appropriate.

## Keyboard Mode (Numeric/Cursor)

### JavaScript (HTML5/Browser)

```javascript
document.body.addEventListener('keydown', function(evt) {
	// 49-56 is the range of keycodes for numeric values
	if (evt.which >= 49 && evt.which <= 56) {
		console.log("You pressed key", evt.which - 48);
	}
});
```

#### JavaScript Keycode list

{{< columns >}} <!-- begin columns block -->

##### Numeric Mode

| Key    | Keycode |
|--------|---------|
| 1      | 49      |
| 2      | 50      |
| 3      | 51      |
| 4      | 52      |
| 5      | 53      |
| 6      | 54      |
| 7      | 55      |
| 8      | 56      |

<--->

##### Cursor Mode

| Key       | Keycode |
|-----------|---------|
| UP        | 38      |
| DOWN      | 40      |
| LEFT      | 37      |
| RIGHT     | 39      |
| SPACE     | 32      |
| RETURN    | 13      |
| BACKSPACE |  8      |
| ESCAPE    | 27      |

{{< /columns >}}

### Lua/LOVE

Use the `love.keypressed()` function to handle key presses; `key` is the string key constant;
a list of all available constants can be found in the [LÖVE documentation](https://love2d.org/wiki/KeyConstant).

```lua
function love.keypressed(key, scancode, isRepeat)
  -- `key` is the key constant
end
```

### Python/Pygame

```python

```

## Serial Mode

In Serial Mode a line of ASCII text is emitted each time the state of the capacitive controls
changes. The format of the report line is as follows:

```
> X_X_X_X_ 100
```

The leading angle bracket `>` differentiates a status report from any other output that the
board might produce. Your code should ignore any lines without this prefix.

Each of the following 8 characters is either an underscore (`_`) or an X (`X`), indicating
whether the corresponding pad is touched or released, respectively.

The final numeric value is the current slider position, in the range 0-255 (inclusive), or
-1 if the slider is not currently being touched.

## Gamepad Mode

In Gamepad Mode the cap-touch board acts as an HID gamepad and controls function as follows:

  - pads 0 and 1 form a digital Y-axis that emits -128, 0, or 127
  - pads 2 and 3 form a digital X-axis that emits -128, 0, or 127
  - pads 4-7, inclusive, are four individual buttons
  - the slider is a Z-axis that emits continuous values in the range -128 to 127

## MIDI Mode

In this mode the cap-touch board acts as a MIDI peripheral and will produce note-on and note-off
events in response to touching the pads, and a pitch-bend messages when interacting with the slider.
Notes are in the C-major scale starting from middle-C (MIDI note 60), and data is transmitted
on MIDI channel 1.
