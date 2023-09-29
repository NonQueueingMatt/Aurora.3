//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "shuttle_control_console_exploration.tmpl"
	var/obj/effect/overmap/visitable/ship/connected //Ship we're connected to

/obj/machinery/computer/shuttle_control/explore/Initialize()
	. = ..()
	if(istype(linked, /obj/effect/overmap/visitable/ship))
		connected = linked

/obj/machinery/computer/shuttle_control/explore/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	. = ..()

	if(.)
		connected = linked
		LAZYSET(connected.consoles, src, TRUE)

/obj/machinery/computer/shuttle_control/explore/Destroy()
	if(connected)
		LAZYREMOVE(connected.consoles, src)
	. = ..()

/obj/machinery/computer/shuttle_control/explore/get_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/total_gas = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				total_gas += fuel_tank.air_contents.total_moles

		var/fuel_span = "good"
		if(total_gas < shuttle.fuel_consumption * 2)
			fuel_span = "bad"

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_usage" = shuttle.fuel_consumption * 100,
			"remaining_fuel" = round(total_gas, 0.01) * 100,
			"fuel_span" = fuel_span
		)

/obj/machinery/computer/shuttle_control/explore/handle_topic_href(var/datum/shuttle/autodock/overmap/shuttle, var/list/href_list)
	. = ..()
	if(. != null)
		return

	if(href_list["pick"])
		var/list/possible_d = shuttle.get_possible_destinations()
		var/D
		if(length(possible_d))
			D = tgui_input_list(usr, "Choose shuttle destination.", "Shuttle Destination", possible_d)
		else
			to_chat(usr,"<span class='warning'>No valid landing sites in range.</span>")
		if(CanInteract(usr, physical_state) && (D in possible_d))
			shuttle.set_destination(possible_d[D])
		return TOPIC_REFRESH
