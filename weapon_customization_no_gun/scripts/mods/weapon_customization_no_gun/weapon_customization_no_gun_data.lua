local mod = get_mod("weapon_customization_no_gun")

return {
	name = "Weapon Customization - No Viewmodel",
	description = mod:localize("mod_description"),
	is_togglable = true,
    options = {
		widgets = {
			{
				setting_id = "enable_debug_mode",
				type = "checkbox",
				default_value = false,
			},
			{
				setting_id = "warning_widgets",
				type = "group",
				sub_widgets = {
					{
						setting_id = "show_warning_crosshair",
						type = "checkbox",
						default_value = true,
					},
					{
						setting_id = "show_warning_laser",
						type = "checkbox",
						default_value = true,
					},
				},
			},
		}
	}
}
