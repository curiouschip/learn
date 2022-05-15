---
title: Connecting to External Monitor
weight: 8
bookToc: false
---

# Connecting to External Monitor

---

## Config Files

You can only have one screen active whilst using Pip. By default, this is the built-in LCD and all the images supplied (PipOS and RetroPie) have been coded to work with the LCD.

To get Pip working with an external monitor, simply replace the confg.txt file with one that has been customised for HDMI. Download the required file below then follow the instructions below to replace the config.txt file.

[**Download HDMI config**](HDMI.zip)

[**Download LCD config**](LCD.zip)

{{< hint info >}}
1. Safely remove Pip's MicroSD card and insert it into your computer/laptop using a suitable adapter.
2. Download the **HDMI** config , or the **LCD** config file
4. Save this file to the boot partition of Pip's MicroSD card., overwriting the existing one.
5. Safely eject this card, re-insert into Pip.
6. Connect and HDMI cable to Pip and to your monitor and boot up Pip.
7. You should see Pip booting up on the external monitor and Pip's LCD will be switched off (although the backlight will be on).
{{< /hint >}}

{{< hint warning >}}
Rather than constantly switching config files, we recommend having a separate MicroSD card for LCD and HDMI modes.
{{< /hint >}}