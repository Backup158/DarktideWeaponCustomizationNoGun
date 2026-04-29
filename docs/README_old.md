This plugin adds attachments to [Extended Weapon Customization](https://www.nexusmods.com/warhammer40kdarktide/mods/277) (EWC) to hide the viewmodel while using the secondary action. The intent is to use this with [Crosshair Remap (Continued)](https://www.nexusmods.com/warhammer40kdarktide/mods/253) to have a clear view while aiming. We don't have r_drawviewmodel 0 in Darktide, so this will have to do.
> [!WARNING]
> By default, EWC hides crosshairs and laser pointers while aiming. Be sure to unhide them in the mod options menu if you want to be able to aim using crosshairs/lasers.

There are two types of sights: the main sight and the sight_2 helper.
- The main sight is equippable in the first "Sight" slot. It should work with every combination of attachment, but will make the actual sight invisible even when not aiming.

- The sight_2 helper is equippable in the second "Sight" slot. The helper is invisible and lets the main sight you chose stay visible when not aiming, while still hiding the entire gun when aiming.

   - Variants: Left, Middle, and Right

   - Affects where the bullet/laser tracers come from. See screenshots for details

   - It works with most sights as long as you follow the load order, with few exception. Notably, it doesn't work with Syn's
Aquilon/Kasrkin scopes (because they already use the sight_2 slot). I only tested out like 10 weapon/sight combinations so let me know if a specific combination breaks, include a screenshot of the customization page options too.

As of v1.1, this mod includes a settings checker. As stated above in the note with big red letters, certain settings may cause this mod to not function as expected. The mod will check if those offending settings are present and will prompt you to handle the problem. I have included chat commands to disable these warnings for those don't want to dig through the Mod Options menu.

# How to Use

Because this counts as an attachment for EWC, you'll need to equip it on each gun that you want hidden.
<details>
  <summary>EWC Guide</summary>
  1. Open the customization menu for the weapon, then go to the EWC tab
  
  2. Go to the second 'sight' attachment slot. 
  
  3. Select the version you want.
  
  4. Click Equip on the bottom right.
  Images can be found on nexus page.
</details>

Note that equipping it on one gun will only hide that specific gun, not every gun of the family.

Say I have 3 Recon Lasguns, a Mk VIc and two Mk XIIs. If I equip the hidden viewmodel on one of the Mk XIIs, it will only hide that one; the other XII and the VIc are unaffected. To hide it for them too, I'd have to go through this process to equip the hidden viewmodel attachment for each of them.

# Load Order
This mod needs to go AFTER the main plugin, which is the only hard requirement.

It goes BEFORE Syn's Edits and the MT Plugin, if you use those.

For any other hypothetical plugins that add sights, this should be compatible if you put this above them as well.
```
weapon_customization
weapon_customization_no_gun
weapon_customization_syn_edits
weapon_customization_mt_stuff
```
Its position in relation to Crosshair Remap doesn't matter. I have this above that, in case that helps.

# Technical Details
Not necessary to read this in order to use the mod. It's here just for those who are curious.
<details>
  <summary>Nerd Discussion</summary>
  When making parts for EWC plugins, there's an option that affects the offset from aiming down sights. Normally, you use this to align the crosshair with the center of a custom scope you've made. This plugin instead just pushes the gun way behind you until you can't see it. If you have some unholy FOV that makes it not work (or just want to mess around with it), open <DarktideMods>/weapon_customization_no_gun/scripts/mods/weapon_customization_no_gun/weapon_customization_no_gun.lua and search for Scope Offset; the relevant alignment sections are down there.

The reason this needs to load before any other EWC plugins is so the injected fixes can apply before another plugin tries to use its own scope offset. Once a slot is modified by fixes, another attachment's fixes won't change it. Since most custom scopes need aligning, that would prevent this plugin from moving the weapon behind you (if it was loaded later). That's why it works best when loaded before any other plugins that add sights.

The reason this needs to load before Syn's Edits and the MT Plugin specifically is because it shares attachment slots with them. Some wibbly wobbly timey wimey stuff with how that's implemented under the hood. Putting this below them tends to make the sight_2 options disappear (the ones from the other mods).
</details>

# FAQ
**Why are there no crosshairs when aiming?**

1. This mod does not come with that. You need to install Crosshair Remap (Continued) for this feature.
2. By default, EWC hides crosshairs and laser pointers while aiming. Be sure to disable it in the mod options menu, if you want to be able to
aim using crosshairs/lasers.﻿

**AAAAAAAAH A BUNCH OF ERRORS POPPED UP WHEN I STARTED THE GAME!!!!**

Make sure you put this above the MT plugin

**This mod gave me a backend error!**

~~Oh I'll handle your bac~~ You're missing a requirement for EWC

**This doesn't work with xyz scope!**

Tell me which one (include a picture of the customization menu's options) and I'll see what I can do

**Why are you ignoring me?**

~~I posted this right before I went out of town, like a very responsible author :3 I shall return~~

I never returned from that trip.


**What's that other scope in the screenshots?**

EWC Plugin I may or may not ever finish

**Can you make a version that doesn't require EWC?**

That's above my pay grade.

**Why are you like this?**


Next question

**I saw a mudcrab the other day.**

Horrible creatures 
