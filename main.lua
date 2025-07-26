--- STEAMODDED HEADER
--- MOD_NAME: Battle for Jimbo
--- MOD_ID: BFDI
--- MOD_AUTHOR: [WusGud, Nitro]
--- MOD_DESCRIPTION: A Balatro mod themed around BFDI which adds 75 brand new jokers to the game!
--- PREFIX: BFDI

SMODS.Atlas{
    key = 'Jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

  SMODS.Joker{ 
    key = 'joker2',
    loc_txt = {
        name = 'Balloony',
        text = {
            '{C:red}+8{} Mult'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 0},
    config = { extra = {
        mult = 8
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
            mult = card.ability.extra.mult
            }
        end
    end
 }
    SMODS.Joker{
        key = 'joker3',
        loc_txt = {
            name = 'Cake',
            text = {
            '{C:blue}+50{} Chips',
            }
        },
        atlas = 'Jokers',
        rarity = 1,
        cost = 2,
        unlocked = true,
        discovered = false,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        pos = {x = 1, y = 0},
        config = { extra = {
            chips = 50
        }
        },
        loc_vars = function(self,info_queue,center)
            return {vars = {center.ability.extra.chips}}
        end,
        calculate = function(self,card,context)
            if context.joker_main then
                return {
                    card = card,
                    chip_mod = card.ability.extra.chips,
                    message = '+' .. card.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end
 } 
   SMODS.Joker{
    key = 'joker4',
    loc_txt = {
        name = 'Winner', 
        text = {
            'If all cards in',
            'scored hand are {C:attention}7s{},',
            'get {X:mult,C:white}X3{} Mult'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 0},
    config = { extra = {
        Xmult = 3
    }
    },
    loc_vars = function(self,info_queue,card)
        return { vars = {card.ability.extra.Xmult} }
    end,
    calculate = function(self,card,context)
        local all_sevens = true
        if context.joker_main then
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() ~= 7 then
                    all_sevens = false
                    break
                end
            end
            if all_sevens then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker5',
    loc_txt = {
        name = 'Bottle', 
        text = {
            'This Joker gains {C:red}+5{} Mult',
            'and {C:blue}+25{} Chips for every',
            '{C:attention}Glass Card{} that is destroyed',
            '{C:inactive}(Currently {C:mult}+#4#{}{C:inactive} Mult and {C:chips}+#2#{}{C:inactive} Chips)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 0},
    config = { extra = {
        chips = 0, chip_mod = 25, mult = 0, mult_mod = 5
    }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return { vars = { card.ability.extra.chip_mod, card.ability.extra.chips, card.ability.extra.mult_mod, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
                        local glass_cards = 0
            for _, removed_card in ipairs(context.removed) do
                if removed_card.shattered then glass_cards = glass_cards + 1 end
            end 
            if glass_cards > 0 then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        card.ability.extra.chips = card.ability.extra.chips +
                                            card.ability.extra.chip_mod * glass_cards
                                        card.ability.extra.mult = card.ability.extra.mult +
                                            card.ability.extra.mult_mod * glass_cards
                                        return true
                                    end
                                }))
                                SMODS.calculate_effect(
                                    {
                                        message = 'Upgrade!'
                                    }, card)
                                return true
                            end
                        }))
                    end
                }
            end
        end
        if context.using_consumeable and not context.blueprint and not context.retrigger_joker and context.consumeable.config.center.key == 'c_hanged_man' then
            local glass_cards = 0
            for _, removed_card in ipairs(G.hand.highlighted) do
                if SMODS.has_enhancement(removed_card, 'm_glass') then glass_cards = glass_cards + 1 end
            end
            if glass_cards > 0 then
                card.ability.extra.chips = card.ability.extra.chips +
                    card.ability.extra.chip_mod * glass_cards
                return {
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
                }
            end
            if glass_cards > 0 then
                card.ability.extra.mult = card.ability.extra.mult +
                    card.ability.extra.mult_mod * glass_cards
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult}}
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker6',
    loc_txt = {
        name = 'Pillow', 
        text = {
            'When {C:attention}Blind{} is selected,',
            'destroy Joker to the right',
            'and permanently add {C:chips}Chips{}',
            'based on the Jokers rarity',
            '{s:0.8,C:blue}+20{}{s:0.8} for {}{s:0.8,C:common}common{}{s:0.8}, {}{s:0.8,C:blue}+40{}{s:0.8} for {}{s:0.8,C:uncommon}uncommon{}{s:0.8},{}',
            '{s:0.8,C:blue}+100{}{s:0.8} for {}{s:0.8,C:rare}rare{}{s:0.8}, and {}{s:0.8,C:blue}+1000{}{s:0.8} for {}{s:0.8,C:legendary}legendary{}{s:0.8}.{}',
            '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 5},
    config = { extra = {
        chips = 0
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.chips}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind and not context.blueprint and not context.retrigger_joker then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end
            if my_pos and G.jokers.cards[my_pos + 1] and not G.jokers.cards[my_pos + 1].ability.eternal and not G.jokers.cards[my_pos + 1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos + 1]
                for i, isjokercake in ipairs(G.jokers.cards) do
                    if G.jokers.cards[i].config.center.loc_txt ~= nil then
                        if G.jokers.cards[i].config.center.loc_txt.name == 'Cake' then
                            sliced_card = G.jokers.cards[i]
                            break
                        end
                    end
                end
                sliced_card.getting_sliced = true -- Make sure to do this on destruction effects
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                if sliced_card.config.center.rarity == 1 or sliced_card.config.center.rarity == "Common" then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.joker_buffer = 0
                            card.ability.extra.chips = card.ability.extra.chips + 20
                            card:juice_up(0.8, 0.8)
                            sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end
                    }))
                    return {
                        message = localize { type = 'variable', key = 'a_chips', vars = { '20' } },
                        colour = G.C.CHIPS,
                        no_juice = true
                    }
                end
                if G.jokers.cards[my_pos + 1].config.center.rarity == 2 or G.jokers.cards[my_pos + 1].config.center.rarity == "Uncommon" then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.joker_buffer = 0
                            card.ability.extra.chips = card.ability.extra.chips + 40
                            card:juice_up(0.8, 0.8)
                            sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end
                    }))
                    return {
                        message = localize { type = 'variable', key = 'a_chips', vars = { '40' } },
                        colour = G.C.CHIPS,
                        no_juice = true
                    }
                end
                if G.jokers.cards[my_pos + 1].config.center.rarity == 3 or G.jokers.cards[my_pos + 1].config.center.rarity == "Rare" then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.joker_buffer = 0
                            card.ability.extra.chips = card.ability.extra.chips + 100
                            card:juice_up(0.8, 0.8)
                            sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end
                    }))
                    return {
                        message = localize { type = 'variable', key = 'a_chips', vars = { '100' } },
                        colour = G.C.CHIPS,
                        no_juice = true
                    }
                end
                if G.jokers.cards[my_pos + 1].config.center.rarity == 4 or G.jokers.cards[my_pos + 1].config.center.rarity == "Legendary" then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.joker_buffer = 0
                            card.ability.extra.chips = card.ability.extra.chips + 1000
                            card:juice_up(0.8, 0.8)
                            sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end
                    }))
                    return {
                        message = localize { type = 'variable', key = 'a_chips', vars = { '1000' } },
                        colour = G.C.CHIPS,
                        no_juice = true
                    }
                end
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker7',
    loc_txt = {
        name = 'Lollipop', 
        text = {
            'If played hand contains',
            'at least {C:attention}two different{}',
            'scoring suits, earn {C:money}$#1#{}'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 0},
    config = { extra = {
        dollars = 2
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.dollars, localize('Spades', 'suits_plural'), localize('Clubs', 'suits_plural'), localize('Hearts', 'suits_plural'), localize('Diamonds', 'suits_plural')}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local unique_suits = 0
            local num_hearts = 0
            local num_clubs = 0
            local num_spades = 0
            local num_diamonds = 0
            for _ , playing_card in ipairs(context.scoring_hand) do
                if playing_card:is_suit('Clubs') then
                    num_clubs = num_clubs + 1
                end
                if playing_card:is_suit('Spades') then
                    num_spades = num_spades + 1
                end
                if playing_card:is_suit('Diamonds') then
                    num_diamonds = num_diamonds + 1
                end
                if playing_card:is_suit('Hearts') then
                    num_hearts = num_hearts + 1
                end
            end
            if num_hearts > 0 then
                unique_suits = unique_suits + 1
            end
            if num_diamonds > 0 then
                unique_suits = unique_suits + 1
            end
            if num_clubs > 0 then
                unique_suits = unique_suits + 1
            end
            if num_spades > 0 then
                unique_suits = unique_suits + 1
            end
            if unique_suits > 1 then
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker8',
    loc_txt = {
        name = 'Taco', 
        text = {
            '{C:red}+10{} Mult and {C:blue}+50{} Chips for',
            'each empty {C:attention}Joker{} slot',
            '{s:0.8}Taco included{}',
            '{C:inactive}(Currently {C:mult}+#2#{}{C:inactive} Mult and {C:chips}+#1#{}{C:inactive} Chips)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 5},
    config = { extra = {
        chips = 0, chip_mod = 50, mult = 0, mult_mod = 10
    }
    },
    loc_vars = function(self, info_queue, center)
        return { 
           vars = { 
                G.jokers and math.max(0, ((G.jokers.config.card_limit - (#G.jokers.cards - #SMODS.find_card("j_BFDI_joker8"))) * 50) + (#SMODS.find_card("j_vremade_stencil", true)) * 50) or 0, 
                G.jokers and math.max(0, ((G.jokers.config.card_limit - (#G.jokers.cards - #SMODS.find_card("j_BFDI_joker8"))) * 10) + (#SMODS.find_card("j_vremade_stencil", true)) * 10) or 0 
           }
      }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = math.max(0,
                    ((G.jokers.config.card_limit - (#G.jokers.cards - #SMODS.find_card("j_BFDI_joker8")))*50) + (#SMODS.find_card("j_vremade_stencil", true)*50)),
                mult = math.max(0,
                    ((G.jokers.config.card_limit - (#G.jokers.cards - #SMODS.find_card("j_BFDI_joker8")))*10) + (#SMODS.find_card("j_vremade_stencil", true)*10))
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker9',
    loc_txt = {
        name = 'Grassy',
        text = {
            'When {C:attention}High Card{} is',
            'played, equal chance',
            'for either {C:mult}+15{} Mult,',
            '{C:chips}+50{} Chips, or {X:mult,C:white}x3{} Mult'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 0},
    config = { extra = {
        mult = 15, chips = 50, Xmult = 3, type = 'High Card'
    }
    },
    loc_vars = function(self,info_queue,card)
        return { vars = {card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self,card,context) 
        if context.joker_main and context.scoring_name == card.ability.extra.type then
            local grassy_num = math.random(1, 3)
            if grassy_num == 1 then
                return {
                    mult = card.ability.extra.mult
                }
            end
            if grassy_num == 2 then
                return {
                    chips = card.ability.extra.chips
                }
            end
            if grassy_num == 3 then
                return {
                    Xmult = card.ability.extra.Xmult
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker10',
    loc_txt = {
        name = 'Eggy', 
        text = {
            'Increases the {C:attention}sell value{}',
            'of adjacent jokers by {C:money}$2{}',
            'and gives {C:money}$3{} at the end',
            'of each round',
            '{C:green}#3# in 6{} chance of this card',
            'being destroyed at the',
            'end of round as well'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 0},
    config = { extra = {
        dollars = 3, price = 2, odds = 6
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.price, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds }}
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if pseudorandom('vremade_gros_michel') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = 'Cracked!'
                }
            else
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        left_joker = G.jokers.cards[i - 1]
                        right_joker = G.jokers.cards[i + 1]
                    end
                end
                if left_joker ~= nil then
                    left_joker.ability.extra_value = left_joker.ability.extra_value + card.ability.extra.price
                end
                if right_joker ~= nil then
                    right_joker.ability.extra_value = right_joker.ability.extra_value + card.ability.extra.price
                end
                if left_joker ~= nil then
                    left_joker:set_cost()
                end
                if right_joker ~= nil then
                    right_joker:set_cost()
                end
                if left_joker ~= nil or right_joker ~= nil then
                    return {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY
                    }
                end
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
 }
  SMODS.Joker{ 
    key = 'joker11',
    loc_txt = {
        name = '8 Ball', 
        text = {
            'Each played {C:attention}8{} gives',
            '{C:mult}+8{} Mult and {C:chips}+8{} Chips',
            'when scored'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 0},
    config = { extra = {
        chips = 8, mult = 8
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.mult}, {center.ability.extra.chips}}
    end,
    calculate = function(self,card,context)
        if self.debuff then return nil end
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 8 then
            return {
                card = card,
                chip_mod = card.ability.extra.chips,
                message = '+' .. card.ability.extra.chips,
                colour = G.C.CHIPS,
                card = card,
                mult = card.ability.extra.mult,
                message = '+' .. card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
        
    end
 }
  SMODS.Joker{
    key = 'joker12',
    loc_txt = {
        name = 'Foldy', 
        text = {
            'Played cards with',
            '{C:attention}no enhancements{} give',
            '{C:mult}+3{} Mult when scored'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 1},
    config = { extra = {
        mult = 3, key = 'c_base'
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'c_base') then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker13',
    loc_txt = {
        name = 'Clock', 
        text = {
            'The amount of hands used',
            'in the {C:attention}small{} and {C:attention}big{} blinds',
            'gets added to the total',
            'hands for the {C:attention}boss blind{}.',
            'resets after each ante',
            '{C:inactive}(Currently {C:blue}+#1#{}{C:inactive} hands)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 1},
    config = { extra = { 
        hands = 0, hands_mod = 1
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.hands, center.ability.extra.hands_mod}}
    end,
    calculate = function(self,card,context) 
        if context.joker_main and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.hands = card.ability.extra.hands + card.ability.extra.hands_mod
            return {
                message = '+1 Hand',
                colour = G.C.CHIPS
            }
        end
        if context.setting_blind and G.GAME.blind.boss then
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            ease_hands_played(card.ability.extra.hands)
                            SMODS.calculate_effect(
                                { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                                card)
                            return true
                        end
                    }))
                end
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and G.GAME.blind.boss and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.hands = 0
            return {
            message = 'Reset!'
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker14',
    loc_txt = {
        name = 'Barf Bag',
        text = {
            'Gains {C:mult}+#2#{} discard if no discards',
            'are used by the end of the round and',
            'loses {C:mult}-#2#{} discard if any discards',
            'are used by the end of the round',
            '{C:inactive}(currently {C:mult}#1#{}{C:inactive} discard/s){}'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 1},
    config = { extra = {
        d_size = 0, d_size_mod = 1
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.d_size, center.ability.extra.d_size_mod}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
        ease_discard(card.ability.extra.d_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
        ease_discard(-card.ability.extra.d_size)
    end,
    calculate = function(self,card,context) 
        if context.end_of_round and context.game_over == false and context.main_eval and not context.retrigger_joker and not context.blueprint then
            if G.GAME.current_round.discards_used >= 1 then
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
                card.ability.extra.d_size = card.ability.extra.d_size - card.ability.extra.d_size_mod
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
            else
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
                card.ability.extra.d_size = card.ability.extra.d_size + card.ability.extra.d_size_mod
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker15',
    loc_txt = {
        name = 'Fanny', 
        text = {
            '{C:attention}Levels up{} your',
            'played hand if',
            'that hand is {C:attention}not{}',
            'the most played'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 1},
    calculate = function(self,card,context) 
        if context.before and context.main_eval then
            local most_played = true
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    most_played = false
                    break
                end
            end
            if not most_played then
                return {
                level_up = true,
                message = localize('k_level_up_ex')
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker16',
    loc_txt = {
        name = 'Pie', 
        text = {
            '{C:mult}+3.14 {}Mult',
            'If a {C:attention}Flush{} of {C:blue}Clubs {}is',
            'played, explode and grant {C:money}$10'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 2,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 4},
    config = { extra = {
        mult = 3.14, type = 'Flush', suit = 'Clubs', dollars = 10
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult, card.ability.extra.dollars, localize(card.ability.extra.suit, 'suits_singular'), localize(card.ability.extra.type, 'poker_hands')}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local all_clubs = true
            for _ , playing_card in ipairs(context.scoring_hand) do
                if not playing_card:is_suit('Clubs', nil, true) then
                    all_clubs = false
                    break
                end
            end
            if all_clubs and context.scoring_name == card.ability.extra.type then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    dollars = card.ability.extra.dollars,
                    message = 'Extinct!'
                }
            end
            return { 
                mult = card.ability.extra.mult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker17',
    loc_txt = {
        name = 'Gaty', 
        text = {
            'This Joker gains {C:mult}+1{} Mult',
            'if played hand contains',
            'a {C:attention}Pair{}',
            '{C:inactive}(Currently {C:red}+#3#{}{C:inactive} Mult)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 1},
    config = { extra = {
        mult_mod = 1, mult = 0
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult_gain,localize('Pair','poker_hands'),card.ability.extra.mult}}
    end,
    calculate = function(self,card,context) 
        if context.before and context.main_eval and not context.blueprint and not context.retrigger_joker and (next(context.poker_hands['Pair']) or next(context.poker_hands['Two Pair']) or next(context.poker_hands['Full House']) or next(context.poker_hands['Three of a Kind']) or next(context.poker_hands['Four of a Kind']) or next(context.poker_hands['Five of a Kind'])) then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker18',
    loc_txt = {
        name = 'Robot Flower', 
        text = {
            'This Joker {C:attention}randomly{} gives between',
            '{X:chips,C:white}X0.5{} and {X:chips,C:white}X2.5{} chips'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 1},
    config = { extra = { max = 2.5, min = 0.5 } },
    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        local value = card.ability.extra.min
        while value <= card.ability.extra.max + 1e-9 do 
            r_chips[#r_chips + 1] = string.format("%.1f", value)
            value = value + 0.1
        end
        return r_chips
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local min10 = card.ability.extra.min * 10
            local max10 = card.ability.extra.max * 10
            local randomInt = pseudorandom('vremade_misprint', math.floor(min10), math.floor(max10))
            return { x_chips = randomInt / 10 }
        end
    end
 }
  SMODS.Joker{
    key = 'joker19',
    loc_txt = {
        name = 'Bracelety', 
        text = {
            '{C:mult}+12 {}Mult if played hand contains',
            'a {C:attention}Three of a Kind{}, and',
            'an additional {X:red,C:white}X4 {} Mult if',
            '{C:purple}Ice Cube {}is held'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 1},
    config = { extra = {
        mult = 12, Xmult = 4, type = 'Three of a Kind'
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult, localize(card.ability.extra.type, 'poker_hands')}}
    end,
    calculate = function(self,card,context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            local has_icy = false
            for i, isjokericy in ipairs(G.jokers.cards) do
                if G.jokers.cards[i].config.center.loc_txt ~= nil then
                    if G.jokers.cards[i].config.center.loc_txt.name == 'Ice Cube' then
                        has_icy = true
                        break
                    end
                end
            end
            if has_icy then
                return {
                    mult = card.ability.extra.mult,
                    Xmult = card.ability.extra.Xmult
                }
            else
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker20',
    loc_txt = {
        name = 'Cloudy',
        text = {
            'Awards {C:money}$1{} for every 2',
            'cards above the {C:attention}starting amount{}',
            'in your deck, and {C:mult}-$1 {}for',
            'each 2 cards below',
            '{C:inactive}(Currently {C:money}$#2#{C:inactive})'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 9,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 1},
    config = { extra = {
        dollars = 1
    }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollars * (math.floor((G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0) / 2 )), G.GAME.starting_deck_size } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.retrigger_joker and not context.blueprint  then
            if #G.playing_cards - G.GAME.starting_deck_size ~= 0 then
                dollars = math.floor((#G.playing_cards - G.GAME.starting_deck_size) / 2 )
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
    local shmell = 0
        if dollars == 0 then
            shmell = shmell + 1
        else
            return dollars
        end
    end
 }
  SMODS.Joker{
    key = 'joker21',
    loc_txt = {
        name = 'Saw', 
        text = {
            'Sell this card to halve',
            'the {C:attention}chips{} required to',
            'pass the current {C:attention}Boss Blind'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 1},
    calculate = function(self,card,context)
        if context.selling_self and not context.retrigger_joker and not context.blueprint then
            if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.boss then
                G.GAME.blind.chips = G.GAME.blind.chips / 2
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.GAME.blind:wiggle()
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker22',
    loc_txt = {
        name = 'Black Hole', 
        text = {
            'Zeros all {C:attention}listed',
            '{C:green,E:1,S:1.1}probabilities{} for {C:attention}card abilities',
            '{C:inactive}(ex: {C:green}1 in 4{C:inactive} -> {C:green}0 in 4{C:inactive})'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 4},
    add_to_deck = function(self, card, from_debuff)
        G.GAME.backupprobabilities = {}
        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.backupprobabilities[k] =  G.GAME.probabilities[k]
            G.GAME.probabilities[k] = v * 0
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = G.GAME.probabilities[k] + G.GAME.backupprobabilities[k]
        end
    end
 }
  SMODS.Joker{
    key = 'joker23',
    loc_txt = {
        name = 'Roboty', 
        text = {
            'Retrigger',
            "each played {C:attention}10{}"
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 2},
    config = { extra = {
        repetitions = 1
    }
    },
    calculate = function(self,card,context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card:get_id() == 10 then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end
 }
    SMODS.Joker{
    key = 'joker24',
    loc_txt = {
        name = 'Remote',
        text = {
            'Retriggers all compatible',
            '{C:attention}mechanical minds'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 9,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 4},
    calculate = function(self,card,context)
        if context.retrigger_joker_check and context.other_card.config.center.loc_txt ~= nil then
            for i, joker in ipairs(G.jokers.cards) do
                if context.other_card.config.center.loc_txt.name == 'TV' or context.other_card.config.center.loc_txt.name == 'Robot Flower' or context.other_card.config.center.loc_txt.name == 'Roboty' then
                    return {
                        repetitions = 1
                    }
                end
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker25',
    loc_txt = {
        name = 'Marker',
        text = {
            'Every {C:attention}3{} hands played',
            'this Joker converts',
            'the {C:attention}suit{} of all {C:attention}played{}',
            'cards to {C:spades}Spades{}',
            '{C:inactive}#1# remaining{}'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 4},
    config = { extra = {
        hands_remaining = 3
    }
    },
    loc_vars = function(self,info_queue,center)
        return {
            vars = {
                center.ability.extra.hands_remaining
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not context.retrigger_joker and not context.blueprint then
            card.ability.extra.hands_remaining = card.ability.extra.hands_remaining - 1
            if card.ability.extra.hands_remaining == 0 then
                local thingies = {}
                for _, _card in ipairs(context.full_hand) do
                    if _card:is_suit('Hearts') or _card:is_suit('Diamonds') or _card:is_suit('Clubs') or _card:is_suit('Spades') then
                        thingies[#thingies + 1] = _card
                        _card:change_suit('Spades', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                _card:juice_up()
                                return true
                            end
                        }))
                    end
                end
                if #thingies > 0 then
                    card.ability.extra.hands_remaining = 3
                    return {
                        message = 'Marked!',
                        colour = G.C.PURPLE
                    }
                end
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker26',
    loc_txt = {
        name = 'Basketball', 
        text = {
            'This Joker gives {C:money}#2#{}',
            'dollars at the end of',
            'round for every {C:attention}5 times{}',
            'your most played hand',
            'has been played',
            '{C:inactive}(Currently {C:money}$#1#{}{C:inactive} Dollars)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 5},
    config = {extra = { dollars = 0, increase = 2 }},
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.dollars, center.ability.extra.increase } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint and not context.retrigger_joker then
            local _planet, _hand, _tally = nil, nil, 0
            for k, v in ipairs(G.handlist) do
                 if G.GAME.hands[v].visible and G.GAME.hands[v].played > _tally then
                    _hand = v
                    _tally = G.GAME.hands[v].played
                end
            end
            local multiple5s = 0
            local maxhands = 1
            local placeholder = multiple5s
            if maxhands > 0 then
                multiple5s = math.floor(_tally / 5)
                card.ability.extra.dollars = card.ability.extra.increase * multiple5s
                placeholder = multiple5s
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
    local shmell = 0
        if card.ability.extra.dollars == 0 then
            shmell = shmell + 1
        else
            return card.ability.extra.dollars
        end
    end
 }
  SMODS.Joker{
    key = 'joker27',
    loc_txt = {
        name = 'Stapy',
        text = {
            '{C:green}#2# in 2 {}chance to convert',
            'the {C:attention}highest{} ranked card in',
            'played hand into a {C:attention}Bonus Card',
            '{C:inactive}(targets rightmost highest value card){}'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 3},
    config = { extra = {
        odds = 2
    }
    },
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        return {vars = {card.ability.extra.odds, (G.GAME and G.GAME.probabilities.normal or 1)}}
    end,
    calculate = function(self,card,context)
        if context.before and context.main_eval and not context.blueprint and not context.retrigger_joker then
            local temp_Mult, temp_ID = 2, 2
            local raised_card = nil
            for i = 1, #context.scoring_hand do
                if temp_ID <= context.scoring_hand[i].base.id and not SMODS.has_no_rank(context.scoring_hand[i]) then
                    temp_Mult = context.scoring_hand[i].base.nominal
                    temp_ID = context.scoring_hand[i].base.id
                    raised_card = context.scoring_hand[i]
                end
            end
            if math.random() < G.GAME.probabilities.normal / card.ability.extra.odds then
                local thingies = {}
                for _, scored_card in ipairs(context.scoring_hand) do
                    if scored_card == raised_card then
                        thingies[#thingies + 1] = scored_card
                        scored_card:set_ability('m_bonus', nil, true)
                        G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                    end
                end
                if #thingies > 0 then
                return {
                    message = 'Stapled',
                    colour = G.C.CHIPS
                }
                end
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker28',
    loc_txt = {
        name = 'Loser', 
        text = {
            'When all other {C:attention}Joker{}',
            '{C:attention}slots{} are filled this',
            'Joker gains {X:mult,C:white}X3{} Mult'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 3},
    config = { extra = {
        Xmult = 3
    }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        if #G.jokers.cards == G.jokers.config.card_limit and context.joker_main then
            return {
            card = card,
            Xmult_mod = card.ability.extra.Xmult,
            message = 'X' .. card.ability.extra.Xmult,
            colour = G.C.MULT 
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker29',
    loc_txt = {
        name = 'Lightning', 
        text = {
            'This Joker gains {C:mult}+#1#{} Mult',
            'per {C:attention}consecutive{} hand',
            'played with exactly {C:attention}5{}',
            'cards in it',
            '{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 2},
    config = { extra = {
        mult_mod = 1, mult = 0
    }
    },
    loc_vars = function(self,info_queue,card)
        return {
            vars = {
                card.ability.extra.mult_mod, 
                card.ability.extra.mult
            }
        }
    end,
    calculate = function(self,card,context) 
        if context.before and context.main_eval and not context.blueprint and not context.retrigger_joker then
            local less = false
            for _, playing_card in ipairs(context.scoring_hand) do
                if #context.full_hand < 5 then
                    less = true
                    break
                end
            end
            if less then
                local last_mult = card.ability.extra.mult
                card.ability.extra.mult = 0
                if last_mult > 0 then
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker30',
    loc_txt = {
        name = 'Firey Jr.', 
        text = {
            'If {C:attention}first{} played hand',
            'contains {C:attention}5{} cards,',
            'this Joker gains {C:chips}+#2#{} Chips',
            '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 2},
    config = { extra = {
        chips = 0, chip_mod = 10
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod}}
    end,
    calculate = function(self,card,context) 
        if context.before and context.main_eval and not context.blueprint and not context.retrigger_joker and G.GAME.current_round.hands_played == 0 and #context.full_hand == 5 then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker31',
    loc_txt = {
        name = 'Bell',
        text = {
            '{C:green}#3# in #2#{} for a',
            '{C:planet}Planet{} Card to be',
            'created when a {C:attention}High{}',
            '{C:attention}Card{} is played'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 2},
    config = { extra = {
        type = 'High Card', odds = 2
    }
    },
    loc_vars = function(self,info_queue,card)
        return { vars = {localize(card.ability.extra.type, 'poker_hands'), card.ability.extra.odds, (G.GAME and G.GAME.probabilities.normal or 1) } }
    end,
    calculate = function(self,card,context) 
        if context.joker_main and context.scoring_name == card.ability.extra.type and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            if math.random() < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Planet',
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = '+Planet!',
                    colour = G.C.SECONDARY_SET.Planet,
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker32',
    loc_txt = {
        name = 'Price Tag',
        text = {
            'This Joker gains {C:money}+$#1#{} {C:attention}sell{}',
            '{C:attention}value{} for each card {C:attention}sold{}'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 3},
    config = { extra = {
        price = 1
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.price}}
    end,
    calculate = function(self,card,context) 
        if context.selling_card and not context.blueprint and not context.retrigger_joker then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.price
            card:set_cost()
             return {
                message = 'Value Up!',
                colour = G.C.MONEY
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker33',
    loc_txt = {
        name = 'Tree',
        text = {
            'After {C:attention}18{} rounds,',
            'this Joker {C:attention}sells{}',
            '{C:attention}itself{} and gives',
            'one consumable {C:spectral}Soul{}',
            '{C:inactive}(Currently {C:attention}#2#{C:inactive}/18)'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 3},
    config = { extra = {
        rounds = 18, rounds_done = 0
    }
    },
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_soul
        return {
            vars = {card.ability.extra.rounds, card.ability.extra.rounds_done}
        }
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            card.ability.extra.rounds_done = card.ability.extra.rounds_done + 1
            if card.ability.extra.rounds == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then                
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card({key = "c_soul"})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                end
                return {
                    message = ('+1 soul!'),
                    colour = G.C.SECONDARY_SET.Spectral
                }
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end
 }
  SMODS.Joker{
    key = 'joker34',
    loc_txt = {
        name = 'Naily',
        text = {
            'Sell this card to',
            'give a {C:attention}random{} Joker',
            'an {C:purple}Eternal{} Sticker'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 3},
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = {key = "eternal", set = "Other"}
    end,
    calculate = function(self,card,context) 
        if context.selling_self and not context.retrigger_joker and not context.blueprint then
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card then
                    jokers[#jokers + 1] = G.jokers.cards[i]
                end
            end
            if #jokers > 0 then
                local chosen_joker = pseudorandom_element(jokers, pseudoseed('vremade_invisible'))
                return{
                    chosen_joker:set_eternal(true),
                    message = 'Nailed It!'
                }
            else
                return { message = localize('k_no_other_jokers') }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker35',
    loc_txt = {
        name = 'Liy',
        text = {
            '{C:mult}+#1#{} Mult and {C:chips}+#2#{} Chips',
            'Every {C:attention}5{} hands played',
            'this Joker {C:attention}flips her switch{}',
            '{C:inactive}#5# remaining{}'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 3},
    config = { extra = {
        mult = 6, chips = 18, Xmult = 3, hands = 5, hands_remaining = 5
    }
    },
    loc_vars = function(self,info_queue,center)
        return {
            vars = {
                center.ability.extra.mult,
                center.ability.extra.chips, 
                center.ability.extra.Xmult,
                center.ability.extra.hands,
                center.ability.extra.hands_remaining
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.hands_remaining = card.ability.extra.hands_remaining - 1
            if card.ability.extra.hands_remaining == 0 then
                if card.ability.extra.hands_remaining == 0 then
                    card:set_ability("j_BFDI_joker78")
                    return {
                        chips = card.ability.extra.chips,
                        mult = card.ability.extra.mult,
                        message = 'Flip!'
                    }
                end
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker36',
    loc_txt = {
        name = 'Blocky',
        text = {
            '{C:attention}Pranks {C:inactive}(debuffs) {}a {C:attention}random{} joker',
            'each round, and gains an effect',
            'based on its rarity',
            '{s:0.8,C:chips}+250 Chips{}{s:0.8} for {}{s:0.8,C:common}common{}{s:0.8}, {}{s:0.8,C:mult}+50 Mult{}{s:0.8} for {}{s:0.8,C:uncommon}uncommon{}{s:0.8},{}',
            '{s:0.8,X:red,C:white}X7 {}{s:0.8} Mult for {}{s:0.8,C:rare}rare{}{s:0.8}, and {}{s:0.8,C:attention}all{}{s:0.8} for {}{s:0.8,C:legendary}legendary{}{s:0.8}.{}',
            '{C:inactive}(Can only hold one Blocky!){}'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 3},
    config = { extra = {
        mult = 50, chips = 250, Xmult = 7
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.mult, card.ability.extra.Xmult, card.ability.extra.chips}}
    end,
    add_to_deck = function(self, card, from_debuff)
        blockycount = 0
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center_key == "j_BFDI_joker36" and G.jokers.cards[i].debuff ~= true then
                blockycount = blockycount + 1
            end
        end
        if blockycount > 0 then
            card:start_dissolve()
            ease_dollars(2)
        end
    end,
    calculate = function(self,card,context)
        prank_rarity = 0
        local shmell = 0
        if #G.jokers.cards == 1 then
            shmell = shmell + 1
        else
            if context.setting_blind and not context.blueprint and not context.retrigger_joker then
                local jokers = {}
                for i = 1, #G.jokers.cards do
                    if not G.jokers.cards[i].debuff or #G.jokers.cards < 2 then jokers[#jokers+1] = G.jokers.cards[i] end
                    G.jokers.cards[i]:set_debuff(false)
                end 
                isblocky = true
                while isblocky == true do
                    blocky_joker = pseudorandom_element(jokers, pseudoseed('crimson_heart'))
                    if blocky_joker.config.center.loc_txt == nil then
                        if blocky_joker.config.center.rarity == 1 or blocky_joker.config.center.rarity == 'Common' then
                            blocky_joker:set_debuff(true)
                            blocky_joker:juice_up()
                            prank_rarity = 1
                            isblocky = false
                        end
                        if blocky_joker.config.center.rarity == 2 or blocky_joker.config.center.rarity == 'Uncommon' then
                            blocky_joker:set_debuff(true)
                            blocky_joker:juice_up()
                            prank_rarity = 2
                            isblocky = false
                        end
                        if blocky_joker.config.center.rarity == 3 or blocky_joker.config.center.rarity == 'Rare' then
                            blocky_joker:set_debuff(true)
                            blocky_joker:juice_up()
                            prank_rarity = 3
                            isblocky = false
                        end
                        if blocky_joker.config.center.rarity == 4 or blocky_joker.config.center.rarity == 'Legendary' then
                            blocky_joker:set_debuff(true)
                            blocky_joker:juice_up()
                            prank_rarity = 4
                            isblocky = false
                        end
                        return {
                            message = ('Pranked!')
                        }
                    else
                        if blocky_joker.config.center.loc_txt.name ~= 'Blocky' then
                            if blocky_joker.config.center.rarity == 1 or blocky_joker.config.center.rarity == 'Common' then
                                blocky_joker:set_debuff(true)
                                blocky_joker:juice_up()
                                prank_rarity = 1
                                isblocky = false
                            end
                            if blocky_joker.config.center.rarity == 2 or blocky_joker.config.center.rarity == 'Uncommon' then
                                blocky_joker:set_debuff(true)
                                blocky_joker:juice_up()
                                prank_rarity = 2
                                isblocky = false
                            end
                            if blocky_joker.config.center.rarity == 3 or blocky_joker.config.center.rarity == 'Rare' then
                                blocky_joker:set_debuff(true)
                                blocky_joker:juice_up()
                                prank_rarity = 3
                                isblocky = false
                            end
                            if blocky_joker.config.center.rarity == 4 or blocky_joker.config.center.rarity == 'Legendary' then
                                blocky_joker:set_debuff(true)
                                blocky_joker:juice_up()
                                prank_rarity = 4
                                isblocky = false
                            end
                            return {
                                message = ('Pranked!')
                            }
                        end
                    end
                end
            end
            if context.joker_main then
                if blocky_joker.config.center.rarity == 1 or blocky_joker.config.center.rarity == 'Common' then
                    return {
                        chips = card.ability.extra.chips
                    }
                end
                if blocky_joker.config.center.rarity == 2 or blocky_joker.config.center.rarity == 'Uncommon' then
                    return {
                        mult = card.ability.extra.mult
                    }
                end
                if blocky_joker.config.center.rarity == 3 or blocky_joker.config.center.rarity == 'Rare' then
                    return {
                        Xmult = card.ability.extra.Xmult
                    }
                end
                if blocky_joker.config.center.rarity == 4 or blocky_joker.config.center.rarity == 'Legendary' then
                    return {
                        chips = card.ability.extra.chips,
                        mult = card.ability.extra.mult,
                        Xmult = card.ability.extra.Xmult
                    }
                end
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker37',
    loc_txt = {
        name = 'David', 
        text = {
            'Aw, seriously!'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 3},
    config = { extra = {
        slots = 1, rounds = 6
    }
    },
    loc_vars = function(self,info_queue,card)
            return {
                vars = {card.ability.extra.slots, card.ability.extra.rounds}
            }
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if card.ability.extra.rounds == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
                return {
                    message = ('Aw, seriously!'),
                    colour = G.C.SECONDARY_SET.Spectral
                }
            end
        end
    end,
    in_pool = function(self, args)
        return false
    end
 }
  SMODS.Joker{
    key = 'joker38',
    loc_txt = {
        name = 'Rocky', 
        text = {
            '{C:green}#1# in #2#{} chance',
            'when {C:attention}Blind{} is selected,',
            'to add a random {C:attention}playing{}',
            '{C:attention}card{} with a random',
            '{C:attention}seal{}, {C:attention}edition{} and,',
            '{C:attention}enhancement{} to your hand'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 2},
    config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and (pseudorandom('vremade_8_ball') < G.GAME.probabilities.normal / card.ability.extra.odds) then
            local rocky_edi = math.random(1,4)
            local rocky_enhan = math.random(1,9)
            local rocky_seal = math.random(1,5)
            local edition = ('e_base')
            local enhancement = ('m_base')
            if rocky_edi == 1 then
                edition = ('e_base')
            end
            if rocky_edi == 2 then
                edition = ('e_foil')
            end
            if rocky_edi == 3 then
                edition = ('e_holo')
            end
            if rocky_edi == 4 then
                edition = ('e_polychrome')
            end
            if rocky_enhan == 1 then
                enhancement = ('c_base')
            end
            if rocky_enhan == 2 then
                enhancement = ('m_steel')
            end
            if rocky_enhan == 3 then
                enhancement = ('m_stone')
            end
            if rocky_enhan == 4 then
                enhancement = ('m_gold')
            end
            if rocky_enhan == 5 then
                enhancement = ('m_lucky')
            end
            if rocky_enhan == 6 then
                enhancement = ('m_glass')
            end
            if rocky_enhan == 7 then
                enhancement = ('m_wild')
            end
            if rocky_enhan == 8 then
                enhancement = ('m_mult')
            end
            if rocky_enhan == 9 then
                enhancement = ('m_bonus')
            end
            local _card = create_playing_card({
                front = pseudorandom_element(G.P_CARDS, pseudoseed('vremade_certificate')),
                center = G.P_CENTERS.c_base
            }, G.discard, true, nil, { G.C.SECONDARY_SET.Enhanced }, true)
            if rocky_seal > 1 then 
                _card:set_seal(SMODS.poll_seal({ guaranteed = true, type_key = 'vremade_certificate_seal' }))
            end
            _card:set_edition(edition, true)
            _card:set_ability(enhancement, true)
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand:emplace(_card)
                            _card:start_materialize()
                            G.GAME.blind:debuff_card(_card)
                            G.hand:sort()
                            if context.blueprint_card then
                                context.blueprint_card:juice_up()
                            else
                                card:juice_up()
                            end
                            return true
                        end
                    }))
                    SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                end,
                message = 'Bleh!'
            }
        end
    end,
 }
  SMODS.Joker{
    key = 'joker39',
    loc_txt = {
        name = 'Teardrop',
        text = {
            'If {C:attention}poker hand{} is a',
            '{C:attention}Five of a Kind{} that',
            'contains a {C:blue}Club{}, create',
            'a random {C:spectral}Spectral{} card',
            '{C:inactive}(Must have room){}'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 2},
    config = { extra = { poker_hand = 'Five of a Kind', suit = 'Clubs' } },
    loc_vars = function(self, info_queue, card)
        return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands'), localize(card.ability.extra.suit, 'suits_singular') } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.poker_hand]) and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local has_club = false
            for _ , playing_card in ipairs(context.scoring_hand) do
                if playing_card:is_suit('Clubs', nil, true) then
                    has_club = true
                    break
                end
            end
            if has_club then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'vremade_seance'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker40',
    loc_txt = {
        name = 'Snowball',
        text = {
            'Create 2 {C:dark_edition}negative{} {C:tarot}Tarot{}',
            'cards if poker hand',
            'contains an {C:attention}Ace{} and',
            'a {C:attention}Straight Flush{}'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 3},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
    end,
    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands["Straight Flush"]) then
            local ace_check = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 14 then
                    ace_check = true
                    break
                end
            end
            if ace_check then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                            key_append = 'vremade_superposition',
                            edition = 'e_negative'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                            key_append = 'vremade_superposition',
                            edition = 'e_negative'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = '+2 Tarot',
                    colour = G.C.SECONDARY_SET.Tarot,
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker41',
    loc_txt = {
        name = 'Eraser', 
        text = {
            '{C:attention}Destroys{} all cards held in hand',
            'at the end of each {C:attention}Blind'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 3},
    calculate = function(self,card,context)
        if context.end_of_round and not context.retrigger_joker and not context.blueprint then
            for _, playing_card in ipairs(G.hand.cards) do
                SMODS.destroy_cards(playing_card)
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker42',
    loc_txt = {
        name = 'Tennis Ball', 
        text = {
            'If first played hand',
            'is a {C:attention}High Card{}, a',
            'random {C:attention}seal{} is',
            'applied to that card'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 2},
    config = { extra = {
        type = 'High Card'
    }
    },
    loc_vars = function(self,info_queue,card)
        return { vars = {localize(card.ability.extra.type, 'poker_hands') } }
    end,
    calculate = function(self,card,context) 
        if context.first_hand_drawn and not context.blueprint and not context.retrigger_joker then
            local eval = function() return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.before and context.main_eval and G.GAME.current_round.hands_played == 0 and context.scoring_name == card.ability.extra.type and not context.retrigger_joker and not context.blueprint then
            local thingies = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_suit('Hearts') or scored_card:is_suit('Diamonds') or scored_card:is_suit('Clubs') or scored_card:is_suit('Spades') then
                    thingies[#thingies + 1] = scored_card
                    scored_card:set_seal(SMODS.poll_seal({ guaranteed = true, type_key = 'vremade_certificate_seal' }))
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED,
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker43',
    loc_txt = {
        name = 'Woody',
        text = {
            'Create a {C:tarot}Tarot{}, {C:planet}Planet{},',
            'or {C:spectral}Spectral{} card when',
            '{C:attention}Blind{} is selected',
            '{C:inactive}(Must have room)'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 2},
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        local woodynum = math.random(1,3)
        local woodyset = 'Tarot'
        if woodynum == 1 then
            woodyset = ('Tarot')
        end
        if woodynum == 2 then
            woodyset = ('Planet')
        end
        if woodynum == 3 then
            woodyset = ('Spectral')
        end
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.add_card {
                                        set = woodyset,
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end
                            }))
                            SMODS.calculate_effect({ message = '+Consumable', colour = G.C.PURPLE },
                                context.blueprint_card or card)
                            return true
                        end)
                    }))
                end
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker44',
    loc_txt = {
        name = 'Purple Face',
        text = {
            'All played {C:attention}scoring{} cards',
            'get the {C:purple}Purple{} Seal',
            'when scored if its',
            'the {C:attention}first{} played hand'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 4},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS.Purple
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and G.GAME.current_round.hands_played == 0 and not context.blueprint and not context.retrigger_joker then
            local thingies = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_suit('Hearts') or scored_card:is_suit('Diamonds') or scored_card:is_suit('Clubs') or scored_card:is_suit('Spades') then
                    thingies[#thingies + 1] = scored_card
                    scored_card:set_seal("Purple", nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if #thingies > 0 then
                return {
                    message = 'Purple',
                    colour = G.C.PURPLE
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker45',
    loc_txt = {
        name = 'Flower',
        text = {
            'This Joker gains {C:chips}+#2#{}',
            'chips at the {C:attention}end{} of',
            'each round',
            '{C:inactive}(Currently {C:chips}+#1#{}{C:inactive} Chips){}'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 2},
    config = { extra = {
        chips = 0, chips_mod = 15
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.chips, center.ability.extra.chips_mod}}
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
            return {
                card = card,
                message = 'Upgrade!',
                colour = G.C.MULT
            }
        end
        if context.joker_main and card.ability.extra.chips == 0 then
            return {
                shmell == 1
            }
        elseif context.joker_main and card.ability.extra.chips > 0 then
            return {
                card = card,
                chip_mod = card.ability.extra.chips,
                message = '+' .. card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker46',
    loc_txt = {
        name = 'Profily',
        text = {
            "Copies the ability",
            "of the {C:attention}Blueprint{}",
            "to the right"
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 2},
    calculate = function(self,card,context) 
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.name == 'Blueprint' then 
                other_joker = G.jokers.cards[i] 
            end
        end
        return SMODS.blueprint_effect(card, other_joker, context)
    end
 }
  SMODS.Joker{
    key = 'joker47',
    loc_txt = {
        name = 'Pen',
        text = {
            'If {C:attention}poker hand{} is a {C:attention}Royal{}',
            '{C:attention}Flush{}, create a {C:tarot}hanged{}',
            '{C:tarot} man{} and a {C:tarot}death{} card',
            'along with converting all cards',
            '{C:attention}held in hand{} to the played suit',
            '{C:inactive}(Must have room){}'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 4},
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_death
        info_queue[#info_queue + 1] = G.P_CENTERS.c_hanged_man
    end,
    calculate = function(self, card, context)   
        if context.joker_main and next(context.poker_hands["Straight Flush"]) and not context.retrigger_joker and not context.blueprint then
            if #G.consumeables.cards + G.GAME.consumeable_buffer + 1 < G.consumeables.config.card_limit then
                local ace_check = false
                local king_check = false
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 14 then
                        ace_check = true
                        break
                    end
                end
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 13 then
                        king_check = true
                        break
                    end
                end
                if ace_check and king_check then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card({key = "c_death"})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card({key = "c_hanged_man"})
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = '+2 Tarot',
                        colour = G.C.SECONDARY_SET.Tarot,
                    }
                end
            end
        end
        if context.after and context.poker_hands and next(context.poker_hands["Straight Flush"]) and #context.poker_hands['Straight Flush'] > 0 and not context.retrigger_joker and not context.blueprint then
            local flush_cards = context.poker_hands['Straight Flush'][1]
            local example_card = flush_cards[1]
            local ace_check = false
            local king_check = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 14 then
                    ace_check = true
                    break
                end
            end
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 13 then
                    king_check = true
                    break
                end
            end
            if example_card and example_card.base and example_card.base.suit and ace_check and king_check then
                local flush_suit = example_card.base.suit
                for _, c in ipairs(G.hand.cards) do
                    if c and c.base then
                        SMODS.change_base(c, flush_suit)
                        c:juice_up(0.5, 0.5)
                    end
                end
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker48',
    loc_txt = {
        name = 'Coiny',
        text = {
            'Gains {X:mult,C:white}X#1#{} Mult',
            'for each{C:red} Heart{} Card',
            '{s:0.7}(only real ones will get this){}',
            'in your {C:attention}full deck{}',
            '{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 4},
    config = { extra = { 
        Xmult = 0.1, dollars = 10
    }
    },
    loc_vars = function(self,info_queue,center)
        local heart_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:is_suit('Hearts') then heart_tally = heart_tally + 1 end
            end
        end
        return { vars = { center.ability.extra.Xmult, 1 + center.ability.extra.Xmult * heart_tally } }
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local heart_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:is_suit('Hearts') then heart_tally = heart_tally + 1 end
            end
            return {
                Xmult = 1 + card.ability.extra.Xmult * heart_tally,
            }
        end
    end,
    calc_dollar_bonus = function(self, card)
        local hasnickel = false
        for i, joker in ipairs(G.jokers.cards) do
            if G.jokers.cards[i].config.center.loc_txt ~= nil then
                if G.jokers.cards[i].config.center.loc_txt.name == 'Nickel' then
                    hasnickel = true
                    break
                end
            end
        end
        if hasnickel then 
            return card.ability.extra.dollars
        end
    end,
    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if playing_card:is_suit('Hearts') then
                return true
            end
        end
        return false
    end
 }
  SMODS.Joker{
    key = 'joker49',
    loc_txt = {
        name = 'Pin',
        text = {
            '{C:attention}Doubles{} the score',
            'requirement for each',
            'blind, but {C:attention}doubles{}',
            'the end of round',
            'cash as well',
            "{s:0.8,C:inactive}(Can't double interest){}"
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 4},
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.blind.chips = G.GAME.blind.chips / 2
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        G.GAME.blind:wiggle()
    end,
    calculate = function(self,card,context) 
        if context.setting_blind and not context.blueprint and not context.retrigger_joker then
            G.GAME.blind.chips = G.GAME.blind.chips * 2
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.GAME.blind:wiggle()
            return {
                message = 'Double!',
                colour = G.C.MULT
            }
        end
    end
}
  SMODS.Joker{
    key = 'joker50',
    loc_txt = {
        name = 'Firey', 
        text = {
            "If {C:attention}first discard{} of round",
            "has only {C:attention}1{} card, destroy",
            "it and gain {C:mult}+5{} Mult",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 1},
    config = { extra = { mult = 0, mult_mod = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        if context.discard and not context.blueprint and not context.retrigger_joker and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
            return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        card.ability.extra.mult = card.ability.extra.mult +
                                            card.ability.extra.mult_mod
                                        return true
                                    end
                                }))
                                SMODS.calculate_effect(
                                    {
                                        message = localize { type = 'variable', key = 'a_mult', vars = {
                                        card.ability.extra.mult_mod } }
                                    }, card
                                )
                                return true
                            end
                        }))
                    end,
                remove = true
                }
            end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker51',
    loc_txt = {
        name = 'Ice Cube',
        text = {
            'This Joker gives',
            '{C:chips}+2{} Hands the {C:attention}hand{}',
            '{C:attention}before{} the final',
            'hand with a',
            '{C:green}#2# in #3#{} chance of',
            '{S:1.1,C:red,E:2}self destructing{}',
            'each trigger'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 4},
    config = { extra = {
        hands = 2, odds = 2
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.hands, (G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds}}
    end,
    calculate = function(self,card,context) 
        if context.joker_main and G.GAME.current_round.hands_left == 1 and not context.blueprint and not context.retrigger_joker then
            if pseudorandom('vremade_gros_michel') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                ease_hands_played(card.ability.extra.hands)
                                SMODS.calculate_effect(
                                    { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                                    context.blueprint_card or card)
                                return true
                            end
                        }))
                    end,
                    message = 'Shattered!',
                    colour = G.C.MULT
                }
            else
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                ease_hands_played(card.ability.extra.hands)
                                SMODS.calculate_effect(
                                    { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                                    context.blueprint_card or card)
                                return true
                            end
                        }))
                    end,
                    message = 'Revenge!',
                    colour = G.C.CHIPS
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker52',
    loc_txt = {
        name = 'Spongy',
        text = {
            '{C:red}+#1#{} Mult',
            'Creates a {C:dark_edition}negative{}',
            'duplicate of itself',
            'at the {C:attention}end of the round{}'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 2,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 5},
    config = { extra = {
        mult = 2
    }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
            card = card,
            mult_mod = card.ability.extra.mult,
            message = '+' .. card.ability.extra.mult .. ' Mult',
            colour = G.C.MULT
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval then
            SMODS.add_card ({
                set = 'Joker',
                key = 'j_BFDI_joker77',
                edition = 'e_negative'
            })
        end
    end
 }
  SMODS.Joker{
    key = 'joker53',
    loc_txt = {
        name = 'Pencil',
        text = {
            'When a {C:planet}Planet{} card',
            'is used, level up that',
            'hand an additional',
            '{C:attention}5{} times then',
            '{C:red,E:2}self destruct{}'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 5},
    calculate = function(self,card,context) 
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' and not context.blueprint and not context.retrigger_joker then
            if context.consumeable.config.center.key == "c_pluto" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'High Card'
                }
            end
            if context.consumeable.config.center.key == "c_mercury" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Pair'
                }
            end
            if context.consumeable.config.center.key == "c_uranus" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Two Pair'
                }
            end 
            if context.consumeable.config.center.key == "c_venus" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Three of a Kind'
                }
            end
            if context.consumeable.config.center.key == "c_saturn" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Straight'
                }
            end
            if context.consumeable.config.center.key == "c_jupiter" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Flush'
                }
            end
            if context.consumeable.config.center.key == "c_earth" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Full House'
                }
            end
            if context.consumeable.config.center.key == "c_mars" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Four of a Kind' 
                }
            end
            if context.consumeable.config.center.key == "c_neptune" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Straight Flush' 
                }
            end
            if context.consumeable.config.center.key == "c_planet_x" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Five of a Kind' 
                }
            end
            if context.consumeable.config.center.key == "c_ceres" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Flush Five' 
                }
            end
            if context.consumeable.config.center.key == "c_eris" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = '+5 Levels!',
                    level_up = 5, level_up_hand = 'Flush House' 
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker54',
    loc_txt = {
        name = 'Needle', 
        text = {
            '{C:attention}Steel Cards{} grant {X:red,C:white} X1.25{}',
            'Mult when scored and when',
            '{C:attention}Blind{} is selected, {C:green}#3# in #4#{}',
            'chance to gain {C:blue}+3{} Hands'

        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 0},
    config = { extra = {
        hands = 3, Xmult = 1.25, odds = 4
    }
    },
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
        return {vars = {card.ability.extra.hands, card.ability.extra.Xmult, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds}}
    end,
    calculate = function(self,card,context)
        if context.setting_blind and (pseudorandom('vremade_8_ball') < G.GAME.probabilities.normal / card.ability.extra.odds) then
            return {
                func = function()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_hands_played(card.ability.extra.hands)
                        SMODS.calculate_effect(
                            { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                            context.blueprint_card or card)
                        return true
                    end
                }))
            end
            }
        end 
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_steel') then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
 }
 SMODS.Joker{
    key = 'joker55',
    loc_txt = {
        name = 'Golf Ball', 
        text = {
            'Retrigger each',
            'played {C:attention}Glass Card'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 9,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 0},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
    end,
    config = { extra = {
        repetitions = 1
    }
    },
    calculate = function(self,card,context)
        if context.repetition and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, 'm_glass') then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker56',
    loc_txt = {
        name = 'Match',
        text = {
            'This Joker gains',
            '{X:mult,C:white}X#2#{} Mult when each',
            'played {C:red}Heart{} Card is scored',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 5},
    config = { extra = {
        Xmult = 1, Xmult_mod = 0.05
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult, center.ability.extra.Xmult_mod}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit('Hearts') and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.XMULT,
                message_card = card
            }
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker57',
    loc_txt = {
        name = 'Bubble', 
        text = {
            'This Joker gains',
            '{X:mult,C:white}X#2#{} Mult at the {C:attention}end{}',
            'of every round',
            '{C:green}#3# in #4#{} chance this',
            'card is destroyed',
            'at end of round,',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{}{C:inactive} Mult)'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 5},
    config = { extra = {
        Xmult = 1, Xmult_mod = 2, odds = 2
    }
    },
    loc_vars = function(self,info_queue,center)
        return { 
           vars = { 
                center.ability.extra.Xmult, 
                center.ability.extra.Xmult_mod,
                (G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.extra.odds 
           }
      }
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if pseudorandom('vremade_gros_michel') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = 'Popped!'
                }
            else
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.Xmult == 1 then
            return {
                shmell == 1
            }
        elseif context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult .. ' Mult',
                colour = G.C.MULT
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker58',
    loc_txt = {
        name = 'Leafy',
        text = {
            '{C:green}#2# in #3#{} chance',
            'to retrigger any',
            '{C:common}Common{} Jokers'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 5},
    config = { extra = {
        repetitions = 1, odds = 5
    }
    },
    loc_vars = function(self,info_queue,center)
        return { 
           vars = { 
                center.ability.extra.repetitions, 
                (G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.extra.odds
           }
      }
    end,
    calculate = function(self,card,context) 
        if context.retrigger_joker_check and context.other_card.config.center.rarity == 1 then
            if context.retrigger_joker_check and (pseudorandom('vremade_8_ball') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                return {
                    repetitions = 1
                }
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker76',
    loc_txt = {
        name = 'Root Two', 
        text = {
            'Played {C:attention}4s{} and {C:attention}9s',
            'give {X:red,C:white} X1.5 {} Mult when scored'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 7},
    config = { extra = {
        Xmult = 1.5
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.Xmult}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == 4 or context.other_card:get_id() == 9) then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker59',
    loc_txt = {
        name = 'TV',
        text = {
            'Retrigger each',
            '{C:attention}compatible{} {C:uncommon}Uncommon{} Joker'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 11,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 4},
    config = { extra = {
        repetitions = 1
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.repetitions}}
    end,
    calculate = function(self,card,context) 
        if context.retrigger_joker_check and context.other_card.config.center.rarity == 2 then 
            return {
                repetitions = 1
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker60',
    loc_txt = {
        name = 'Evil Leafy',
        text = {
            'This Joker has a {C:green}#2# in #3#{}',
            'chance to {C:attention}destroy{} any scored',
            'cards at the end of scoring',
            'adding a {C:attention}tenth{} of the destroyed',
            'cards value to this Jokers {X:mult,C:white}Xmult{}',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult){}'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 5},
    config = { extra = {
        Xmult = 1, odds = 10
    }
    },
    loc_vars = function(self,info_queue,center)
        return { 
           vars = { 
                center.ability.extra.Xmult, 
                (G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.extra.odds
           }
      }
    end,
    calculate = function(self,card,context) 
        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            if context.destroy_card and (pseudorandom('vremade_8_ball') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                local temp_ID = context.destroy_card.base.nominal
                card.ability.extra.Xmult = card.ability.extra.Xmult + (temp_ID / 10)
                return {
                    message = '+' .. (temp_ID / 10) .. 'Xmult!',
                    colour = G.C.MULT,
                    remove = true
                }
            end
        end
        if context.joker_main and card.ability.extra.Xmult == 1 then
            return {
                shmell == 1
            }
        elseif context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult .. ' Mult',
                colour = G.C.MULT
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker61',
    loc_txt = {
        name = 'Yellow Face',
        text = {
            'When held gives a',
            '{C:attention}25%{} discount on',
            'all items in shop',
            'as well as giving',
            'a coupon tag when',
            '{C:attention}Boss Blind{} is defeated'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 5},
    config = { extra = {
        discount = 25
    }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = { key = 'tag_coupon', set = 'Tag' }
        return {vars = {center.ability.extra.discount}}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
        G.GAME.discount_percent = G.GAME.discount_percent + 25
        for k, v in pairs(G.I.CARD) do
            if v.set_cost then v:set_cost() end
        end
        return true end }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({func = function()
        G.GAME.discount_percent = G.GAME.discount_percent - 25
        for k, v in pairs(G.I.CARD) do
            if v.set_cost then v:set_cost() end
        end
        return true end }))
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false and context.main_eval and G.GAME.blind.boss then
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            add_tag(Tag('tag_coupon'))
                            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                            return true
                        end)
                    }))
                end,
                message = 'Coupon!'
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker62',
    loc_txt = {
        name = 'Ruby',
        text = {
            'When {C:attention}Blind{} is selected',
            '{C:green}#9# in #10#{} chance that',
            'this Joker either gains',
            'between {C:attention}+10{} or {C:attention}+30{} {C:mult}Mult{}',
            'or {C:chips}Chips{} or between',
            '{C:attention}+1{} or {C:attention}+3{} {X:mult,C:white}Xmult{} or {C:money}end{}',
            '{C:money}of round cash{}',
            '{C:inactive}(Currently {C:mult}+#1#{}{C:inactive} mult, {}{C:chips}+#2#{}{C:inactive} chips,{}',
            '{X:mult,C:white}X#3#{C:inactive} Mult, and {C:money}$#4#{}{C:inactive}){}'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 6},
    config = { extra = {
        mult = 0, chips = 0, Xmult = 1, dollars = 0, mult_mod = 10, chips_mod = 10, Xmult_mod = 1, increase = 1, odds = 3
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.mult, center.ability.extra.chips, center.ability.extra.Xmult, center.ability.extra.dollars, center.ability.extra.mult_mod, center.ability.extra.chips_mod, center.ability.extra.Xmult_mod, center.ability.extra.increase, (G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds }}
    end,
    calculate = function(self,card,context)
        if context.setting_blind and (pseudorandom('vremade_8_ball') < G.GAME.probabilities.normal / card.ability.extra.odds) and not context.blueprint and not context.retrigger_joker then
            local ruby_num = math.random(1, 4)
            local ruby_random = math.random(1, 3)
            if ruby_num == 1 then
                local ruby_mult = ruby_random * 10
                card.ability.extra.mult_mod = ruby_mult
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    card = card,
                    message = '+' .. card.ability.extra.mult_mod .. ' mult',
                    colour = G.C.MULT
                }
            end
            if ruby_num == 2 then
                local ruby_chips = ruby_random * 10
                card.ability.extra.chips_mod = ruby_chips
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
                return {
                    card = card,
                    message = '+' .. card.ability.extra.chips_mod .. ' chips',
                    colour = G.C.CHIPS
                }
            end
            if ruby_num == 3 then
                card.ability.extra.Xmult_mod = ruby_random
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                return {
                    card = card,
                    message = '+' .. card.ability.extra.Xmult_mod .. ' Xmult',
                    colour = G.C.MULT
                }
            end
            if ruby_num == 4 then
                card.ability.extra.increase = ruby_random
                card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.increase
                return {
                    card = card,
                    message = '+' .. card.ability.extra.increase .. ' dollars',
                    colour = G.C.MONEY
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                Xmult = card.ability.extra.Xmult
            }
        end
    end,
    calc_dollar_bonus = function(self, card)
    local shmell = 0
        if card.ability.extra.dollars == 0 then
            shmell = shmell + 1
        else
            return card.ability.extra.dollars
        end
    end
 }
  SMODS.Joker{
    key = 'joker63',
    loc_txt = {
        name = 'Puffball', 
        text = {
            'Disables effect of',
            'every {C:attention}Boss Blind{}',
            'with a debuffing effect'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 6},
    calculate = function(self,card,context)  
        if context.setting_blind and not context.blueprint and context.blind.boss and not context.retrigger_joker then
            if G.GAME.blind.name == 'The Pillar' or G.GAME.blind.name == 'Verdant Leaf' or G.GAME.blind.name == 'The Club' or G.GAME.blind.name == 'The Goad' or G.GAME.blind.name == 'The Window' or G.GAME.blind.name == 'The Plant' or G.GAME.blind.name == 'The Head' then
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        G.GAME.blind:disable()
                                        play_sound('timpani')
                                        delay(0.4)
                                        return true
                                    end
                                }))
                                SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            if G.GAME.blind.name == 'The Pillar' or G.GAME.blind.name == 'Verdant Leaf' or G.GAME.blind.name == 'The Club' or G.GAME.blind.name == 'The Goad' or G.GAME.blind.name == 'The Window' or G.GAME.blind.name == 'The Plant' or G.GAME.blind.name == 'The Head' then
                G.GAME.blind:disable()
                play_sound('timpani')
                SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker64',
    loc_txt = {
        name = 'Gelatin',
        text = {
            'This Joker gains {C:money}$#2#{}',
            'Dollars of end of',
            'round cash at the',
            '{C:attention}end{} of each round',
            '{C:inactive}(Currently {C:money}$#1#{}{C:inactive} Dollars){}'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 6},
    config = { extra = {
        dollars = 0, increase = 2
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.dollars, center.ability.extra.increase}}
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.increase
            return {
                card = card,
                message = 'Upgrade!',
                colour = G.C.MONEY
            }
        end
    end,
    calc_dollar_bonus = function(self, card)
    local shmell = 0
        if card.ability.extra.dollars == 0 then
            shmell = shmell + 1
        else
            return card.ability.extra.dollars
        end
    end
 }
  SMODS.Joker{
    key = 'joker65',
    loc_txt = {
        name = 'Fries',
        text = {
            'When {C:attention}Blind{} is won,',
            'gives a {C:attention}random{} tag',
            '{s:0.7,C:inactive}(Better get digging. The tags{}',
            '{s:0.7,C:inactive}are probably underground.){}'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 6},
    calculate = function(self,card,context)
        if context.end_of_round and context.game_over == false then
            local fries_tag = math.random(1,23)
            local tag_var = tag_uncommon
            if fries_tag == 1 then
                tag_var = ('tag_uncommon')
            end
            if fries_tag == 2 then
                tag_var = ('tag_rare')
            end
            if fries_tag == 3 then
                tag_var = ('tag_negative')
            end
            if fries_tag == 4 then
                tag_var = ('tag_foil')
            end
            if fries_tag == 5 then
                tag_var = ('tag_holo')
            end
            if fries_tag == 6 then
                tag_var = ('tag_polychrome')
            end
            if fries_tag == 7 then
                tag_var = ('tag_investment')
            end
            if fries_tag == 8 then
                tag_var = ('tag_voucher')
            end
            if fries_tag == 9 then
                tag_var = ('tag_boss')
            end
            if fries_tag == 10 then
                tag_var = ('tag_standard')
            end
            if fries_tag == 11 then
                tag_var = ('tag_charm')
            end
            if fries_tag == 12 then
                tag_var = ('tag_meteor')
            end
            if fries_tag == 13 then
                tag_var = ('tag_buffoon')
            end
            if fries_tag == 14 then
                tag_var = ('tag_handy')
            end
            if fries_tag == 15 then
                tag_var = ('tag_garbage')
            end
            if fries_tag == 16 then
                tag_var = ('tag_ethereal')
            end
            if fries_tag == 17 then
                tag_var = ('tag_coupon')
            end
            if fries_tag == 18 then
                tag_var = ('tag_double')
            end
            if fries_tag == 19 then
                tag_var = ('tag_juggle')
            end
            if fries_tag == 20 then
                tag_var = ('tag_d_six')
            end
            if fries_tag == 21 then
                tag_var = ('tag_top_up')
            end
            if fries_tag == 22 then
                tag_var = ('tag_skip')
            end
            if fries_tag == 23 then
                tag_var = ('tag_economy')
            end
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            add_tag(Tag(tag_var))
                            play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                            return true
                        end)
                    }))
                end,
                message = 'Better get digging'
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker66',
    loc_txt = {
        name = 'Dora', 
        text = {
            'This Joker gains {X:mult,C:white}X#2#{}',
            'Mult whenever a {C:attention}Stone{}',
            '{C:attention}Card{} is triggered',
            '{C:green}#4# in #5#{} chance to destroy',
            'said {C:attention}card{}, adding {X:mult,C:white}X#3#{}',
            'Mult to the amount this',
            'Joker gains per triggered',
            '{C:attention}Stone Card{}',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult){}'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 4, y = 6},
    config = { extra = {
        Xmult = 1, Xmult_mod = 0.05, Xmult_mod_mod = 0.05, odds = 5
    }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { 
           vars = { 
                center.ability.extra.Xmult, 
                center.ability.extra.Xmult_mod,
                center.ability.extra.Xmult_mod_mod,
                (G.GAME and G.GAME.probabilities.normal or 1),
                center.ability.extra.odds
           }
      }
    end,
    calculate = function(self,card,context)
        if self.debuff then return nil end
        if context.individual and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            if SMODS.has_enhancement(context.other_card, 'm_stone') then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                        message_card = card
                }
            end
        end
        if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            if SMODS.has_enhancement(context.destroy_card, 'm_stone') then
                if context.destroy_card and (pseudorandom('vremade_8_ball') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                    card.ability.extra.Xmult_mod = card.ability.extra.Xmult_mod + card.ability.extra.Xmult_mod_mod
                    return {
                        message = 'Eaten!',
                        colour = G.C.BROWN,
                        remove = true
                    }
                end
            end
        end
        if context.joker_main and card.ability.extra.Xmult == 1 then
            return {
                shmell == 1
            }
        elseif context.joker_main and card.ability.extra.Xmult > 1 then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult .. ' Mult',
                colour = G.C.MULT
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker67',
    loc_txt = {
        name = 'Donut', 
        text = {
            'Played {C:attention}10s {}give',
            '{X:red,C:white}X2 {} Mult when scored, and',
            '{X:red,C:white}X20 {} Mult if {C:purple}Four {}and {C:purple}X {}are held'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 9,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 0, y = 7},
    config = { extra = {
        Xmult = 2
    }
    },
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.Xmult}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 10 then
                local has4 = false
                local hasX = false
                for i, jokers in ipairs(G.jokers.cards) do
                    if G.jokers.cards[i].config.center.loc_txt ~= nil then
                        if G.jokers.cards[i].config.center.loc_txt.name == 'Four' then
                            has4 = true
                        end
                        if G.jokers.cards[i].config.center.loc_txt.name == 'X' then
                            hasX = true
                        end
                    end
                end
                if hasX and has4 then
                    return {
                        Xmult = card.ability.extra.Xmult * 10
                    }
                else
                    return {
                        Xmult = card.ability.extra.Xmult
                    }
                end
            end
        end
    end
 }
  SMODS.Joker{
    key = 'joker68',
    loc_txt = {
        name = 'Nickel',
        text = {
            'Gives {C:chips}+#1#{} Chips',
            'for each{C:spades} Spade{} Card',
            'in your {C:attention}full deck{}',
            '{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 1, y = 7},
    config = { extra = { 
        chips = 15, dollars = 10
    }
    },
    loc_vars = function(self,info_queue,center)
        local spade_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:is_suit('Spades') then spade_tally = spade_tally + 1 end
            end
        end
        return { vars = { center.ability.extra.chips, center.ability.extra.chips * spade_tally } }
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local spade_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:is_suit('Spades') then spade_tally = spade_tally + 1 end
            end
            return {
                chips = card.ability.extra.chips * spade_tally,
            }
        end
    end,
    calc_dollar_bonus = function(self, card)
        local hascoiny = false
        for i, jokers in ipairs(G.jokers.cards) do
            if G.jokers.cards[i].config.center.loc_txt ~= nil then
                if G.jokers.cards[i].config.center.loc_txt.name == 'Coiny' then
                    hascoiny = true
                    break
                end
            end
        end
        if hascoiny then
            return card.ability.extra.dollars
        end
    end,
    in_pool = function(self, args)
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if playing_card:is_suit('Spades') then
                return true
            end
        end
        return false
    end
 }
  SMODS.Joker{
    key = 'joker69',
    loc_txt = {
        name = 'Book',
        text = {
            'Retrigger each',
            'played {C:attention}Lucky Card{}',
            'and give {C:mult}+15{} Mult',
            'and {C:money}$3{} each time',
            'a Lucky Card {C:attention}hits{}',
            "{s:0.7,C:inactive}(Well I'm actually a{}",
            "{s:0.7,C:inactive}Lucky Card handbook...){}"

        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 2, y = 7},
    config = { extra = {
        mult = 15, dollars = 3, repetitions = 1
    }
    },
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        return {vars = {center.ability.extra.mult, center.ability.extra.dollars}}
    end,
    calculate = function(self,card,context) 
        if context.repetition and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, 'm_lucky') then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
        if context.individual and context.other_card.lucky_trigger then
            return {
                dollars = card.ability.extra.dollars,
                mult = card.ability.extra.mult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker70',
    loc_txt = {
        name = 'Bomby',
        text = {
            'Every played {C:attention}card{}',
            'permanently gains',
            '{C:red}+2{} Mult when scored'
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 3, y = 7},
    config = { extra = { mult = 2 } },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult
            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
                card = card
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker71',
    loc_txt = {
        name = 'One',
        text = {
            'If a {C:attention}#5#{} is',
            'played then destroy',
            'both cards and {C:attention}gain{}',
            '{X:chips,C:white}X#2#{} Chips for each',
            'card destroyed',
            '{C:inactive}(Currently {X:chips,C:white}X#1#{} {C:inactive}Chips){}'
        }
    },
    atlas = 'Jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 5, y = 6},
    soul_pos = {x = 5, y = 7},
    config = { extra = {
        x_chips = 1, x_chips_mod = 0.25, odds = 1, type = 'Pair'
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.x_chips, center.ability.extra.x_chips_mod, (G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds, localize(center.ability.extra.type, 'poker_hands')}}
    end,
    calculate = function(self,card,context) 
        if context.scoring_name == card.ability.extra.type then
            if context.destroy_card and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
                if context.destroy_card and (pseudorandom('vremade_8_ball') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                    card.ability.extra.x_chips = card.ability.extra.x_chips + card.ability.extra.x_chips_mod
                    return {
                        message = 'Deal!',
                        colour = G.C.CHIPS,
                        remove = true
                    }
                end
            end
        end
        if context.joker_main then
            return {
                x_chips = card.ability.extra.x_chips
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker72', 
    loc_txt = {
        name = 'Two', 
        text = {
            '{C:green}^2{} Mult'
        }
    },
    atlas = 'Jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 6, y = 6},
    soul_pos = {x = 6, y = 7},
    config = { extra = { 
        Emult = 2
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Emult}}
    end,
    calculate = function(self,card,context) 
        if context.joker_main then
            return {
                card = card,
                Emult_mod = card.ability.extra.Emult,
                message = '^' .. card.ability.extra.Emult,
                colour = G.C.SECONDARY_SET.Spectral
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker73',
    loc_txt = {
        name = 'Four', 
        text = {
            'This Joker gains {X:mult,C:white}X0.4{} Mult',
            'if played hand has',
            'exactly {C:attention}4{} cards',
            '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)'
        }
    },
    atlas = 'Jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 8, y = 6},
    soul_pos = {x = 8, y = 7},
    config = { extra = {
        Xmult_mod = 0.4, Xmult = 1
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult}}
    end,
    calculate = function(self,card,context) 
        if context.before and context.main_eval and not context.blueprint and not context.retrigger_joker and #context.full_hand == 4 then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker74',
    loc_txt = {
        name = 'X', 
        text = {
            'Gives a {C:attention}random{}',
            'multiplier between',
            '{X:mult,C:white}x5{} and {X:mult,C:white}x30{} Mult'
        }
    },
    atlas = 'Jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 7, y = 6},
    soul_pos = {x = 7, y = 7},
    config = { extra = { max = 30, min = 5 } },
    loc_vars = function(self, info_queue, card)
        local r_mults = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_mults[#r_mults + 1] = tostring(i)
        end
    end,
    calculate = function(self, card, context) 
        if context.joker_main then
            return {
                Xmult = pseudorandom('vremade_misprint', card.ability.extra.min, card.ability.extra.max)
            }
        end
    end
 }
  SMODS.Joker{
    key = 'joker75',
    loc_txt = {
        name = 'Announcer',
        text = {
            'If {C:attention}poker hand{}',
            'contains a {C:attention}Flush{} of',
            '{V:1}#2#s{} then make',
            'each scored card',
            '{C:attention}Polychrome{} and {C:attention}Lucky{}',

        }
    },
    atlas = 'Jokers',
    rarity = 4,
    cost = 20,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pos = {x = 9, y = 6},
    soul_pos = {x = 9, y = 7},
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        local suit = (G.GAME.current_round.vremade_ancient_card or {}).suit or 'Spades'
        return { vars = { localize('Flush','poker_hands'), localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] } } }
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint and not context.retrigger_joker and (next(context.poker_hands['Flush']) or next(context.poker_hands['Straight Flush']) or next(context.poker_hands['Flush House']) or next(context.poker_hands['Flush Five'])) then
            local suits = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_suit(G.GAME.current_round.vremade_ancient_card.suit, nil, true) then
                    suits[#suits + 1] = scored_card
                    scored_card:set_ability('m_lucky', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:set_edition('e_polychrome', nil, true)
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if #suits > 0 then
                return {
                    message = 'Wow!',
                    colour = G.C.MULT
                }
            end
        end
    end
 }
 SMODS.Joker{
    key = 'joker77',
    loc_txt = {
        name = 'Spongy',
        text = {
            '{C:red}+#1#{} Mult',
            '{C:inactive}(Will not produce duplicates.){}'
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 2,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    no_collection = true,
    in_pool = function(self) return false end,
    pos = {x = 0, y = 5},
    config = { extra = {
        mult = 2
    }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
            card = card,
            mult_mod = card.ability.extra.mult,
            message = '+' .. card.ability.extra.mult .. ' Mult',
            colour = G.C.MULT
            }
        end
    end
 }
 SMODS.Joker{
    key = 'joker78',
    loc_txt = {
        name = 'Liy',
        text = {
            '{X:mult,C:white}X3{} Mult',
            'Every {C:attention}5{} hands played',
            'this Joker {C:attention}flips her switch{}',
            '{C:inactive}#5# remaining{}',
            '{s:0.7,C:inactive}(But why, Liy?){}'
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    no_collection = true,
    in_pool = function(self) return false end,
    pos = {x = 1, y = 8},
    config = { extra = {
        mult = 6, chips = 18, Xmult = 3, hands = 0, hands_remaining = 5
    }
    },
    loc_vars = function(self,info_queue,center)
        return {
            vars = {
                center.ability.extra.mult,
                center.ability.extra.chips, 
                center.ability.extra.Xmult,
                center.ability.extra.hands,
                center.ability.extra.hands_remaining
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.hands_remaining = card.ability.extra.hands_remaining - 1
            if card.ability.extra.hands_remaining == 0 then
                if card.ability.extra.hands_remaining == 0 then
                    card:set_ability("j_BFDI_joker35")
                    return {
                        Xmult = card.ability.extra.Xmult,
                        message = 'Flip!'
                    }
                end
            end
        end
        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
 }
local mod_path = "" .. SMODS.current_mod.path
local function reset_vremade_ancient_card()
    G.GAME.current_round.vremade_ancient_card = G.GAME.current_round.vremade_ancient_card or { suit = 'Spades' }
    local ancient_suits = {}
    for k, v in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
        if v ~= G.GAME.current_round.vremade_ancient_card.suit then ancient_suits[#ancient_suits + 1] = v end
    end
    local ancient_card = pseudorandom_element(ancient_suits, pseudoseed('vremade_ancient' .. G.GAME.round_resets.ante))
    G.GAME.current_round.vremade_ancient_card.suit = ancient_card
end
function SMODS.current_mod.reset_game_globals(run_start)
    reset_vremade_ancient_card()
end
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end
local oldaddroundevalrow = add_round_eval_row
function add_round_eval_row(config)
    config = config or {}
    if config.dollars and next(SMODS.find_card("j_BFDI_joker49")) then config.dollars = config.dollars * 2 end
    return oldaddroundevalrow(config)
end
local files = NFS.getDirectoryItems(mod_path .. "libs/")
for _, file in ipairs(files) do
	print("[BFDI] Loading lib file " .. file)
	local f, err = SMODS.load_file("libs/" .. file)
	if err then
		error(err) 
	end
	f()
end
local creditspage = {
        "WusGud",
        "Mod Director, Coder, and Creator",
		"",
        "NitroPixel3783",
        "Co-creator, and Coder",
		"",
        "Caldox, Kazt",
        "Art",
		"",
		"Cyber98",
        "Code Contributions",
		"",
		"MilkChan, ☆Melody☆",
        "MANY idea contributions (thank you again)",
		"",
        "Daxton, Mr. 2 Xs, my dad, MilkChan",
        "Playtesting",
    }

SMODS.current_mod.extra_tabs = function() --Credits tab
    local scale = 0.5
    return {
        label = "Credits",
        tab_definition_function = function()
        return {
            n = G.UIT.ROOT,
            config = {
            align = "cm",
            padding = 0.05,
            colour = G.C.CLEAR,
            },
            nodes = {
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Creator, Mod Director, and  Coder:",
                    shadow = false,
                    scale = scale*0.66,
                    colour = G.C.INACTIVE
                    }
                },
                }
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "WusGud",
                    shadow = false,
                    scale = scale*1,
                    colour = G.C.ORANGE
                    }
                }
                }
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Co-creator, and Coder:",
                    shadow = false,
                    scale = scale*0.66,
                    colour = G.C.INACTIVE
                    }
                },
                }
            },
            {
                n = G.UIT.R,
                config = {
                    padding = 0,
                    align = "cm"
                },
                nodes = {
                    {
                    n = G.UIT.T,
                    config = {
                        text = "NitroPixel3783",
                        shadow = false,
                        scale = scale,
                        colour = G.C.PURPLE
                    }
                    },
                }
                },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Artwork:",
                    shadow = false,
                    scale = scale*0.66,
                    colour = G.C.INACTIVE
                    }
                }
                },
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Caldox, Kazt",
                    shadow = false,
                    scale = scale,
                    colour = G.C.GREEN
                    }
                }
                } 
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "MANY Idea Contributions (Thank You Again!):",
                    shadow = false,
                    scale = scale*0.66,
                    colour = G.C.INACTIVE
                    }
                }
                } 
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "MilkChan, ☆Melody☆",
                    shadow = false,
                    scale = scale*1,
                    colour = G.C.RED
                    }
                }
                } 
            },
			{
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Playtesters:",
                    shadow = false,
                    scale = scale*0.66,
                    colour = G.C.INACTIVE
                    }
                }
                } 
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "Daxton, Mr. 2 Xs, My Dad, MilkChan",
                    shadow = false,
                    scale = scale*0.66,
                    colour = G.C.BLUE
                    }
                }
                } 
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "My friend for watching BFDI:",
                    shadow = false,
                    scale = scale*0.66,
                    colour = G.C.INACTIVE
                    }
                }
                } 
            },
            {
                n = G.UIT.R,
                config = {
                padding = 0,
                align = "cm"
                },
                nodes = {
                {
                    n = G.UIT.T,
                    config = {
                    text = "JMFTx3",
                    shadow = false,
                    scale = scale*1,
                    colour = G.C.MONEY
                    }
                }
                } 
            },
            {
            n = G.UIT.R,
            config = {
              padding = 0.2,
              align = "cm",
            },
            nodes = {
              UIBox_button({
                minw = 3.85,
                button = "BFJ_Youtube",
                label = {"Youtube"}
              }),
              UIBox_button({
                minw = 3.85,
                colour = HEX("9656ce"),
                button = "BFJ_Discord",
                label = {"Discord"}
              })
            },
          },
        },
      }
    end
  }
end
function G.FUNCS.BFJ_Youtube(e)
	love.system.openURL("https://www.youtube.com/@WusGud6")
end
function G.FUNCS.BFJ_Discord(e)
  love.system.openURL("https://discord.gg/sa3uvjKbvs")
end
--test 2