var/datum/antagonist/invasion/invaders

/datum/antagonist/invasion
	id = MODE_INVASION
	role_text = "Invader"
	role_text_plural = "Invaders"
	bantype = "invasion"
	antag_indicator = "invader"
	landmark_id = "invaderstart"
	welcome_text = "Use :H to talk on your encrypted channel."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudinvader"

	hard_cap = 2
	hard_cap_round = 2
	initial_spawn_req = 2
	initial_spawn_target = 2

	faction = "lii'dra"

	id_type = /obj/item/weapon/card/id/syndicate

/datum/antagonist/invasion/New()
	..()
	invaders = src

/datum/antagonist/invasion/update_access(var/mob/living/player)
	for(var/obj/item/weapon/card/id/id in player.contents)
		id.name = "[player.real_name]"
		id.registered_name = player.real_name
		W.name = "[initial(W.name)] ([id.name])"

/datum/antagonist/invasion/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0



	var/new_shoes =   pick(raider_shoes)
	var/new_uniform = pick(raider_uniforms)
	var/new_glasses = pick(raider_glasses)
	var/new_helmet =  pick(raider_helmets)
	var/new_suit =    pick(raider_suits)

	player.equip_to_slot_or_del(new new_shoes(player),slot_shoes)
	if(!player.shoes)
		//If equipping shoes failed, fall back to equipping sandals
		var/fallback_type = pick(/obj/item/clothing/shoes/sandal, /obj/item/clothing/shoes/jackboots/unathi)
		player.equip_to_slot_or_del(new fallback_type(player), slot_shoes)

	player.equip_to_slot_or_del(new new_uniform(player),slot_w_uniform)
	player.equip_to_slot_or_del(new new_glasses(player),slot_glasses)
	player.equip_to_slot_or_del(new new_helmet(player),slot_head)
	player.equip_to_slot_or_del(new new_suit(player),slot_wear_suit)
	equip_weapons(player)

	//Try to equip it, del if we fail.
	var/obj/item/device/contract_uplink/new_uplink = new()
	if (!player.equip_to_appropriate_slot(new_uplink))
		qdel(new_uplink)

	var/obj/item/weapon/card/id/id = create_id("Visitor", player, equip = 0)
	id.name = "[player.real_name]'s Passport"
	id.assignment = "Visitor"
	var/obj/item/weapon/storage/wallet/W = new(player)
	W.handle_item_insertion(id)
	player.equip_to_slot_or_del(W, slot_wear_id)
	spawn_money(rand(50,150)*10,W)
	create_radio(RAID_FREQ, player)

	give_codewords(player)

	return 1