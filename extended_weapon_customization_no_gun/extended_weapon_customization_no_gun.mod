return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`extended_weapon_customization_no_gun` encountered an error loading the Darktide Mod Framework.")

		new_mod("extended_weapon_customization_no_gun", {
			mod_script       = "extended_weapon_customization_no_gun/scripts/mods/ewc_no_gun/ewc_no_gun",
			mod_data         = "extended_weapon_customization_no_gun/scripts/mods/ewc_no_gun/ewc_no_gun_data",
			mod_localization = "extended_weapon_customization_no_gun/scripts/mods/ewc_no_gun/ewc_no_gun_localization",
		})
	end,
	require = {
		 "extended_weapon_customization",
	},
	load_before = {
		 "extended_weapon_customization",
	},
	version = "2.0.1",
	packages = {},
}
