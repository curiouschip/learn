---
title: Configuring WiFi
weight: 2
bookToc: false
---

# Please follow the guide below to configure Pip's WiFi settings

---

## Manual Configuration

We are in the process of working on a **SETTINGS** app that will allow you to configure Pip's WiFi settings using the touchscreen. This will be sent in a future update to PipOS when complete. In the meantime, the WiFi settings must be configured manually.

## Method 1 - Automatic file generator

Pip's Wifi configuration is stored in a file called "wpa_supplicant.conf". Enter the name of your network and password into the boxes below and click on "Generate File".

## Method 2 - Make your own file

You can also make your own wpa_supplicant file using any text editor. Copy the code below into a new file and save it as "wpa_supplicant.cont".


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


1. Remansit notam Stygia feroxque
2. Et dabit materna
3. Vipereas Phrygiaeque umbram sollicito cruore conlucere suus
4. Quarum Elis corniger
5. Nec ieiunia dixit

Vertitur mos ortu ramosam contudit dumque; placabat ac lumen. Coniunx Amoris
spatium poenamque cavernis Thebae Pleiadasque ponunt, rapiare cum quae parum
nimium rima.

