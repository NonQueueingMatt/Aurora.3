/*
LII'DRA INVASION ROUNDTYPE
*/


/datum/game_mode/invasion
	name = "invasion"
	config_tag = "invasion"
	required_players = 15
	required_enemies = 2
	round_description = "After the attack on Tau Ceti, remnants of the Lii'dra ship have set their sight on the Aurora..."
	extended_round_description = "After the attack upon Tau Ceti, some remnants of the Lii'dra ship have scattered into the stellar void. \
	A small section of the ship did survive the battle, and avoiding detection, silently drifting to the outer sectors of the system. \
	Its passengers are few, with only a few surviving Lii'dra, as well as the living core of the ship, they set their sights upon the Aurora \
	to fulfill their alien, unknowable agenda...."
	end_on_antag_death = 0
	antag_tags = list(MODE_INVASION)

/datum/game_mode/invasion/check_finished()
	//stuff will need to go here
	return ..()
