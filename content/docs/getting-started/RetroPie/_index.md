---
title: RetroPie
weight: 4
bookToc: false
---

# Retropie

---

RetroPie allows you to turn Pip into a retro-gaming machine. Play all the old arcade, home-console and PC classics on Pip. 

{{< figure src="RetroPip.png" >}}

---

## Downloading Retropie

Without a few tweaks, the stock RetroPie image won't run on Pip. You can download the Pip friendly version of RetroPie below.

 **[Download RetroPie for Pip](https://pip-releases.fra1.digitaloceanspaces.com/retropie/retropie-pip_retropie-4.7.1_kernel-5.4.83-gcc-8.3.0.img.zip)**. 

 ---
 
## Burning a RetroPie Card

Once you have downloaded RetroPie, you need to flash the image onto a **new MicroSD card**. The easiest way to do this is to use a program like **[Balena Etcher](https://www.balena.io/etcher/)** 

{{< hint info >}}
1. Insert a **NEW** MicroSD card into your computer/laptop using a suitable adapter (**Do not write over your PipOS card**)
2. Launch Balena Etcher, click the **Flash from file** button and select the downloaded RetroPie image.
3. Select the Target Drive (the new MicroSD card you just inserted).
4. Click the **Flash!** button to flash the image.
5. Once the process is complete, copy the wpa_supplicant.conf file (containing your WiFi details) to the boot partition of the newly flashed card. You can use the [wpa_supplicant.conf Generator](/docs/tools/wpa_supplicant) if needed.
6. Safely eject the card and insert into Pip.
{{< /hint >}}

Once booted, you will see the main RetroPie home screen.

{{< figure src="RPiConfig.png" >}}

---

## Button Functions

You can configure Pip's buttons any way you want in RetroPie. The default configuration is shown below.

{{< figure src="RPiButtons.png" >}}

---

## Installing Games/ROMS

ROMs are digital versions of game cartridges and loading up a ROM in an emulator is the equivalent of putting a cartridge in a game console. The instructions below are for uploading your own ROMs to Pip.

Before you start, you need to know Pip's IP address. IP addresses can change between reboots, so it's always good to double check it before proceeding. You can find the IP address by highlighting the **RetroPie Configuration** option (shown in image above) and pressing the **A BUTTON** to select. This will take you to the configuration menu, where you can access various settings. Select the **SHOW IP** option to see the IP address.

{{< figure src="RPiIP.png" >}}

You can now install Games using scp - either via the command line, or a suitable FTP client. If you don't already have an FTP client installed, **WinSCP** is a good option for windows and **Filezilla** is a good option for a Mac. Use the settings below to connect to Pip:

{{< hint info >}}
**File Protocol:** SFTP

**Host Name:** Pip's IP address (e.g. 192.168.0.12)

**Username:** pi

**Password:** raspberry

**Port Number:** 22
{{< /hint >}}

Once connected, do the following:

1. Double click on the **RetroPie** folder
2. Double click on the **roms** folder
3. Double click on the folder that corresponds to the emulator you are installing the game for
4. Drag and drop the ROM into that folder
5. Restart RetroPie and select the emulator to see the installed games

{{< hint warning >}}
ROMs **MUST** be installed in the correct emulation folder for the games to work.
{{< /hint >}}
{{< hint danger >}}
ROMs are copyrighted content and as such are not included with RetroPie.
{{< /hint >}}

---

## Shutting Down

To shut down Pip safely, press the **Main Menu** button on the controller to access the main menu. Select **QUIT** and follow the on screen prompts to shut down Pip.

You can now install Games using scp - either via the command line, or a suitable FTP client. If you don't already have an FTP client installed, **WinSCP** is a good option for windows and **Filezilla** is a good option for a Mac. Use the settings below to connect to Pip: