---
weight: 40
---

# Pygame Game

## Overview

The Pygame Game project type allows you to make games based on the popular Python library
[Pygame](https://www.pygame.org).

## Getting Started

Here is a basic project skeleton that initialise Pygame for use on Pip, supporting the
built-in gamepads (if attached). This code should go in `main.py`.

```python
import pygame
import sys
import math
import os

# Get the full path to the assets directory
asset_dir = os.path.split(os.path.abspath(__file__))[0] + "/assets"

# Initialise pygame
pygame.init()

# This function find Pip's gamepad and closes any other joysticks
def getGamepad():
	the_stick = None
    joysticks = pygame.joystick.get_count()
    for i in range(0, joysticks):
        s = pygame.joystick.Joystick(i)
        if s.get_name() != "Pip Virtual Gamepad":
            s.quit()
        else:
        	the_stick = s
    return the_stick

# Pip's screen size is 800 x 480
screen = pygame.display.set_mode((800, 480))

# Turn off the mouse cursor
pygame.mouse.set_visible(False)

# Find Pip's gamepad
joystick = getGamepad()

# Clock for timing
clock = pygame.time.Clock()

# Initialise audio
pygame.mixer.init(44100)

# Simple ~30fps loop that repeatedly draws a black screen
done = False
while not done:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            done = True

    screen.fill("black")
    pygame.display.flip()
    clock.tick(33)

pygame.quit()
```

## Project Layout

  - `main.py` - code goes here
  - `assets/` - put images, sounds, etc. in this folder

## Further Reading

  - [Official Pygame Documentation](https://www.pygame.org/docs/)