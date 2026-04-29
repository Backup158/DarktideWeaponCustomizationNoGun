local mod = get_mod("extended_weapon_customization_no_gun")

-- Global Localization strings for EWC
mod:add_global_localize_strings({
	loc_ewc_extended_weapon_customization_no_gun = {
		en = "Hidden While Aiming",
	},
	-- Attachment Slots
	attachment_slot_aim_style = {
		en = "Aiming Style",
	},
	-- Attachment Group Label
	loc_ewc_group_hwa_aim_style = {
		en = "Hidden While Aiming",
	},
	-- Attachments
	loc_ewc_hwa_aim_style_default = {
		en = "Default",
	},
	loc_ewc_hwa_aim_style = {
		en = "Hidden Viewmodel",
	},
	loc_ewc_hwa_aim_style_left = {
		en = "Hidden Viewmodel (Left)",
	},
	loc_ewc_hwa_aim_style_right = {
		en = "Hidden Viewmodel (Right)",
	},
})

local localizations = {
	mod_name = {
		en = "EWC - Hidden While Aiming"
	},
	mod_description = {
		en = "Extended Weapon Customization plugin that adds sights to hide the gun when aiming down sights",
	},
	mod_version_print_message = {
		-- This appears after version number: v1.0.0 loaded uwu nya :3
		en = " loaded uwu nya :3",
	},
    enable_debug_mode = {
		en = "Debug Mode",
	},
	enable_debug_mode_description = {
		en = "Enables verbose logging for attachment injection",
	},
	warning_widgets = {
		en = "Show Warnings"
	},
	show_warning_remap = {
		en = "Crosshair Remap Warning",
	},
	show_warning_remap_description = {
		en = "On game start, check if user has Crosshair Remap. Warns user if not.",
	},
	warning_remap = {
		en = "You do not have Crosshair Remap installed/enabled! Without it, aiming with hidden viewmodels will NOT have a crosshair. If you're ok with that and don't want to see this warning, disable this warning by toggling 'Crosshair Remap Warning' in this mod's settings.\nAlternatively, type '/ack_remap' in game chat."
	},
	ack_remap_description = {
		en = "Disables settings warning for missing Crosshair Remap."
	},
	mod_error_old_wc = {
		en = "weapon_customization is deprecated. Remove it.",
	},
	mod_error_missing_ewc = {
		en = "Extended Weapon Customization mod is required",
	},
	mod_info_crosshair_remap = {
		en = "User has Crosshair Remap uwu nya :3",
	},
}

return localizations