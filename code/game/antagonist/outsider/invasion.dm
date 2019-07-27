var/datum/antagonist/invasion/invaders

/datum/antagonist/invasion
	id = MODE_INVASION
	role_text = "Invader"
	role_text_plural = "Invaders"
	bantype = "invasion"
	antag_indicator = "invader"
	landmark_id = "invaderstart"
	welcome_text = "Use :H to talk on your encrypted channel."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_VOTABLE | ANTAG_HAS_LEADER
	antaghud_indicator = "hudinvader"

	hard_cap = 2
	hard_cap_round = 2
	initial_spawn_req = 2
	initial_spawn_target = 2

	faction = "lii'dra"

/datum/antagonist/invasion/New()
	..()
	invaders = src

/datum/antagonist/invasion/update_access(var/mob/living/player)
	for(var/obj/item/weapon/card/id/id in player.contents)
		id.name = "[player.real_name]"
		id.registered_name = player.real_name

/datum/antagonist/invasion/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	player.set_species("Vaurca Warrior")

	create_radio(RAID_FREQ, player)

	//MATT-TODO: equip stuff here


	return 1