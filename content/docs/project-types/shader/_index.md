---
weight: 50
---

# Shader

## Overview

The Shader project type allows you to create visual effects by writing OpenGLES
fragment shaders. Fragment shaders work by running your code once for each pixel on
the screen, which allows for some super-cool graphical creations using code
and maths. Pip's camera is even supported too!

## Example

```glsl
// param label="Red" default=1
uniform float red;

// param label="Green" default=1
uniform float green;

// param label="Blue" default=1
uniform float blue;

void main(void) {
    vec4 c = texture2D(camera, texCoord);
    c.x *= red;
    c.y *= green;
    c.z *= blue;
    gl_FragColor = c;
}
```

## Built-in variables

The following variables are automatically added to your code and are always available.

  - `texCoord`: the texture coordinate currently being calculated
  - `gl_FragColor`: output colour for the  current texture coordinate
  - `camera`: `sampler2D` containing realtime feed from Pip's camera
  - `time`: `float` representing the number of seconds since execution began
  - `millis`: `int` representing number of milliseconds since execution began

## Parameters

It's possible to add parameters to your Shader sketches and have Pip auto-generate sliders
for tweaking their values in real-time. To do this, declare your parameters as GLSL `uniform`
variables, give it a `// param` comment, and optionally add tags to customise how the
slider should behave:

```glsl
// param label="Red Level" min=0 max=1
uniform float red;
```

The code snippet above will create a slider labelled "Red Level" that modifies the variable `red`,
restricted to values between 0 and 1. The complete list of support tags is:

  - `min`: minimum value
  - `max`: maximum value
  - `default`: default value
  - `step`: amount by which value changes
  - `label`: text label to display beside slider

For `bool` variables, `min` is always 0, `max` is always 1, and step is always 1. `int` and `uint` variables
have a default range of 0-100 with a default step of 1, and `float` variables have a default range of 0-1
with a step of 0.

The sliders' on-screen visibility can be toggled by pressing Pip's top-right shoulder button
(**Note:**&nbsp;the controllers must be detached).
