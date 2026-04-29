local mod = get_mod("extended_weapon_customization_no_gun")

-- ####################################
-- DATA
-- ####################################
mod.version = "1.0.0"
mod:info("v" .. mod.version .. mod:localize("mod_version_print_message"))
local debug = mod:get("enable_debug_mode")

-- ##################
-- Performance
-- ##################
local table = table
local table_insert = table.insert
local table_merge_recursive = table.merge_recursive
local string = string
local string_sub = string.sub
local string_gsub = string.gsub
local pairs = pairs
local vector3_box = Vector3Box

-- ##################
-- Requires
-- ##################
-- List of weapons from game code
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")

-- ##################
-- Game Content Addresses
-- ##################
local _item = "content/items/weapons/player"
local _item_ranged = _item.."/ranged"
local _item_melee = _item.."/melee"
local _empty_item = "content/items/weapons/player/trinkets/unused_trinket"
local _item_empty_trinket = _item.."/trinkets/unused_trinket"

-- ##################
-- Plugin Data
-- ##################
-- Plugin Skeleton to add to
local attachments_table_for_ewc = {
    attachments = {},
    attachment_slots = {},
    fixes = {},
    kitbashs = {},
}
-- Returns names of ranged weapons
local ranged_weapons = {
    human = {
        "autogun_p1_m1", -- Infantry
        "autogun_p2_m1", -- Braced
        "autogun_p3_m1", -- Vigilant
        "autopistol_p1_m1",
        "bolter_p1_m1",
        "boltpistol_p1_m1",
        "flamer_p1_m1",
        "lasgun_p1_m1", -- Infantry
        "lasgun_p2_m1", -- Helbore
        "lasgun_p3_m1", -- Recon
        "laspistol_p1_m1",
        "plasmagun_p1_m1",
        "shotgun_p1_m1", -- Combat
        "shotgun_p2_m1", -- Double Barrel
        "shotgun_p4_m1", -- Exterminator
        "shotpistol_shield_p1_m1",
        "stubrevolver_p1_m1",
    },
    ogryn = {
        "ogryn_gauntlet_p1_m1",
        "ogryn_heavystubber_p1_m1", -- Twink
        "ogryn_heavystubber_p2_m1", -- Single
        "ogryn_rippergun_p1_m1",
        "ogryn_thumper_p1_m1", -- Kickback and Rumbler
    },
}
local icon_render_unit_rotation_offset_val = {90, 0, 30}
local icon_render_camera_position_offset_val = {-0.2, -1.75, 0.15}

-- ####################################
-- Helper Functions
-- ####################################
-- Prepend function from EWC Template
local table_prepend = function(t1, t2)
    for i, d in ipairs(t2) do
        table_insert(t1, i, d)
    end
end

local function info_if_debug(message)
    if debug then mod:info(message) end
end

-- ######
-- String is key in table?
-- RETURN: boolean; was the key found?
-- ######
local function string_is_key_in_table(string_to_find, table_to_search)
    if table_to_search[string_to_find] then
        return true
    else
        -- Checks if key is in table but is false
        for key, _ in pairs(table_to_search) do
            if string_to_find == key then
                return true
            end
        end
        return false
    end
end

-- ####################################
-- Attachment Creation
-- ####################################
-- ##################
-- Templates
-- ##################
local names_of_hwa_aim_styles = {"hwa_aim_style_default", "hwa_aim_style", "hwa_aim_style_left", "hwa_aim_style_right" }
local aim_style_slot_name = "aim_style"
local attachments_add_blob = {
    attachments = {
        -- filled out in loop below
    },
    fixes = {
        human = {
            {   attachment_slot = "sight_offset",
                requirements = {
                    aim_style = {
                        has = "hwa_aim_style",
                    },
                },
                fix = {
                    offset = {
                        position = vector3_box(0, -30, -1.7),
                        rotation = vector3_box(0, 0, 0),
                    },
                },
            },
            {   attachment_slot = "sight_offset",
                requirements = {
                    aim_style = {
                        has = "hwa_aim_style_left",
                    },
                },
                fix = {
                    offset = {
                        position = vector3_box(-1, -20, -1.7),
                        rotation = vector3_box(0, 0, 0),
                    },
                },
            },
            {   attachment_slot = "sight_offset",
                requirements = {
                    aim_style = {
                        has = "hwa_aim_style_right",
                    },
                },
                fix = {
                    offset = {
                        position = vector3_box(1, -20, -1.7),
                        rotation = vector3_box(0, 0, 0),
                    },
                },
            },
        },
        ogryn = {
            {   attachment_slot = "sight_offset",
                requirements = {
                    aim_style = {
                        has = "hwa_aim_style",
                    },
                },
                fix = {
                    offset = {
                        position = vector3_box(0, -30, -1.7),
                        rotation = vector3_box(0, 0, 0),
                    },
                },
            },
            {   attachment_slot = "sight_offset",
                requirements = {
                    aim_style = {
                        has = "hwa_aim_style_left",
                    },
                },
                fix = {
                    offset = {
                        position = vector3_box(-1, -20, -1.7),
                        rotation = vector3_box(0, 0, 0),
                    },
                },
            },
            {   attachment_slot = "sight_offset",
                requirements = {
                    aim_style = {
                        has = "hwa_aim_style_right",
                    },
                },
                fix = {
                    offset = {
                        position = vector3_box(1, -20, -1.7),
                        rotation = vector3_box(0, 0, 0),
                    },
                },
            },
        },
    },
    -- kitbashes added directly in loop below
}
for i = 1, #names_of_hwa_aim_styles do
    local attachment_name = names_of_hwa_aim_styles[i]
    local full_address_of_attachment = _item_ranged.."/"..aim_style_slot_name.."/"..attachment_name
    -- Adding attachment data
    attachments_add_blob.attachments[attachment_name] = {
            replacement_path = full_address_of_attachment,
            icon_render_unit_rotation_offset = icon_render_unit_rotation_offset_val,
            icon_render_camera_position_offset = icon_render_camera_position_offset_val,
            custom_selection_group = "group_hwa_aim_style",
    }
    -- Adding kitbash data (directly)
    attachments_table_for_ewc.kitbashs[full_address_of_attachment] = {
        is_fallback_item = false,
        show_in_1p = true,
        only_show_in_1p = false,
        base_unit = _empty_item,
        item_list_faction = "Player",
        tags = {},
        workflow_checklist = {},
        workflow_state = "RELEASABLE",
        feature_flags = {"ROTATION_ursula"},
        -- Attach node in the unit - can be removed, in which case it will probably use node 1 of the parent slot unit
        -- attach_node = "ap_bullet_01",
        resource_dependencies = {
            -- ["content/weapons/player/ranged/rippergun_rifle/ammunition/ammunition_01/ammunition_01"] = true,
            [_empty_item] = true,
        },
        -- Attachments - This describes the structure of the item
        attachments = {
            zzz_shared_material_overrides = {
                item = "",
                children = {},
                material_overrides = {},
            },
        },
        display_name = "loc_ewc_"..attachment_name,
        name = full_address_of_attachment,
        is_full_item = true,
    }
end
-- ##################
-- Adding to Weapons
-- ##################
for breed_type, weapons_list in pairs(ranged_weapons) do
    for i = 1, #weapons_list do
        local weapon_name = weapons_list[i]
        -- Adding attachments
        --   Weapon entry in ewc table
        if not attachments_table_for_ewc.attachments[weapon_name] then attachments_table_for_ewc.attachments[weapon_name] = {} end
        --   Weapon entry's attachment slot in ewc table
        if not attachments_table_for_ewc.attachments[weapon_name][aim_style_slot_name] then attachments_table_for_ewc.attachments[weapon_name][aim_style_slot_name] = {} end
        table_merge_recursive(attachments_table_for_ewc.attachments[weapon_name][aim_style_slot_name], attachments_add_blob.attachments)
        
        -- Adding attachment slot to weapon
        if not attachments_table_for_ewc.attachment_slots[weapon_name] then attachments_table_for_ewc.attachment_slots[weapon_name] = {} end
        attachments_table_for_ewc.attachment_slots[weapon_name][aim_style_slot_name] = {
            parent_slot = "receiver",
            default_path = _item_empty_trinket,
            fix = {
                offset = {
                    position = vector3_box(0, 0, 0),
                    rotation = vector3_box(0, 0, 0),
                    scale = vector3_box(1, 1, 1),
                    node = 1,
                },
            },
        }
        
        -- Adding each fix
        if not attachments_table_for_ewc.fixes[weapon_name] then attachments_table_for_ewc.fixes[weapon_name] = {} end
        for k = 1, #(attachments_add_blob.fixes[breed_type]) do
            table_insert(attachments_table_for_ewc.fixes[weapon_name], attachments_add_blob.fixes[breed_type][k])
        end
    end
end
-- kitbashes were added directly
-- ##################
-- Copying attachments, slots, and fixes to other marks
-- ##################
info_if_debug("Copying attachments to all marks. Going through attachments_table_for_ewc...")
local first_marks_which_have_siblings = {}
-- See which weapons may need to copy over to siblings
for weapon_id, _ in pairs(attachments_table_for_ewc.attachments) do
    -- If first mark of pattern, copy to the siblings
    --  Check last two characters of the name
    --  if mark 1, copy to mk 2 and 3
    --      if they exist (checks for this are handled in that function)
    info_if_debug("\tChecking "..weapon_id)
    if (string_sub(weapon_id, -2) == "m1") then
        table_insert(first_marks_which_have_siblings, weapon_id)
    else
        mod:error("uwu [REPORT TO MOD AUTHOR] not the first mark: "..weapon_id)
    end
end
-- copies to siblings
--  Done this way because pairs() does NOT guarantee order
--  and since I'm adding to the table i'm reading, it can lead to duplicates and shuffling order
--  so somehow things can get skipped? this happened to ilas for some reason
for i = 1, #(first_marks_which_have_siblings) do
    local weapon_id_of_first_mark = first_marks_which_have_siblings[i]
    if not type(weapon_id_of_first_mark) == "string" then
        mod:error("uwu first_mark_id is not a string")
        return
    end
    info_if_debug("\tCopying attachments to siblings of "..weapon_id_of_first_mark)
    -- from 2 to 3
    for k = 2, 3 do
        local weapon_id_of_sibling = string_gsub(weapon_id_of_first_mark, "1$", tostring(k))
        if string_is_key_in_table(weapon_id_of_sibling, WeaponTemplates) then
            info_if_debug("\t\tuwu Copying to sibling: "..weapon_id_of_first_mark.." --> "..weapon_id_of_sibling)
            -- Copy Attachments
            --      If source does not exist, stop
            if not attachments_table_for_ewc.attachments[weapon_id_of_first_mark] then
                mod:error("No attachments found for "..weapon_id_of_first_mark)
                return
            end
            --      If destination doesn't exist, create it
            if not attachments_table_for_ewc.attachments[weapon_id_of_sibling] then attachments_table_for_ewc.attachments[weapon_id_of_sibling] = {} end
            table_merge_recursive(attachments_table_for_ewc.attachments[weapon_id_of_sibling], attachments_table_for_ewc.attachments[weapon_id_of_first_mark])
            -- Copy Attachment Slots
            --      If source does not exist, stop
            if not attachments_table_for_ewc.attachment_slots[weapon_id_of_first_mark] then
                info_if_debug("No attachment slots found for "..weapon_id_of_first_mark)
                return
            end
            --      If destination doesn't exist, create it
            if not attachments_table_for_ewc.attachment_slots[weapon_id_of_sibling] then attachments_table_for_ewc.attachment_slots[weapon_id_of_sibling] = {} end
            table_merge_recursive(attachments_table_for_ewc.attachment_slots[weapon_id_of_sibling], attachments_table_for_ewc.attachment_slots[weapon_id_of_first_mark])
            -- Copy Fixes
            --      If source does not exist, stop
            if not attachments_table_for_ewc.fixes[weapon_id_of_first_mark] then
                mod:info("No fixes in source: "..weapon_id_of_first_mark)
                return
            end
            --      If destination doesn't exist, create it
            if not attachments_table_for_ewc.fixes[weapon_id_of_sibling] then attachments_table_for_ewc.fixes[weapon_id_of_sibling] = {} end
            --      needs to be insert because numerical index, so merge recursive would smash fixes together
            for l = 1, #(attachments_table_for_ewc.fixes[weapon_id_of_first_mark]) do
                table_insert(attachments_table_for_ewc.fixes[weapon_id_of_sibling], attachments_table_for_ewc.fixes[weapon_id_of_first_mark][l])
            end
        else
            info_if_debug("\t\tuwu This is not a real weapon: "..weapon_id_of_sibling)
        end
    end
end
-- ##################
-- After all is done, put into global so EWC can actually use it
-- ##################
mod.extended_weapon_customization_plugin = attachments_table_for_ewc

-- ####################################
-- Hooks
-- ####################################
-- Commands to disable warnings
mod:command("ack_remap", mod:localize("ack_remap_description"), function ()
    mod:set("show_warning_remap", false, false)
end)

-- Displaying warnings to user
function mod.on_all_mods_loaded()
    -- Checks for other mods loaded
    local wc = get_mod("weapon_customization")
    if wc then
		mod:error(mod:localize("mod_error_old_wc"))
		return
	end
    local ewc = get_mod("extended_weapon_customization")
    if not ewc then
		mod:error(mod:localize("mod_error_missing_ewc"))
		return
	end
    local cr = get_mod("crosshair_remap")
    if cr then
        mod:info(mod:localize("mod_info_crosshair_remap"))
    end

    -- Warns users if settings are misconfigured
    --  These are all checkboxes, so returned values are bool
    local showWarningRemap = mod:get("show_warning_remap")
    if showWarningRemap and not cr then
        mod:echo_localized("warning_remap")
    end
end
