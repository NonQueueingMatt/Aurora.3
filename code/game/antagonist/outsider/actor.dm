GLOBAL_LIST_EMPTY_TYPED(actors, /datum/antagonist/actor)

/datum/antagonist/actor
	id = MODE_ACTOR
	landmark_id = "Actor"
	role_text = "Actor"
	role_text_plural = "Actors"
	welcome_text = "You are an actor in a Mission. Roleplay your heart out."
	faction = "actor"
	landmark_id = "Actor Spawn Landmark"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_HAS_NUKE | ANTAG_SET_APPEARANCE | ANTAG_NO_FLAVORTEXT
	hard_cap = 10
	hard_cap_round = 15

	bantype = "actor"

/datum/antagonist/actor/New()
	..(1)
	GLOB.actors = src
