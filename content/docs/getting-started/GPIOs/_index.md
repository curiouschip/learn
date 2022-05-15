---
title: GPIOs
weight: 6
bookToc: false
---

# GPIOs

---

## Introduction

Pip's 40 pin GPIO header allows a range of sensors, motors, LEDs and accessories to be connected to Pip.

{{< figure src="GPIO1.png" >}}

It is Raspberry Pi Compatible, meaning that the majority of Raspberry Pi HATs can be connected to Pip. 

---

## What is a GPIO?

GPIO is short for General-Purpose Input/Output and these pins can be set to either input or output signals to control a range of electronic accessories.

The header provides 17 Pins that can be configured as inputs and outputs. By default they are all configured as inputs and can be controlled from programs you write in Python or other languages.

{{< figure src="GPIO2.png" >}}

{{< hint danger >}}
Do not start connecting wires and sensors to these pins without properly understanding how they work. A short circuit or wiring mistake can permanently damage affected pins.
{{< /hint >}}


---

## Flashing an LED

Need a basic example of how to flash an LED here