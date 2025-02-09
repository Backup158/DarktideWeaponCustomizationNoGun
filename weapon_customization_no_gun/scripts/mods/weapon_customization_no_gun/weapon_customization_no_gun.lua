local mod = get_mod("weapon_customization_no_gun")
mod.version = "1.1"

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
		"laspistol_p1_m1",
		"plasmagun_p1_m1",
		"shotgun_p1_m1", -- Combat
	    "stubrevolver_p1_m1",
		"lasgun_p2_m1", -- Helbore
		"shotgun_p2_m1", -- Double Barrel
		"lasgun_p3_m1", -- Recon
	}
end

-- Commands to disable warnings
local command_acd = mod:localize("ack_crosshair_description")
local command_acl = mod:localize("ack_laser_description")
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
        mod:info("WeaponCustomizationNoGun: User has MT Plugin uwu nya :3")
    end
    local syn = get_mod("weapon_customization_syn_edits")
    if syn then
        mod:info("WeaponCustomizationNoGun: User has Syn Edits uwu nya :3")
    end
    local cr = get_mod("crosshair_remap")
    if cr then
        mod:info("WeaponCustomizationNoGun: User has Crosshair Remap uwu nya :3")
    end

    -- Warns users if settings are misconfigured
    --  These are all checkboxes, so returned values are bool
    local ewcDeactivateCrosshair = wc:get("mod_option_deactivate_crosshair_aiming")
    local ewcDeactivateLaser = wc:get("mod_option_deactivate_laser_aiming")
    local showWarningCrosshair = mod:get("show_warning_crosshair")
    local showWarningLaser = mod:get("show_warning_laser")

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
    -- Compatibility patch: These slots are already added to these weapons by the MT plugin because of the helper sights
    --      Creating them again would make the MT plugin's attachments in this slot unusable
    if not mt then
        wc.attachment.autogun_p1_m1.sight_2 = {}
        wc.attachment.lasgun_p1_m1.sight_2 = {}
        wc.attachment.lasgun_p2_m1.sight_2 = {}
        wc.attachment.lasgun_p3_m1.sight_2 = {}
        wc.attachment.shotgun_p2_m1.sight_2 = {}
        wc.attachment.stubrevolver_p1_m1.sight_2 = {}
        -- these 3 are in the plugin but they have a space before them for whatever reason
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
                mod:info("    Correct table found: wc.attachment."..weaponClass..".sight_2")
            else
                mod:error("!!! Could not find table: wc.attachment."..weaponClass..".sight_2")
            end
        end
        table.insert(
            wc.attachment[weaponClass].sight,
            {id = "no_gun_sight_invis_main", name = "No Viewmodel (No Sight)"}
        )
        table.insert(
            wc.attachment[weaponClass].sight_2,
            {id = "no_gun_sight_invis", name = "No Viewmodel"}
        )
        table.insert(
            wc.attachment[weaponClass].sight_2,
            {id = "no_gun_sight_invis_right", name = "No Viewmodel (Right)"}
        )
        table.insert(
            wc.attachment[weaponClass].sight_2,
            {id = "no_gun_sight_invis_left", name = "No Viewmodel (Left)"}
        )
        -- ########################################
        -- Inject attachment model
        -- ########################################
        if debug then
            if (type(wc.attachment_models[weaponClass]) == "table") then
                mod:info("    Correct table found: wc.attachment_models."..weaponClass)
            else
                mod:error("!!! Could not find table: wc.attachment."..weaponClass)
            end
        end
        table.merge_recursive(
            wc.attachment_models[weaponClass],
            {no_gun_sight_invis_main = {model = "", type = "sight", parent = "rail"} }
        )
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

    --[[ ATTEMPTED TO AUTOMATE THIS
        automatically adding entries just by passing a few parameters so i wouldnt have to repaste all these inserts
        this took too long that i just gave up and brute forced it (ROCK SMASH)
        really it'd just be reinventing the wheel


    -- Inject attachment definitions loop
    --  Based on base EWC, not MT
    --  []  accessing the table contents as an associative array with bracket notation. trying to find the key matching a string
    function mod.inject_attachment_definitions_base(weapon, slot, slot_table, definitions)
        for _, attachment_inject in ipairs(definitions) do
            def_id, def_name, def_model_table = attachment_inject[1][1], attachment_inject[1][2], attachment_inject[2]
            if debug then
                mod:info("injecting for "..weapon.." uwu nya")
                mod:info("    "..def_id)
                mod:info("    "..def_name)
                -- mod:info("    "..def_model_table) -- this is a table so we're not printing
            end
            -- Inject attachment definition
            if debug then
                if (type(wc.attachment[weapon][slot]) == "table") then
                    mod:info("    Correct table found: wc.attachment."..weapon.."."..slot)
                else
                    mod:error("!!! Could not find table: wc.attachment."..weapon.."."..slot)
                end
            end
            table.insert(
                wc.attachment[weapon][slot], 
                {id = def_id, name = def_name}
            )
            -- Inject attachment model
            if debug then
                if (type(wc.attachment_models[weapon]) == "table") then
                    mod:info("    Correct table found: wc.attachment_models."..weapon)
                else
                    mod:error("!!! Could not find table: wc.attachment_models."..weapon)
                end
            end
            table.merge_recursive(
                wc.attachment_models[weapon],
                def_model_table
            )
            -- Inject fixes
            table.prepend(
                wc.anchors[weapon].fixes, {
                    {   dependencies = {def_id},
                        no_scope_offset =       { position = vector3_box(0, -10, -0.7), rotation = vector3_box(0, 0, 0) },
                    },
                }      
            )
            -- Inject attachment to the actual table
            if debug then
                if (type(wc[slot_table]) == "table") then
                    mod:info("    Correct table found: wc."..slot_table)
                else
                    mod:error("!!! Could not find table: wc."..slot_table)
                end
            end
            table.insert(
                wc[slot_table],     -- inserting into sights, not just sight
                def_id
            )
            
        end
    end
    for _, weaponClass in ipairs(weaponClasses) do
        mod.inject_attachment_definitions_base(weaponClass, "sight", "sights" {
            {   {"no_gun_sight_invis", "No Viewmodel (No Sight)"}, 
                { no_gun_sight_invis = {model = "", type = "sight", parent = "rail"} } 
            },
        })
        mod.inject_attachment_definitions_base(weaponClass, "sight_2", "reflex_sights" {
            {   {"no_gun_sight2_invis", "No Viewmodel"}, 
                { no_gun_sight2_invis = {model = "", type = "sight_2", parent = "sight"} } 
            },
        })
    end
    ]]

end
