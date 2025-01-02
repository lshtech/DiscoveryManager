--- STEAMODDED HEADER
--- MOD_NAME: Reset Discovered Cards
--- MOD_ID: ResetDiscovered
--- MOD_AUTHOR: [elbe]
--- MOD_DESCRIPTION: Reset all discovered cards
--- PRIORITY: 0

----------------------------------------------
------------MOD CODE -------------------------

local createOptionsRef = create_UIBox_options
function create_UIBox_options()
    local contents = createOptionsRef()    
    if G.STAGE == G.STAGES.MAIN_MENU then
        local m = UIBox_button({
            minw = 5,
            button = "ResetDiscovered_Menu",
            label = { "Discovery Manager"},
            colour = G.C.SO_1.Clubs,
        })
        table.insert(contents.nodes[1].nodes[1].nodes[1].nodes, #contents.nodes[1].nodes[1].nodes[1].nodes + 1, m)
    end
    return contents
end

G.FUNCS.ResetDiscovered_Menu = function(e)
    local tabs = create_tabs({
        snap_to_nav = true,
        tabs = {
            {
                --label = "Reset",
                chosen = true,
                tab_definition_function = function()
                    return config_tab()
                end
            },
        }
    })
    G.FUNCS.overlay_menu{
        definition = create_UIBox_generic_options({
            back_func = "options",
            contents = {tabs}
        }),
        config = {offset = {x=0,y=10}}
    }
end

function config_tab()
    G.focused_profile = G.SETTINGS.profile
    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            minh = 6,
            r = 0.1,
            minw = 10,
            align = "cm",
            padding = 0.2,
            colour = G.C.BLACK
        },
        nodes = {
            UIBox_button({label = {"Unlock/Discover All"}, button = "unlock_all", colour = G.C.ORANGE, minw = 5, minh = 0.7, scale = 0.6}),
            UIBox_button({label = {"Reset"}, button = "undiscover_all", colour = G.C.ORANGE, minw = 5, minh = 0.7, scale = 0.6}),
            UIBox_button({label = {"Clear Alerts"}, button = "clear_all", colour = G.C.ORANGE, minw = 5, minh = 0.7, scale = 0.6}),
        },
    }
end

local SMODS_Joker_inject=SMODS.Joker.inject
SMODS.Joker.inject =function(self)
    self.discovered = false
    SMODS_Joker_inject(self)
end

local SMODS_Consumable_inject=SMODS.Consumable.inject
SMODS.Consumable.inject =function(self)
    if self.set ~= "Ability" then
        self.discovered = false
    end
    SMODS_Consumable_inject(self)
end

local SMODS_Tag_inject=SMODS.Tag.inject
SMODS.Tag.inject =function(self)
    self.discovered = false
    SMODS_Tag_inject(self)
end

local SMODS_Voucher_inject=SMODS.Voucher.inject
SMODS.Voucher.inject =function(self)
    self.discovered = false
    SMODS_Voucher_inject(self)
end

local SMODS_Edition_inject=SMODS.Edition.inject
SMODS.Edition.inject =function(self)
    self.discovered = false
    SMODS_Edition_inject(self)
end

local SMODS_Booster_inject=SMODS.Booster.inject
SMODS.Booster.inject =function(self)
    self.discovered = false
    SMODS_Booster_inject(self)
end

local SMODS_Blind_inject=SMODS.Blind.inject
SMODS.Blind.inject =function(self, i)
    self.discovered = false
    SMODS_Blind_inject(self, i)
end

local SMODS_UndiscoveredSprite_inject=SMODS.UndiscoveredSprite.inject
SMODS.UndiscoveredSprite.inject =function(self)
    if self.mod then
        if self.mod.prefix then
            if not string.find(tostring(self.atlas), tostring(self.mod.prefix .. "_")) then
                print("updating atlas to " .. self.mod.prefix .. "_" .. self.atlas)
                self.atlas = self.mod.prefix .. "_" .. self.atlas
            end
        end
    end
    SMODS_UndiscoveredSprite_inject(self)
end

local SMODS_ConsumableType_inject=SMODS.ConsumableType.inject
SMODS.ConsumableType.inject = function(self)
    if self.loc_txt and (not self.loc_txt.undiscovered or self.loc_txt.undiscovered.text[1] ==  'idk stuff ig') then
        self.loc_txt.undiscovered = {
            name = 'Undiscovered',
            text = { 'discover this card', 'to discover' },
        }
    end
    SMODS_ConsumableType_inject(self)
end

if CardSleeves then
    local CardSleeves_Sleeve_inject=CardSleeves.Sleeve.inject
    CardSleeves.Sleeve.inject = function(self)
        if self.unlocked ~= nil and self.unlocked == false and self.unlock_condition and self.unlock_condition.deck then
            if SMODS.Decks[self.unlock_condition.deck] then
                CardSleeves_Sleeve_inject(self)
                return
            end
        end
        if self.key == "sleeve_mpd_frontier_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_mpd_b_frontier", stake = 3 }
        elseif self.key == "sleeve_mpd_grocery_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_mpd_b_grocery", stake = 3 }
        elseif self.key == "sleeve_mf_grosmichel" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_mf_grosmichel", stake = 3 }
        elseif self.key == "sleeve_mf_philosophical" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_mf_philosophical", stake = 3 }
        elseif self.key == "sleeve_mf_rainbow" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_mf_rainbow", stake = 3 }
        elseif self.key == "sleeve_mf_blasphemy" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_mf_blasphemy", stake = 3 }
        elseif self.key == "sleeve_Themed_AcesSleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_Themed_CombatAceDeck", stake = 3 }
        elseif self.key == "sleeve_Themed_CosmicSleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_Themed_CosmisDeck", stake = 3 }
        elseif self.key == "sleeve_Themed_MischievousSleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_Themed_MischievousDeck", stake = 3 }
        elseif self.key == "sleeve_fam_amythestsleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_fam_amethyst_deck", stake = 3 }
        elseif self.key == "sleeve_fam_rubysleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_fam_ruby_deck", stake = 3 }
        elseif self.key == "sleeve_fam_silversleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_fam_silver_deck", stake = 3 }
        elseif self.key == "sleeve_fam_topazsleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_fam_topaz_deck", stake = 3 }
        elseif self.key == "sleeve_sdm_0_s" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_sdm_0_s", stake = 3 }
        elseif self.key == "sleeve_sdm_bazaar" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_sdm_bazaar", stake = 3 }
        elseif self.key == "sleeve_sdm_sandbox" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_sdm_sandbox", stake = 3 }
        elseif self.key == "sleeve_sdm_lucky_7" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_sdm_lucky_7", stake = 3 }
        elseif self.key == "sleeve_sdm_dna" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_sdm_dna", stake = 3 }
        elseif self.key == "sleeve_sdm_hieroglyph" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_sdm_hieroglyph", stake = 3 }
        elseif self.key == "sleeve_sdm_xxl" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_sdm_xxl", stake = 3 }
        elseif self.key == "sleeve_sdm_hoarder" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_sdm_hoarder", stake = 3 }
        elseif self.key == "sleeve_cry_encoded_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_antimatter", stake = 3 }
        elseif self.key == "sleeve_cry_equilibrium_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_equilibrium", stake = 3 }
        elseif self.key == "sleeve_cry_misprint_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_misprint", stake = 3 }
        elseif self.key == "sleeve_cry_infinite_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_infinite", stake = 3 }
        elseif self.key == "sleeve_cry_conveyor_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_conveyor", stake = 3 }
        elseif self.key == "sleeve_cry_ccd_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_CCD", stake = 3 }
        elseif self.key == "sleeve_cry_wormhole_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_wormhole", stake = 3 }
        elseif self.key == "sleeve_cry_redeemed_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_redeemed", stake = 3 }
        elseif self.key == "sleeve_cry_critical_sleeve" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_cry_critical", stake = 3 }
        elseif self.key == "sleeve_jimb_neon" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_jimb_neon", stake = 3 }
        elseif self.key == "sleeve_buf_galloping" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_buf_galloping", stake = 3 }
        elseif self.key == "sleeve_buf_jstation" then
            self.unlocked = false
            self.unlock_condition = { deck = "b_buf_jstation", stake = 3 }
        end

        CardSleeves_Sleeve_inject(self)
    end
end

if (SMODS.Mods["LobotomyCorp"] or {}).can_load then
    SMODS.UndiscoveredSprite {
        key = 'EGO_Gift',
        atlas = 'lobc_LobotomyCorp_Undiscovered',
        pos = {x = 0, y = 0}
    }
end

if (SMODS.Mods["Pokermon"] or {}).can_load then
    SMODS.UndiscoveredSprite {
        key = 'Item',
        atlas = 'poke_Mart',
        pos = {x = 0, y = 0}
    }
    SMODS.UndiscoveredSprite {
        key = 'Energy',
        atlas = 'poke_Mart',
        pos = {x = 0, y = 0}
    }
end

if (SMODS.Mods["Othermod"] or {}).can_load then
    SMODS.UndiscoveredSprite {
        key = 'potion',
        atlas = 'othe_blue_and_red',
        pos = {x = 0, y = 0}
    }
end

if (SMODS.Mods["robalatro"] or {}).can_load then
    SMODS.UndiscoveredSprite {
        key = 'Gear',
        atlas = 'robl_gearatlas',
        pos = {x = 0, y = 0}
    }
end

local pack = G.P_CENTERS["p_voucher_pack"]
print("checking p_voucher_pack")
if pack then
    print("Updating p_voucher_pack")
    pack.discovered = false
end
pack = G.P_CENTERS["p_uncommon_voucher_pack"]
print("checking p_uncommon_voucher_pack")
if pack then
    print("Updating p_uncommon_voucher_pack")
    pack.discovered = false
end
pack = G.P_CENTERS["p_fusion_voucher_pack"]
print("checking p_fusion_voucher_pack")
if pack then
    print("Updating p_fusion_voucher_pack")
    pack.discovered = false
end

function G.UIDEF.profile_option(_profile)
    set_discover_tallies()
    G.focused_profile = _profile
    local profile_data = get_compressed(G.focused_profile..'/'..'profile.jkr')
        if profile_data ~= nil then
        profile_data = STR_UNPACK(profile_data)
        profile_data.name = profile_data.name or ("P".._profile)
        end
    G.PROFILES[_profile].name = profile_data and profile_data.name or ''

    local lwidth, rwidth, scale = 1, 1, 1
    G.CHECK_PROFILE_DATA = nil
    local t = {n=G.UIT.ROOT, config={align = 'cm', colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = 'cm',padding = 0.1, minh = 0.8}, nodes={
            ((_profile == G.SETTINGS.profile) or not profile_data) and {n=G.UIT.R, config={align = "cm"}, nodes={
            create_text_input({
            w = 4, max_length = 16, prompt_text = localize('k_enter_name'),
            ref_table = G.PROFILES[_profile], ref_value = 'name',extended_corpus = true, keyboard_offset = 1,
            callback = function() 
                G:save_settings()
                G.FILE_HANDLER.force = true
            end
            }),
        }} or {n=G.UIT.R, config={align = 'cm',padding = 0.1, minw = 4, r = 0.1, colour = G.C.BLACK, minh = 0.6}, nodes={
            {n=G.UIT.T, config={text = G.PROFILES[_profile].name, scale = 0.45, colour = G.C.WHITE}},
        }},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
        {n=G.UIT.C, config={align = "cm", minw = 6}, nodes={
            (G.PROFILES[_profile].progress and G.PROFILES[_profile].progress.discovered) and create_progress_box(G.PROFILES[_profile].progress, 0.5) or
            {n=G.UIT.C, config={align = "cm", minh = 4, minw = 5.2, colour = G.C.BLACK, r = 0.1}, nodes={
            {n=G.UIT.T, config={text = localize('k_empty_caps'), scale = 0.5, colour = G.C.UI.TRANSPARENT_LIGHT}}
            }},
        }},
        {n=G.UIT.C, config={align = "cm", minh = 4}, nodes={
            {n=G.UIT.R, config={align = "cm", minh = 1}, nodes={
            profile_data and {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.C, config={align = "cm", minw = lwidth}, nodes={{n=G.UIT.T, config={text = localize('k_wins'),colour = G.C.UI.TEXT_LIGHT, scale = scale*0.7}}}},
                {n=G.UIT.C, config={align = "cm"}, nodes={{n=G.UIT.T, config={text = ': ',colour = G.C.UI.TEXT_LIGHT, scale = scale*0.7}}}},
                {n=G.UIT.C, config={align = "cl", minw = rwidth}, nodes={{n=G.UIT.T, config={text = tostring(profile_data.career_stats.c_wins),colour = G.C.RED, shadow = true, scale = 1*scale}}}}
            }} or nil,
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0.2}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                {n=G.UIT.R, config={align = "cm", minw = 4, maxw = 4, minh = 0.8, padding = 0.2, r = 0.1, hover = true, colour = G.C.BLUE,func = 'can_load_profile', button = "load_profile", shadow = true, focus_args = {nav = 'wide'}}, nodes={
                {n=G.UIT.T, config={text = _profile == G.SETTINGS.profile and localize('b_current_profile') or profile_data and localize('b_load_profile') or localize('b_create_profile'), ref_value = 'load_button_text', scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}
                }}
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0, minh = 0.7}, nodes={
                {n=G.UIT.R, config={align = "cm", minw = 3, maxw = 4, minh = 0.6, padding = 0.2, r = 0.1, hover = true, colour = G.C.RED,func = 'can_delete_profile', button = "delete_profile", shadow = true, focus_args = {nav = 'wide'}}, nodes={
                {n=G.UIT.T, config={text = _profile == G.SETTINGS.profile and localize('b_reset_profile') or localize('b_delete_profile'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}}
                }}
            }},
            (_profile == G.SETTINGS.profile and not G.PROFILES[G.SETTINGS.profile].all_unlocked) and {n=G.UIT.R, config={align = "cm", padding = 0, minh = 0.7}, nodes={
                {n=G.UIT.R, config={align = "cm", minw = 3, maxw = 4, minh = 0.6, padding = 0.2, r = 0.1, hover = true, colour = G.C.ORANGE,func = 'can_unlock_all', button = "unlock_all", shadow = true, focus_args = {nav = 'wide'}}, nodes={
                {n=G.UIT.T, config={text = localize('b_unlock_all'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}}
                }}
            }} or {n=G.UIT.R, config={align = "cm", minw = 3, maxw = 4, minh = 0.7}, nodes={
                G.PROFILES[_profile].all_unlocked and ((not G.F_NO_ACHIEVEMENTS) and {n=G.UIT.T, config={text = localize(G.F_TROPHIES and 'k_trophies_disabled' or 'k_achievements_disabled'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}} or 
                nil) or nil
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0, minh = 0.7}, nodes={
                {n=G.UIT.R, config={align = "cm", minw = 3, maxw = 4, minh = 0.6, padding = 0.2, r = 2.1, hover = true, colour = G.C.GREY,button = "undiscover_all", shadow = true, focus_args = {nav = 'wide'}}, nodes={
                {n=G.UIT.T, config={text = "Undiscover All", scale = 0.3, colour = G.C.UI.TEXT_LIGHT}}
                }}
            }},
            }},
        }},
        }},
        {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
        {n=G.UIT.T, config={id = 'warning_text', text = localize('ph_click_confirm'), scale = 0.4, colour = G.C.CLEAR}}
        }}
    }} 
    return t
end

G.FUNCS.undiscover_all = function(e)
    G.PROFILES[G.SETTINGS.profile].all_unlocked = false
    if G.P_SKILLS then
        for _, v in pairs(G.P_SKILLS) do
            if not v.demo and not v.wip then
                v.alerted = false
                v.discovered = false
                v.unlocked = false
            end
        end
    end
    for _, v in pairs(G.P_CENTERS) do
    if not v.demo and not v.wip and v.set ~= "Ability" then
        v.alerted = false
        v.discovered = false
        v.unlocked = false
    end
    end
    for _, v in pairs(G.P_BLINDS) do
    if not v.demo and not v.wip then
        v.alerted = false
        v.discovered = false
        v.unlocked = false
    end
    end
    for _, v in pairs(G.P_TAGS) do
    if not v.demo and not v.wip then
        v.alerted = false
        v.discovered = false
        v.unlocked = false
    end
    end
    set_profile_progress()
    set_discover_tallies()
    G:save_progress()
    G.FILE_HANDLER.force = true
end

G.FUNCS.clear_all = function(e)
    if G.P_SKILLS then
        for _, v in pairs(G.P_SKILLS) do
            if not v.demo and not v.wip then
                v.alerted = true
            end
        end
    end
    for _, v in pairs(G.P_CENTERS) do
        if not v.demo and not v.wip then
            v.alerted = true
        end
    end
    for _, v in pairs(G.P_BLINDS) do
        if not v.demo and not v.wip then
            v.alerted = true
        end
    end
    for _, v in pairs(G.P_TAGS) do
        if not v.demo and not v.wip then
            v.alerted = true
        end
    end
    for _, v in pairs(G.P_SEALS) do
        if not v.demo and not v.wip then
            v.alerted = true
        end
    end
    set_profile_progress()
    set_discover_tallies()
    G:save_progress()
    G.FILE_HANDLER.force = true
end


-------------------------------------------------
------------MOD CODE END-------------------------
