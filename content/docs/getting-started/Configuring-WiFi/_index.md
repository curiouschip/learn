---
title: Configuring WiFi
weight: 2
bookToc: false
---

# Configuring Pip's WiFi settings

---

## Manual Configuration

We are in the process of working on a **SETTINGS** app that will allow you to configure Pip's WiFi using the touchscreen. This will be part of a PipOS update. 

In the meantime, the WiFi settings must be configured manually, using either of the methods below.

## Method 1 - Automatic file generator

Pip's Wifi configuration is stored in a file called **wpa_supplicant.conf**, which can be automatically generated using our [wpa_supplicant.conf Generator](/docs/tools/wpa_supplicant).

{{< hint info >}}
1. Safely remove Pip's MicroSD card and insert it into your computer/laptop using a suitable adapter.
2. Enter your network name/password in [wpa_supplicant.conf Generator](/docs/tools/wpa_supplicant), using the Add Network button to add as many networks as required.
3. Click **Generate** to view the resulting file. 
4. Save this file to the boot partition of Pip's MicroSD card.
5. Safely eject this card, re-insert into Pip and boot up Pip.
6. Once booted, hold the **MIDDLE BUTTON** and select the **Reboot** option.
7. Pip will reboot and be assigned an IP address, which will appear in the top left corner of the screen

{{< /hint >}}



## Method 2 - Make your own file

You can also make your own **wpa_supplicant.conf** file using any text editor. Copy the code below into a new file and save it as **wpa_supplicant.conf**. Copy this file to the boot partition of Pip's MicroSD card using the procedure outlined above.


	country=us
	update_config=1
	ctrl_interface=/var/run/wpa_supplicant

	network={
 	   scan_ssid=1
 	  ssid="WIFINAME"
 	 psk="PASSWORD"
	}
	
	network={
 	   scan_ssid=1
 	  ssid="WIFINAME2"
 	 psk="PASSWORD2"
	}
