var/datum/antagonist/invasion/invaders

/datum/antagonist/invasion
	id = MODE_INVASION
	role_text = "Invader"
	role_text_plural = "Invaders"
	bantype = "invasion"
	antag_indicator = "invader"
	landmark_id = "invaderstart"
	welcome_text = "You're a Lii'dra Invader! Your Hivenet is separate from the station's Hivenet. Their Vaurcae cannot see yours, and you cannot see theirs."
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

	player.set_species("Lii'dra Warrior")
	player.languages -= /datum/language/bug //No normal hivenet for Lii'dra.
	player.r_skin = 0
	player.b_skin = 0
	player.g_skin = 0

	return 1

/obj/structure/biotank
	name = "biomass tank"
	desc = "This alien tank seems to contain a sinister green liquid."
	climbable = FALSE
	breakable = FALSE
	var/biomass = 3000 //Placeholder value.

/obj/machinery/optable/vivisection
	name = "vivisection table"
	desc = "A high-tech metal slab."
	var/list/ideal_limbs = list() //This list, once generated, contains all the limbs the invaders must take.

/obj/machinery/optable/vivisection/Initialize()
	. = ..()
	generate_ideal_sequence()

/obj/machinery/optable/vivisection/machinery_process()
	if(victim)
		scan_victim()

/obj/machinery/optable/vivisection/proc/scan_victim()
	for(var/obj/item/organ/external/limb in victim.organs)
		if(limb in ideal_limbs)
			visible_message("Ideal limb detected: [limb.name].")

/obj/machinery/optable/vivisection/proc/generate_ideal_sequence()
	var/list/limbs = list(
		"chest",
		"groin",
		"head" ,
		"l_arm",
		"r_arm",
		"l_leg",
		"r_leg",
		"l_hand",
		"r_hand",
		"l_foot",
		"r_foot",
	)

	for(var/limb in limbs)
		var/ideal = pick(playable_species)
		var/datum/species/ideal_species = global.all_species[ideal]
		var/ideal_limb = ideal_species.has_limbs["[limb]"]["path"]
		ideal_limbs += ideal_limb

/obj/machinery/epipod
	name = "epigenetic fuel pod"
	desc = "An incomprehensible fuel pod. You have no idea what's going on in there."
	density = 1
	anchored = 1
	use_power = FALSE
	idle_power_usage = 0
	active_power_usage = 0

/obj/machinery/epipod/Initialize(mapload, d, populate_components = FALSE)
	. = ..()

/obj/machinery/epipod/emp_act(severity)
	return //Nope.

/obj/machinery/epipod/ex_act(severity)
	return //Nope.

/obj/machinery/biocontroller
	name = "central biomass controller"
	desc = "A very complex computer. <b>Just looking at it makes your neurons hurt.</b>"
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = FALSE
	idle_power_usage = 0
	active_power_usage = 0
	var/obj/structure/biotank/tank
	var/obj/machinery/epipod/fuelpod

/obj/machinery/biocontroller/Initialize(mapload, d, populate_components = FALSE)
	. = ..()
	for(var/obj/structure/biotank/newtank in range(1))
		tank = newtank
	
	for(var/obj/machinery/epipod/pod in range(5))
		fuelpod = pod

	if(!fuelpod || !tank)
		qdel(src)

/obj/machinery/biocontroller/machinery_process()
	if(tank)
		tank.biomass -= 50 //Placeholder value.

/obj/machinery/biocontroller/emp_act(severity)
	return //Nope.

/obj/machinery/biocontroller/ex_act(severity)
	return //Nope.