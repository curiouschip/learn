---
weight: 10
title: In-browser JavaScript
---

# In-browser JavaScript

Pip includes a JavaScript library, `pipkit.js`, that can be imported by the browser-based
projects (node.js Web App, PHP Web App) to provide access to Pip's LED, GPIO and accelerometer
hardware. This library creates a new global variable, `pip`, that is used to interact
with the hardware.

## Loading `pipkit.js`

The method by which you load `pipkit.js` varies depending on the language in use.

### PHP

Simply add the following line of code to your HTML:

```html
<script src='/pip/pipkit.js'></script>
```

In PHP projects the `/pip/` folder is automatically aliased to the correct location by
`lighttpd` so no further setup is required to make `pipkit.js` accessible via HTTP.

### node.js

In node.js projects the simplest approach is to load `pipkit.js` into a variable from
the filesystem and directly write it out to the HTML, e.g.:

```javascript
const http = require('http')

const pipkit = require('fs').readFileSync('/opt/pip/share/neutrino/pipkit.js', 'utf8')

const html = `
<!doctype html>

<html>
  <head>
    <title></title>
    <script type='text/javascript'>
      ${pipkit}
    </script>
  </head>
  <body>
  </body>
</html>
`

const requestListener = function (req, res) {
  res.writeHead(200)
  res.end(html)
}

const server = http.createServer(requestListener)
server.listen(3000)
````

## GPIO

### `pip.gpio.setPinFunction(pin, function)`

Set a pin's function. Valid functions:

  - `pip.PIN_FUNC_GPIO`: pin is a GPIO
  - `pip.PIN_FUNC_PWM`: pin outputs a PWM signal

{{< hint warning >}}
Only certain pins support PWM. See the [GPIO Pins](/docs/reference/gpio-pins/) page for more information.
{{< /hint >}}

### `pip.gpio.setPinMode(pin, mode)`

Set a pin's mode. This only affects pins whose function is set to `PIN_FUNC_GPIO`. Valid modes:

  - `pip.PIN_MODE_INPUT`: pin is an input
  - `pip.PIN_MODE_INPUT_PULLUP`: pin is an input with internal pull-up resistor
  - `pip.PIN_MODE_INPUT_PULLDOWN`: pin is an input with internal pull-down resistor
  - `pip.PIN_MODE_OUTPUT`: pin is an output

### `pip.gpio.digitalWrite(pin, level)`

Set a `pin`'s output `level` to high (`true`) or low (`false`). `pin` should be assigned the GPIO
function and be in the output mode.

### `pip.gpio.digitalRead(pin)`

Read `pin`'s `level` and return it as either high (`true`) or low (`false`). `pin` should be assigned the GPIO
function and be in the one of the various input modes.

### `pip.gpio.pwmWrite(pin, level)`

Set `pin`'s PWM duty cycle to `level`. `pin` should be assigned the PWM function, and `level` should be
a number from 0-255 (inclusive).

{{< hint warning >}}
Only certain pins support PWM. See the [GPIO Pins](/docs/reference/gpio-pins/) page for more information.
{{< /hint >}}

## LEDs

### `pip.leds.getBrightness()`

Returns the current brightness setting for the LEDs.

### `pip.leds.setBrightness(brightness)`

Set the global brightness of all LEDs. `brightness` must be a number from 0-255 (inclusive); the
brightness value is used to scale values passed to future calls to the `set*` functions.

The default brightness value is 80.

**Note:** calling `setBrightness()` does not affect the current state of the LEDs.

### `pip.leds.clear(force)`

Clear all LEDs. Set `force` to true to bypass the library's internal buffer.

### `pip.leds.setOne(led, r, g, b)`

Set LED number `led` (from 0-7, inclusive) to the given colour.

### `pip.leds.setAll(r, g, b)`

Set all LEDs to the given colour.

### `pip.leds.setMask(mask, data)`

Set the colour of specific LEDs, leaving others unchanged. This is the most efficient way to update
multiple LEDs.

`mask` is an 8-bit value, with a bit set for each LED to update, and `data` is an array containing
three elements (RGB values) for each bit set in `mask`. The first three elements represent the colour
assigned to the LED identified by the first bit set in `mask`, and so on. For example:

```javascript
pip.leds.setMask(0x41, [
  255, 0, 0, // LED 0 - (0x01)
  0, 255, 0  // LED 6 - (0x40)
]);
```

This code updates LEDs 0 and 6 (because bits 1 and 7 are set in `0x41`) to red and green, respectively.

## Accelerometer

### `pip.accelerometer.setPollInterval(ms)`

Set the interval (in milliseconds) at which the backend will poll the accelerometer for new readings.

### `pip.accelerometer.read()`

Read the latest polled value from the accelerometer.

Return value:

```
{ x: <number>, y: <number>, z: <number> }
```

## Examples

### Flashing the RGB LEDs

This example flashes the RGB LEDs between and red and off every 0.5 seconds.

```html
<html>
  <head>
    <script src='/pip/pipkit.js'></script>
    <script>
      function init() {
        var on = false;
        setInterval(function() {
          on = !on;
          var level = on ? 100 : 0
          pip.leds.setAll(level, 0, 0);
        }, 500);
      }
    </script>
  </head>
  <body onload='init()'>
    <h1>LED Flash</h1>
  </body>
</html>
```

### Toggle a GPIO with a button

This example toggles GPIO pin 2 whenever the button is tapped.

```html
<html>
  <head>
    <script src='/pip/pipkit.js'></script>
    <script>
      const gpio = 2;
      var on = true;

      function init() {
        pip.gpio.setPinFunction(gpio, pip.PIN_FUNC_GPIO);
        pip.gpio.setPinMode(gpio, pip.PIN_MODE_OUTPUT);
        toggle();
      }

      function toggle() {
        on = !on;
        pip.gpio.digitalWrite(gpio, on);
      }
    </script>
  </head>
  <body onload='init()'>
    <button onclick='toggle()' style='width: 200px; height: 120px'>TOGGLE PIN</button>
  </body>
</html>
```