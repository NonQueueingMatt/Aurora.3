
/*/singleton/scenario/ruined_propellant_depot
	name = "Propellant Depot"
	desc = "\
		An independent propellant depot near some asteroid field, that has launched a distress beacon, requesting help. \
		SCCV Horizon, the closest ship in this sector, was sent by CC to investigate. \
		"
	scenario_site_id = "ruined_propellant_depot"

	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_late_announcement_message = "\
		Greetings, SCCV Horizon. A nearby propellant depot has launched a distress beacon, requesting help. \
		That depot is independent, but friendly, often serving fuel to corporate ships at a discount. \
		You are to investigate, and provide aid if needed. \
		"

	min_player_amount = 0
	min_actor_amount = 0

	roles = list(
		/singleton/role/ruined_propellant_depot,
		/singleton/role/ruined_propellant_depot/engineer,
		/singleton/role/ruined_propellant_depot/director,
	)
	default_outfit = /obj/outfit/admin/generic/ruined_propellant_depot_crew

	base_area = /area/ruined_propellant_depot

	radio_frequency_name = "Propellant Depot AG5"
*/
