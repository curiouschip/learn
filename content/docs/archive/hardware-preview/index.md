---
title: "Hardware Preview Guide"
---

Hardware Preview Guide
======================

{{< hint warning >}}
**Archived Guide**  
This page provides information relating to the first Pip Hardware Preview devices
that were shipped towards the end of 2021. The information may be out of date.
{{< /hint >}}

Basic Operation
---------------

### Turning On

To turn on Pip, hold down the middle button for 2 seconds.

### Logging In

Once Pip has booted you will be presented with a console login screen. Connect a USB keyboard and log in using the username `pip` and the password `blueberry`.

### Turning Off

In the Hardware Preview phase Pip should be shutdown via the console by typing `sudo shutdown -h now`. After Pip's GUI has been enabled it will be possible to use the middle button to shutdown the device.

#### Emergency Shutdown

It's possible to force a shutdown by holding down the left and middle buttons for 5 seconds. This method is not recommended unless unavoidable as it works by abruptly cutting power to the Pi, leaving the possibility of filesystem corruption.

Configuring WiFi
----------------

WiFi is configured by hand-editing the WPA Supplicant configuration file. Type `sudo nano /etc/wpa_supplicant/wpa_supplicant.conf` and add a block containing the configuration details for your local network, substituting `SSID` and `PASSWORD` with the appropriate credentials:

    network={
        scan_ssid=1
        ssid="SSID"
        psk="PASSWORD"
    }

Once complete, press Ctrl-X, confirm your changes, and reboot the system by typing `sudo reboot`. When Pip reboots WiFi should connect automatically with the IP address displayed a few lines above the console login prompt.

Connecting with SSH
-------------------

Once [WiFi is configured](#configuring-wifi) you can connect to Pip using `ssh` using the same username and password.

**Note:** SSH acccess is enabled by default only during Pip's beta testing phase.

How to Use the Buttons
----------------------

Tap Pip's middle button to cycle through the special `battery`, `volume`, and `backlight` modes. When a special mode is active any user-defined LED state is temporarily overridden while the status of a system parameter is displayed:

*   In `battery` mode the LEDs use a rainbow gradient to give an indication of Pip's current charge level. When Pip is charging, the LEDs will animate.
*   In `volume` mode the cyan LEDs show Pip's current volume - use the left/right buttons to adjust.
*   In `brightness` mode the white LEDs show Pip's current backlight brightness - use the left/right buttons to adjust.

Special modes will timeout after no button has been pressed for 5 seconds and return to the standard `user` state.

Testing the Hardware
--------------------

### Accelerometer

Pip's accelemoreter is exposed via the Linux Industrial IO (IIO) subsystem; type `ls /sys/bus/iio/devices/iio\:device0` to view the available properties, then use `cat` to see the current values. For example, to read the current X/Y/Z values:

    cat /sys/bus/iio/devices/iio\:device0/in_accel_x_raw
    cat /sys/bus/iio/devices/iio\:device0/in_accel_y_raw
    cat /sys/bus/iio/devices/iio\:device0/in_accel_z_raw

### Audio

#### Playback

Audio output can be tested using the `speaker-test`:

    speaker-test -t sine -f 440 -c 1

This snippet will generate a sine wave at 440Hz (middle A) and play it until interrupted by Ctrl-C. Alternatively a WAV file can be copied onto the SD card's boot partition and be played back with `aplay`:

    aplay /boot/$WAVE_FILE

Pip will automatically switch between speaker and headphones as appropriate.

#### Recording

Use `arecord` to record sound from the built-in microphone:

    arecord -f S16_LE -r 44100 -c 2 -d 3 test.wav

The `-d 3` specifies the number of seconds to record. To play back the recording:

    aplay test.wav

### Buttons

Because Pip's top buttons are multi-functional, and these functions are managed by system software, any presses destined for userspace must be accessed through a virtual device which has all other presses filtered out. We can use evtest to see this input. First, let's install it:

    sudo apt-get install evetest

Now we can test the buttons:

    sudo evtest /dev/input/pip-virt-buttons

**Note:** the middle button will only fire an event after being depressed for 2 seconds.  
**Note:** the shoulder buttons will not trigger keyboard events while the gamepads are attached.

Press Ctrl-C to exit when done.

### Camera

Use the `raspistill` program to test the internal camera. The following snippet will overlay a live camera feed on top of the console for 5 seconds:

    raspistill -cs 0 -t 5000

### Gamepad

When Pip's controllers are connected the following three files will exist in `/dev/input`:

    pip-hw-gamepad-l
    pip-hw-gamepad-r
    pip-virt-gamepad

The first two files represent the physical controllers themselves. We're not particularly interested in these but the final file, `pip-virt-gamepad`, is a virtual device that exposes the merged controllers to Linux more usefully as a single logical device. You can test it using `evtest`:

    # Only need to run the first line if evtest isn't yet installed
    sudo apt-get install evetest
    sudo evtest /dev/input/pip-virt-gamepad

Pressing any controller buttons and a corresponding event will be observed in the console output.

**Note:** while the virtual gamepad is active Pip's shoulder buttons also become part of the gamepad, so pressing these will generate console events, too.

Once you're finished testing, press Ctrl-C to exit `evtest`.

### GPIOs

Due to pin limitations on the Raspberry Pi Compute Module 3, Pip's GPIOs are controlled by a bridging microcontroller (an Atmel SAMD21) via UART (serial) communications, so the Pi's standard `gpio` command cannot be used. Instead Pip includes a `pipio`, a command line tool for these purposes.

**Note:** `pipio` is located in `/opt/pip/bin`, a directory not currently in the `pip` user's `$PATH`. When running commands all references to `pipio` should be replaced with the full path `/opt/pip/bin/pipio`. Alternatively add `pipio` to your `$PATH` by typing `export PATH=/opt/pip/bin:$PATH`.

The named variables in the examples below are described by the following definitions:

*   `$PINS`: a comma separated list of pins or pin ranges e.g. `1`, `10,16,20`, `1-4`, `1,5,10-12,20-22,26`
*   `$MODE`: pin mode (`output`, `input`, `input_pullup`, `input_pulldown`)
*   `$LEVEL`: pin level - 0 (off) or 1 (on)
*   `$DUTY`: PWM duty cycle (0-255)

#### Simple Usage

A GPIO pin's mode determines wheter it is an output, or input with optional pull up/down. To set a pin's mode:

    # $MODE is one of output, input, input_pullup or input_pulldown
    pipio gpio mode $PINS $MODE

To set the output level of one or more pins:

    # $LEVEL is 0 for off, 1 for on
    pipio gpio write $PINS $LEVEL

To read the input level of one or more pins:

    pipio gpio read $PINS

#### PWM

Pip has 4 PWM-enabled pins: 12, 13, 18, and 19. Before PWM can be used on a pin it must be set to the `pwm` function:

    pipio func $PINS pwm

Then set the duty cycle:

    # $DUTY is the PWM duty cycle, from 0 (off) to 255 (full duty)
    pipio pwm $PINS $DUTY

To return the pin to the default `gpio` function:

    pipio func $PINS gpio

### LEDs

Pip's LEDs are controlled by the same command as the GPIOs - `pipio`. The root command is `/opt/pip/bin/pipio leds` and supported arguments are:

*   `clear` - turn off all LEDs
*   `set-all $COLOR` - set all LEDs to `$COLOR`
*   `set $INDEX $COLOR` - set LED `$INDEX` to `$COLOR`
*   `set $START-$END $COLOR` - set LEDs between `$START` and `$END` (inclusive) to `$COLOR`

`$COLOR` is a hex value like `ff0000` (note that unlike HTML there is no leading `#` symbol). `$INDEX`, `$START`, and `$END` are numbers between 0 and 7 (inclusive).

#### Examples

    # Turn off all LEDs
    /opt/pip/bin/pipio leds clear
    
    # Set LEDs 0, 1, 2 and 3 to blue
    /opt/pip/bin/pipio leds set 0-3 0000ff

### Touchscreen

Use `evtest` to view the raw touchscreen input:

    sudo evtest /dev/input/pip-touchscreen

Press Ctrl-C to exit when done.

Updating
--------

### Overview

Pip's update system makes use of a process known as "bank swapping". The SD card has space reserved for two copies of Pip's OS: banks A and B. While Pip is running a single bank will be active. To perform an update the system writes the new version to the inactive bank, updates some housekeeping data, switches the active bank, then reboots into the new system version. This is in contrast to Linux's typical approach of "rolling updates" where small system updates are applied incrementally as they become available. Banked updates were chosen for Pip because they are guaranteed to work regardless of the state of the previous version; rolling updates, while great for experienced users, can occasionally leave systems in a broken/degraded state, despite the best efforts of maintainers (this problem is compounded by the fact that Pip is based on Debian/Rasbpian so we have essentially no control over upstream changes). Banked updates ensure each OS release has it's own "clean slate", so to speak.

You may be wondering, "but what about user data?". Pip has a final fourth partition at the end of the SD card which is mounted at `/home` to ensure that users' data is preserved across system updates. Additionally the update process copies certain files between banks so that critical configuration (e.g. WiFi) is retained.

To get the current system version:

    /opt/pip/bin/pip-update version
    1.0.1

And to see information about the current bank and updater config:

    /opt/pip/bin/pip-update info
    active_bank: A
    system_root: /opt/pip
    update_stream: release
    update_url_template: https://updates.thisispip.com/updates/upgrade?stream=$stream&version=$version

### Process

To check for available updates, ensure Pip is connected to WiFi, and type:

/opt/pip/bin/pip-update check

If an update is available start the update process by typing:

sudo /opt/pip/bin/pip-update -v update

The `-v` option tells the updater to write detailed status information to the console so that you can keep track of the update's progress; updating should take about 10-20 minutes. Once the update is complete you can reboot into the updated system using the command `sudo reboot`.

Release History
---------------

### Version 1.0.1

#### Release Notes

Initial public release. Hello World!

#### Known Issues

*   DAC error message appears during boot - this is due to an issue with the Linux kernel's module load order, and rectifies itself later in the boot process. The error message can be safely ignored.
*   Gamepad is sometimes not recognised if the physical controllers are attached at boot time. This is a bug in the `sid` component and will be fixed in the next release. A simple workaround is to detach both controllers then reattach them.

Reporting Issues
----------------

Please report issues using the [pip repository issue tracker](https://github.com/curiouschip/pip/issues) on GitHub.