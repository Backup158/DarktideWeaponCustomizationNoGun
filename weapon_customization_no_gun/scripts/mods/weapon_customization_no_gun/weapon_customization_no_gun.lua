local mod = get_mod("weapon_customization_no_gun")
mod.version = "1.2.2"

-- Variables from the EWC Template
local table = table
local ipairs = ipairs
local pairs = pairs
local vector3_box = Vector3Box

local _item = "content/items/weapons/player"
local _item_ranged = _item.."/ranged"
local _item_melee = _item.."/melee"
local _item_minion = "content/items/weapons/minions"
-- End EWC Template vars

-- Prepend function from EWC Template
table.prepend = function(t1, t2)
    for i, d in ipairs(t2) do
        table.insert(t1, i, d)
    end
end

-- Returns names of ranged weapons
function mod.get_weapons()
    return {
		"autogun_p1_m1", -- Infantry/Braced/Vigilant
		"autopistol_p1_m1",
        "bolter_p1_m1",
        "boltpistol_p1_m1",
		"lasgun_p1_m1", -- Infantry
        "lasgun_p2_m1", -- Helbore
        "lasgun_p3_m1", -- Recon
		"laspistol_p1_m1",
		"plasmagun_p1_m1",
		"shotgun_p1_m1", -- Combat
		"shotgun_p2_m1", -- Double Barrel
        "stubrevolver_p1_m1",
	}
end

-- Commands to disable warnings
local command_acr = mod:localize("ack_remap_description")
local command_acd = mod:localize("ack_crosshair_description")
local command_acl = mod:localize("ack_laser_description")
mod:command("ack_remap", command_acr, function ()
    mod:set("show_warning_remap", false, false)
end)
mod:command("ack_crosshair", command_acd, function ()
    mod:set("show_warning_crosshair", false, false)
end)
mod:command("ack_laser", command_acl, function ()
    mod:set("show_warning_laser", false, false)
end)

-- Function Execution
function mod.on_all_mods_loaded()
    mod:info("WeaponCustomizationNoGun v" .. mod.version .. " loaded uwu nya :3")

    -- Checks for other mods loaded
    local wc = get_mod("weapon_customization")
    if not wc then
		mod:error("Extended Weapon Customization mod is required")
		return
	end
    local mt = get_mod("weapon_customization_mt_stuff")
    if mt then
        mod:info("User has MT Plugin uwu nya :3")
    end
    local syn = get_mod("weapon_customization_syn_edits")
    if syn then
        mod:info("User has Syn Edits uwu nya :3")
    end
    local owo = get_mod("weapon_customization_owo")
    if owo then
        mod:info("User has Ostracized without Objection uwu nya :3")
    end
    local cr = get_mod("crosshair_remap")
    if cr then
        mod:info("User has Crosshair Remap uwu nya :3")
    end

    -- Warns users if settings are misconfigured
    --  These are all checkboxes, so returned values are bool
    local ewcDeactivateCrosshair = wc:get("mod_option_deactivate_crosshair_aiming")
    local ewcDeactivateLaser = wc:get("mod_option_deactivate_laser_aiming")
    local showWarningRemap = mod:get("show_warning_remap")
    local showWarningCrosshair = mod:get("show_warning_crosshair")
    local showWarningLaser = mod:get("show_warning_laser")

    if showWarningRemap and not cr then
        mod:echo_localized("warning_remap")
    end
    if showWarningCrosshair and cr and ewcDeactivateCrosshair then
        mod:echo_localized("warning_crosshair")
    end
    if showWarningLaser and ewcDeactivateLaser then
        mod:echo_localized("warning_laser")
    end

    -- Initializing data before injection
    local debug = mod:get("enable_debug_mode")
    local weaponClasses = mod:get_weapons()
    
    -- ####################################################################
    -- CREATING THE ATTACHMENT SLOTS
    --  If the weapon doesn't already have sight_2 assigned to it, create the slot so attachments can be injected to them
    --  
    -- ####################################################################
    if not owo then
        -- Compatibility patch: These slots are already added to these weapons by the MT plugin because of the helper sights
        --      Creating them again would make the MT plugin's attachments in this slot unusable
        if not mt then
            wc.attachment.autogun_p1_m1.sight_2 = {}
            wc.attachment.lasgun_p1_m1.sight_2 = {}
            wc.attachment.lasgun_p2_m1.sight_2 = {}
            wc.attachment.lasgun_p3_m1.sight_2 = {}
            wc.attachment.shotgun_p2_m1.sight_2 = {}
            wc.attachment.stubrevolver_p1_m1.sight_2 = {}
            -- These 3 are in the plugin but they have a space before them for whatever reason. As of v10.24, this seems to add them fine, but I'll leave these segregated in case that becomes an issue
            wc.attachment.bolter_p1_m1.sight_2 = {}
            wc.attachment.boltpistol_p1_m1.sight_2 = {}
            wc.attachment.laspistol_p1_m1.sight_2 = {}
        end
        -- Patch for Syn
        if not syn then
            wc.attachment.shotgun_p1_m1.sight_2 = {}
        end
        wc.attachment.autopistol_p1_m1.sight_2 = {}
        wc.attachment.plasmagun_p1_m1.sight_2 = {}
    end

    -- ####################################################################
    -- ATTACHMENT INJECTION
    -- See the EWC Template plugin (pinned in the Darktide Modder's Discord EWC Channel) for details
    -- ####################################################################
    -- Loops over all ranged weapons
    for _, weaponClass in ipairs(weaponClasses) do
        -- ########################################
        -- Inject attachment definition
        -- ########################################
        if debug then
            if (type(wc.attachment[weaponClass].sight_2) == "table") then
                mod:info("Correct table found: wc.attachment."..weaponClass..".sight_2")
            else
                mod:error("!!! Could not find table: wc.attachment."..weaponClass..".sight_2")
            end
        end
        -- If this plugin is the one creating the sight_2 slot, there must be a default sight_2 that doesn't have the hidden viewmodel
        local firstTime = false
        if (weaponClass == "plasmagun_p1_m1") then
            firstTime = true
            if debug then
                mod:info("First time for: wc.attachment."..weaponClass..".sight_2")
            end
        elseif not owo and (weaponClass == "autopistol_p1_m1") then
            firstTime = true
            if debug then
                mod:info("First time (no owo): wc.attachment."..weaponClass..".sight_2")
            end
        end
        elseif not owo and not syn and (weaponClass == "shotgun_p1_m1") then
            firstTime = true
            if debug then
                mod:info("First time (no syn nor owo) for: wc.attachment."..weaponClass..".sight_2")
            end
        elseif not mt and ((weaponClass == "autogun_p1_m1") or (weaponClass == "lasgun_p1_m1") or (weaponClass == "lasgun_p2_m1") or (weaponClass == "lasgun_p3_m1") or (weaponClass == "shotgun_p2_m1") or (weaponClass == "stubrevolver_p1_m1") or (weaponClass == "bolter_p1_m1") or (weaponClass == "boltpistol_p1_m1") or (weaponClass == "laspistol_p1_m1")) then
            firstTime = true
            if debug then
                mod:info("First time (no mt) for: wc.attachment."..weaponClass..".sight_2")
            end
        else
            if debug then
                mod:info("NOT the first time for: wc.attachment."..weaponClass..".sight_2")
            end
        end

        table.insert(
            wc.attachment[weaponClass].sight,
            {id = "no_gun_sight_invis_main", name = "No Viewmodel (No Sight)", no_randomize = true}
        )
        -- First time creating sight_2 for these, so I need a default unequipped
        if firstTime then
            table.insert(
                wc.attachment[weaponClass].sight_2,
                {id = "no_gun_sight_invis_default", name = "Default", no_randomize = true}
            )
        end
        table.insert(
            wc.attachment[weaponClass].sight_2,
            {id = "no_gun_sight_invis", name = "No Viewmodel", no_randomize = true}
        )
        table.insert(
            wc.attachment[weaponClass].sight_2,
            {id = "no_gun_sight_invis_right", name = "No Viewmodel (Right)", no_randomize = true}
        )
        table.insert(
            wc.attachment[weaponClass].sight_2,
            {id = "no_gun_sight_invis_left", name = "No Viewmodel (Left)", no_randomize = true}
        )
        -- ########################################
        -- Inject attachment model
        -- ########################################
        if debug then
            if (type(wc.attachment_models[weaponClass]) == "table") then
                mod:info("Correct table found: wc.attachment_models."..weaponClass)
            else
                mod:error("!!! Could not find table: wc.attachment."..weaponClass)
            end
        end
        table.merge_recursive(
            wc.attachment_models[weaponClass],
            {no_gun_sight_invis_main = {model = "", type = "sight", parent = "rail"} }
        )
        if firstTime then
            table.merge_recursive(
                wc.attachment_models[weaponClass],
                {no_gun_sight_invis_default = {model = "", type = "sight_2", parent = "sight"} }
            )
        end
        table.merge_recursive(
            wc.attachment_models[weaponClass],
            {no_gun_sight_invis = {model = "", type = "sight_2", parent = "sight"} }
        )
        table.merge_recursive(
            wc.attachment_models[weaponClass],
            {no_gun_sight_invis_right = {model = "", type = "sight_2", parent = "sight"} }
        )
        table.merge_recursive(
            wc.attachment_models[weaponClass],
            {no_gun_sight_invis_left = {model = "", type = "sight_2", parent = "sight"} }
        )
        -- ########################################
        -- Inject fixes
        -- ########################################
        -- This is where the weapons are aligned, which effects where the bullet trails come from
        --  Scope Offset Position +/-: right/left, forward/back, up/down
        -- -1.7 is the best compromise I've found between being low enough so crit lasers don't flashbang you and being high enough that the trails don't disappear when shooting at angles below head level
        --      For autoguns, the max recoil can make it so the bullets come from above the screen. But it's fine in the first half the magdump
        -- -30 puts the gun behind. Putting it too far will make trails disappear
        -- ########################################
        table.prepend(
            wc.anchors[weaponClass].fixes, {
                {   dependencies = {"no_gun_sight_invis_main"},
                    no_scope_offset =       { position = vector3_box(0, -30, -1.7), rotation = vector3_box(0, 0, 0) },
                },
            }
        )
        if firstTime then
            table.prepend(
                wc.anchors[weaponClass].fixes, {
                    {   dependencies = {"no_gun_sight_invis_default"},
                        no_scope_offset =       { position = vector3_box(0, 0, 0.0), rotation = vector3_box(0, 0, 0) },
                        scope_offset =          { position = vector3_box(0, 0, 0.0), rotation = vector3_box(0, 0, 0) },
                    },
                }
            )
        end
        table.prepend(
            wc.anchors[weaponClass].fixes, {
                {   dependencies = {"no_gun_sight_invis"},
                    no_scope_offset =       { position = vector3_box(0, -30, -1.7), rotation = vector3_box(0, 0, 0) },
                    scope_offset =          { position = vector3_box(0, -30, -1.7), rotation = vector3_box(0, 0, 0) },
                },
            }
        )
        table.prepend(
            wc.anchors[weaponClass].fixes, {
                {   dependencies = {"no_gun_sight_invis_right"},
                    no_scope_offset =       { position = vector3_box(1, -20, -1.7), rotation = vector3_box(0, 0, 0) },
                    scope_offset =          { position = vector3_box(1, -20, -1.7), rotation = vector3_box(0, 0, 0) },
                },
            }
        )
        table.prepend(
            wc.anchors[weaponClass].fixes, {
                {   dependencies = {"no_gun_sight_invis_left"},
                    no_scope_offset =       { position = vector3_box(-1, -20, -1.7), rotation = vector3_box(0, 0, 0) },
                    scope_offset =          { position = vector3_box(-1, -20, -1.7), rotation = vector3_box(0, 0, 0) },
                },
            }
        )
        -- ########################################
        -- Inject attachment
        -- ########################################
        table.insert(
            wc.sights,
            "no_gun_sight_invis_main"
        )
        table.insert(
            wc.reflex_sights,
            "no_gun_sight_invis"
        )
        table.insert(
            wc.reflex_sights,
            "no_gun_sight_invis_right"
        )
        table.insert(
            wc.reflex_sights,
            "no_gun_sight_invis_left"
        )
    end

end
