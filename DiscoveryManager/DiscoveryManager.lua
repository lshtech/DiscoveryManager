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
            UIBox_button({label = {"Unlock/Discover All"}, button = "discover_all", colour = G.C.ORANGE, minw = 5, minh = 0.7, scale = 0.6}),
            UIBox_button({label = {"Reset"}, button = "reset_cards", colour = G.C.ORANGE, minw = 5, minh = 0.7, scale = 0.6}),
            UIBox_button({label = {"Clear Alerts"}, button = "clear_alerts", colour = G.C.ORANGE, minw = 5, minh = 0.7, scale = 0.6}),
        },
    }
end

local game_load_profile_ref = Game.load_profile
function Game:load_profile(_profile)
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        } do
        for k, v in pairs(t) do
            if not v.set or v.set ~= "Ability" then
                v.discovered = false
            end
        end
    end
    game_load_profile_ref(self, _profile)
end

local smods_save_unlocks = SMODS.SAVE_UNLOCKS
function SMODS.SAVE_UNLOCKS()
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        SMODS.Centers
        } do
        for k, v in pairs(t) do
            if v.discovered == true and v.set ~= "Ability" then
                v.discovered = false
            end
        end
    end
    smods_save_unlocks()
end

G.FUNCS.clear_alerts = function(e)
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        SMODS.Centers
        } do
        for _, v in pairs(t) do
            if v.discovered == true and v.alerted == false then
                v.alerted = true
            end
        end
    end
    set_profile_progress()
    set_discover_tallies()
    smods_save_unlocks()
end

G.FUNCS.discover_all = function(e)
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        SMODS.Centers
        } do
        for _, v in pairs(t) do
            if v.unlocked == false then
                v.unlocked = true
            end
            if v.discovered == false then
                v.discovered = true
                v.alerted = true
            end
        end
    end
    if G.P_SKILLS then
        for _,v in pairs(G.P_SKILLS) do
            if v.unlocked == false then
                v.unlocked = true
            end
            if v.discovered == false then
                v.discovered = true
                v.alerted = true
            end
        end
    end
    set_profile_progress()
    set_discover_tallies()
    smods_save_unlocks()
end

G.FUNCS.reset_cards = function(e)
    print("Reset Discovered | Resetting all files")
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        } do
        for k, v in pairs(t) do
            v.discovered = false
            v._discovered_unlocked_overwritten = true
            if SMODS.Centers[v.key] and SMODS.Centers.discovered == true then
                SMODS.Centers.discovered = false
            end
        end
    end
    local meta = STR_UNPACK(get_compressed(G.SETTINGS.profile .. '/' .. 'meta.jkr') or 'return {}')
    meta.unlocked = {}
    meta.discovered = {}
    meta.alerted = {}
    compress_and_save( G.SETTINGS.profile .. '/'..'meta.jkr', STR_PACK(meta))

    set_profile_progress()
    set_discover_tallies()
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
    if not self.loc_txt.undiscovered or self.loc_txt.undiscovered.text[1] ==  'idk stuff ig' then
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
        end

        CardSleeves_Sleeve_inject(self)
    end
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


-------------------------------------------------
------------MOD CODE END-------------------------