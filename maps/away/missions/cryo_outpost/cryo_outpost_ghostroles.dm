
// ---------------------- spawners

/datum/ghostspawner/human/cryo_outpost_crew
	short_name = "cryo_outpost_crew"
	name = "Desert Oasis Planet Outpost Crew"
	desc = "\
		You live on a unregistered outpost on some unimportant planet, that is illegally growing vatgrown organs and protohumans. \
		You may be a scientist trying to make some cash outside of megacorp eyes, \
		or a mercenary hired to protect this outpost, or whatever else you can think of.\
		"
	desc_ooc = "\
		This is a event volunteer ghostrole. Do not pick this if you have not volunteered. \
		"
	welcome_message = "\
		You live on a unregistered outpost on some unimportant planet, that is illegally growing vatgrown organs and protohumans. \
		You may be a scientist trying to make some cash outside of megacorp eyes, \
		or a mercenary hired to protect this outpost, or whatever else you can think of.\
		"
	tags = list("External")

	spawnpoints = list("cryo_outpost_crew")
	max_count = 999
	password = "odyssey4life"

	outfit = /obj/outfit/admin/generic/cryo_outpost_crew
	possible_species = list(\
		SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, \
		SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_UNBRANDED, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, \
		SPECIES_DIONA, SPECIES_DIONA_COEUS, \
		SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, \
		SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, \
		SPECIES_UNATHI, \
		SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, \
	)

	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Desert Oasis Planet Outpost Crew"
	special_role = "Desert Oasis Planet Outpost Crew"
	respawn_flag = null

	idris_account_min = 1200
	idris_account_max = 2500

/obj/effect/ghostspawpoint/cryo_outpost_crew
	name = "igs - cryo_outpost_crew"
	identifier = "cryo_outpost_crew"

// ---------------------- outfits

/obj/outfit/admin/generic/cryo_outpost_crew
	name = "Desert Oasis Planet Outpost Crew Uniform"
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/device/radio/headset/syndicate
	l_pocket = /obj/item/device/radio/hailing

/obj/outfit/admin/generic/cryo_outpost_crew/get_id_access()
	return list(
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CRYO_OUTPOST,
	)
