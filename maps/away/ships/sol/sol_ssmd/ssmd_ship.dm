/datum/map_template/ruin/away_site/ssmd_corvette
	name = "Solarian Navy Reconnaissance Corvette"
	description = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."

	prefix = "ships/sol/sol_ssmd/"
	suffix = "ssmd_ship.dmm"

	sectors = list(SECTOR_BADLANDS, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	ship_cost = 1
	id = "ssmd_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ssmd_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/ssmd_corvette
	map = "Sol Recon Corvette"
	descriptor = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."

//areas
/area/ship/ssmd_corvette
	name = "Sol Recon Corvette"
	requires_power = TRUE

/area/ship/ssmd_corvette/bridge
	name = "Sol Recon Corvette Bridge"

/area/ship/ssmd_corvette/hangar
	name = "Sol Recon Corvette Hangar"

/area/ship/ssmd_corvette/starboardengine
	name = "Sol Recon Corvette Starboard Engine"

/area/ship/ssmd_corvette/portengine
	name = "Sol Recon Corvette Port Engine"

/area/ship/ssmd_corvette/synthroom
	name = "Sol Recon Corvette Synthetic Room"

/area/ship/ssmd_corvette/dorms
	name = "Sol Recon Corvette Dorms"

/area/ship/ssmd_corvette/brig
	name = "Sol Recon Corvette Brig"

/area/ship/ssmd_corvette/starboardfoyer
	name = "Sol Recon Corvette Starboard Foyer"

/area/ship/ssmd_corvette/francisca
	name = "Sol Recon Corvette Francisca Gunnery Compartment"

/area/ship/ssmd_corvette/grauwolf
	name = "Sol Recon Corvette Grauwolf Gunnery Compartment"

/area/ship/ssmd_corvette/bathroom
	name = "Sol Recon Corvette Bathroom"

/area/ship/ssmd_corvette/captain
	name = "Sol Recon Corvette Captain's Office"

/area/ship/ssmd_corvette/storage
	name = "Sol Recon Corvette Storage Compartment"

/area/ship/ssmd_corvette/hangar
	name = "Sol Recon Corvette Hangar"

/area/ship/ssmd_corvette/canteen
	name = "Sol Recon Corvette Canteen"

/area/ship/ssmd_corvette/mechbay
	name = "Sol Recon Corvette Mechbay"

/area/ship/ssmd_corvette/medbay
	name = "Sol Recon Corvette Medbay"

/area/ship/ssmd_corvette/cryo
	name = "Sol Recon Corvette Cryogenics"

/area/ship/ssmd_corvette/nuke
	name = "Sol Recon Corvette Reactor Compartment"

/area/ship/ssmd_corvette/portfoyer
	name = "Sol Recon Corvette Port Foyer"

/area/shuttle/ssmd_shuttle
	name = "Recon Corvette Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/ssmd_corvette
	name = "Solarian Navy Reconnaissance Corvette"
	class = "SAMV"
	desc = "A long-range reconnaissance corvette design in use by the Solarian Navy, the Uhlan-class is a relatively costly and somewhat uncommon ship to be seen in the Alliance's fleets, and is typically reserved for more elite (or at least better equipped and trained) units. Designed to operate alone or as part of a small task force with minimal support in unfriendly space, it is most commonly seen assigned to probing, surveillance, harassment, and strike operations. \
	In spite of its small size, the Uhlan has relatively generous crew facilities and it is well-armed relative to its size and role, all made possible by extensive automation."
	icon_state = "corvette"
	moving_state = "corvette_moving"
	colors = list("#9dc04c", "#52c24c")
	scanimage = "corvette.png"
	designer = "Solarian Navy"
	volume = "41 meters length, 43 meters beam/width, 19 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding fore caliber ballistic armament, fore obscured flight craft bay"
	sizeclass = "Uhlan-class Corvette"
	shiptype = "Military reconnaissance and extended-duration combat utility"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"SSMD Shuttle" = list("nav_hangar_ssmd")
	)

	initial_generic_waypoints = list(
		"nav_ssmd_corvette_1",
		"nav_ssmd_corvette_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/ssmd_corvette/New()
	designation = "[pick("Asparuh", "Magyar", "Hussar", "Black Army", "Hunyadi", "Piast", "Hussite", "Tepes", "Komondor", "Turul", "Vistula", "Sikorski", "Mihai", "Blue Army", "Strzyga", "Leszy", "Danube", "Sokoly", "Patriotism", "Duty", "Loyalty", "Florian Geyer", "Pilsudski", "Chopin", "Levski", "Valkyrie", "Tresckow", "Olbricht", "Dubcek", "Kossuth", "Nagy", "Clausewitz", "Poniatowski", "Orzel", "Turul", "Skanderbeg", "Ordog", "Perun", "Poroniec", "Klobuk", "Cavalryman", "Szalai's Own", "Upior", "Szalai's Pride", "Kuvasz", "Fellegvar", "Nowa Bratislawa", "Zbior", "Stadter", "Homesteader", "Premyslid", "Bohemia", "Discipline", "Cavalryman", "Order", "Law", "Tenacity", "Diligence", "Valiant", "Konik", "Victory", "Triumph", "Vanguard", "Jager", "Grenadier", "Honor Guard", "Visegrad", "Nil", "Warsaw", "Budapest", "Prague", "Sofia", "Bucharest", "Home Army", "Kasimir", "Veles", "Blyskawica", "Kubus")]"
	..()

/obj/effect/overmap/visitable/ship/ssmd_corvette/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/ssmd_corvette/nav1
	name = "Sol Recon Corvette - Port Side"
	landmark_tag = "nav_ssmd_corvette_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ssmd_corvette/nav2
	name = "Sol Recon Corvette - Port Side"
	landmark_tag = "nav_ssmd_corvette_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ssmd_corvette/transit
	name = "In transit"
	landmark_tag = "nav_transit_ssmd_corvette"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/ssmd_shuttle
	name = "Sol Recon Corvette Shuttle"
	class = "SAMV"
	designation = "Vizsla"
	desc = "A modestly sized shuttle design used by the Solarian armed forces, the Destrier is well-armored but somewhat slow, and was explicitly designed to be as survivable as possible for operations during combat. Notably features a fast-deployment exosuit catapult."
	shuttle = "SSMD Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#9dc04c", "#52c24c")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/ssmd_shuttle
	name = "shuttle control console"
	shuttle_tag = "SSMD Shuttle"
	req_access = list(ACCESS_SOL_SHIPS)

/datum/shuttle/autodock/overmap/ssmd_shuttle
	name = "SSMD Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/ssmd_shuttle)
	dock_target = "airlock_ssmd_shuttle"
	current_location = "nav_hangar_ssmd"
	landmark_transition = "nav_transit_ssmd_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_ssmd"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/ssmd_shuttle
	name = "SSMD Shuttle"
	shuttle_tag = "SSMD Shuttle"
	master_tag = "airlock_ssmd_shuttle"
	cycle_to_external_air = TRUE

/obj/effect/shuttle_landmark/ssmd_shuttle/hangar
	name = "SSMD Shuttle Hangar"
	landmark_tag = "nav_hangar_ssmd"
	docking_controller = "ssmd_shuttle_dock"
	base_area = /area/ship/ssmd_corvette
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/ssmd_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_ssmd_shuttle"
	base_turf = /turf/space/transit/north
