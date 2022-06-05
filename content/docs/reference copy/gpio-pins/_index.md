---
title: GPIO Pins
---

# GPIO Pins

## Overview

Pip's pinout is designed to match that of the Raspberry Pi 3.

{{< figure src="GPIO2.png" >}}

{{< hint info >}}
Normally on a Raspberry Pi pins 0 and 1
are inaccessible as they are reserved for performing HAT identification/configuration.
Pip has no such restriction, however we recommend that for compatibility reasons you
do not use these pins and instead start from GPIO 02.
{{< /hint >}}

## PWM Support

Pip supports PWM output on the following pins:

  - `12`
  - `13`
  - `18`
  - `19`

## Comms Peripherals (I2C, SPI, UART)

Pip's firmware does not currently support comms peripheral functions on the GPIOs.
The pins in question have been assigned such that there is an equivalent peripheral
on Pip's GPIO controller, so support for these may be added in the future.