---
title: Coding with Pip
weight: 7
bookToc: false
---

# Coding with Pip

---

## App Menu

{{< figure src="editing1.png" >}}

Clicking on the 3 dots beside the app opens up a sub menu, which allows you to customise and edit the app. The options available are described below:

{{< hint info >}}
**Run** - This option loads and runs the app on Pip. If Pip is connected to an external monitor, this is how you would load an app as Pip's touchscreen user interface will be unavailable. Any running apps will be shown in the bottom right of the screen.

**Edit** - This option opens up the code editor in a new tab. Switch to the tab to make changes to the code.

**Rename** - Select this option if you wish to rename your app. You may need to do this if you import an app into Pip.

**Set Icon** - This option allows you to set a custom icon for your app. Icons should be 140px x 140px in size and can be in either PNG or JPG format.

**Export** - This option allows you to either backup your app to your computer, or share it with another Pip owner. The app is saved as a .zip file.

**Delete** - This option allows you to remove apps from Pip. Please note that once an app is deleted, it cannot be recovered.
{{< /hint >}}

---

## Editing an App

{{< figure src="editing2.png" >}}

---

## Editing example

We are going to make some changes to the **Space Invaders** game, which is written in the programming language **Lua**. To get started, click on the **Edit** option beside the Space Invaders app.

{{< figure src="editing3.png" >}}

We are going to give this game a retro look by changing the background and the sprites. You can use your own sprites, or download the ones used in this example by **clicking here**. 

The filenames have been kept the same to make this example easier to follow. 

{{< hint info >}}
1. We are going to edit the **main.lua** file, so click on this to open it in a new tab
2. Add a new folder to the **Root Directory** and name it **newassets**
3. Drag and drop the downloaded assets into this newly created folder
4. All we need to do is point the source of the graphics to the new directory by renaming the **assets** folder to **newassets** on lines 5, 6, 9 and 10 of the code
5. Once complete, click on **Save** in the top left corner, then on **Run** to see the results on Pip
{{< /hint >}}

{{< figure src="editing4.gif" >}}

We are also going to change some further parameters in the game:

{{< hint info >}}
1. Change the **ALIEN_SHOOT_CHANCE** value to **0.05** (to increase the number of missiles fired by the aliens)
2. Change the **ALIEN_SPEED** value to **240** (to make the aliens move faster)
3. Change the **START_LIVES** value to **8** (to double the amount of lives you start with)
4. Change the **LIFE_COLOR** value to **{40, 0, 40}** (to change the LED colours to purple)
5. Change the **PLAYER_MISSILE_SPEED** value to 600 (to increase the speed your missiles fire at)
{{< /hint >}}

{{< figure src="editing5.gif" >}}

Congratulations!. You have edited your first piece of code on Pip. Click on the links under **Project Types** to find out about the other coding languages you can use on Pip.

