/obj/machinery/mining
	icon = 'icons/obj/mining_drill.dmi'
	anchored = FALSE
	use_power = FALSE //The drill takes power directly from a cell.
	density = 1
	layer = MOB_LAYER+0.1 //So it draws over mobs in the tile north of it.

/obj/machinery/mining/drill
	name = "mining drill head"
	desc = "A large industrial drill. Its bore does not penetrate deep enough to access the sublevels."
	icon_state = "mining_drill"
	var/braces_needed = 2
	var/list/supports = list()
	var/supported = FALSE
	var/active = FALSE
	var/list/resource_field = list()

	var/ore_types = list(
		"iron" = /obj/item/ore/iron,
		MATERIAL_URANIUM = /obj/item/ore/uranium,
		MATERIAL_GOLD = /obj/item/ore/gold,
		MATERIAL_SILVER = /obj/item/ore/silver,
		MATERIAL_DIAMOND = /obj/item/ore/diamond,
		MATERIAL_PHORON = /obj/item/ore/phoron,
		"osmium" = /obj/item/ore/osmium,
		"hydrogen" = /obj/item/ore/hydrogen,
		"silicates" = /obj/item/ore/glass,
		"carbonaceous rock" = /obj/item/ore/coal
		)

	//Upgrades
	var/harvest_speed
	var/capacity
	var/charge_use
	var/obj/item/cell/cell = null

	//Flags
	var/need_update_field = FALSE
	var/need_player_check = FALSE

	var/datum/effect_system/sparks/spark_system

	component_types = list(
		/obj/item/circuitboard/miningdrill,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/micro_laser,
		/obj/item/cell/high
	)

/obj/machinery/mining/drill/Initialize()
	. = ..()
	spark_system = bind_spark(src, 3)

/obj/machinery/mining/drill/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/machinery/mining/drill/machinery_process()

	if(need_player_check)
		return

	check_supports()

	if(!active) 
		return

	if(!anchored || !use_cell_power())
		system_error("system configuration or charge error")
		return

	if(need_update_field)
		get_resource_field()

	if(world.time % 10 == 0)
		update_icon()

	if(!active)
		return

	//Drill through the flooring, if any.
	if(istype(get_turf(src), /turf/unsimulated/floor/asteroid))
		var/turf/unsimulated/floor/asteroid/T = get_turf(src)
		if(!T.dug)
			T.gets_dug()
	else if(istype(get_turf(src), /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		T.ex_act(2.0)

	//Dig out the tasty ores.
	if(resource_field.len)
		var/turf/harvesting = pick(resource_field)

		while(resource_field.len && !harvesting.resources)
			harvesting.has_resources = FALSE
			harvesting.resources = null
			resource_field -= harvesting
			harvesting = pick(resource_field)

		if(!harvesting) 
			return

		var/total_harvest = harvest_speed //Ore harvest-per-tick.
		var/found_resource = FALSE //If this doesn't get set, the area is depleted and the drill errors out.

		for(var/metal in ore_types)

			if(contents.len >= capacity)
				system_error("insufficient storage space")
				active = FALSE
				need_player_check = TRUE
				update_icon()
				return

			if(contents.len + total_harvest >= capacity)
				total_harvest = capacity - contents.len

			if(total_harvest <= 0) break
			if(harvesting.resources[metal])

				found_resource  = TRUE

				var/create_ore = 0
				if(harvesting.resources[metal] >= total_harvest)
					harvesting.resources[metal] -= total_harvest
					create_ore = total_harvest
					total_harvest = 0
				else
					total_harvest -= harvesting.resources[metal]
					create_ore = harvesting.resources[metal]
					harvesting.resources[metal] = 0

				for(var/i=1, i <= create_ore, i++)
					var/oretype = ore_types[metal]
					new oretype(src)

		if(!found_resource)
			harvesting.has_resources = FALSE
			harvesting.resources = null
			resource_field -= harvesting
	else
		active = FALSE
		need_player_check = TRUE
		update_icon()

/obj/machinery/mining/drill/examine(mob/user)
	..(user)
	if(need_player_check)
		to_chat(user, "The drill error light is flashing. The cell panel is [panel_open ? "open" : "closed"].")
	else
		to_chat(user, "The drill is [active ? "active" : "inactive"] and the cell panel is [panel_open ? "open" : "closed"].")
	if(panel_open)
		to_chat(user, "The power cell is [cell ? "installed" : "missing"].")
	to_chat(user, "The cell charge meter reads [cell ? round(cell.percent(),1) : 0]%")
	return


/obj/machinery/mining/drill/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/mining/drill/attackby(obj/item/O, mob/user)
	if(!active)
		if(default_deconstruction_screwdriver(user, O))
			return
		if (!panel_open)
			if(default_deconstruction_crowbar(user, O))
				return
			if(default_part_replacement(user, O))
				return
	if(active) 
		return ..()

	if(O.iscrowbar())
		if (panel_open)
			if(cell)
				to_chat(user, "You wrench out \the [cell].")
				cell.forceMove(get_turf(user))
				component_parts -= cell
				cell = null
				return
			else
				to_chat(user, "There's no cell to remove!")
				return

	if(istype(O, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				user.drop_from_inventory(O,src)
				cell = O
				component_parts += O
				O.add_fingerprint(user)
				visible_message(span("notice", "[user] inserts a power cell into [src]."),
					span("notice", "You insert the power cell into [src]."))
				power_change()
		else
			to_chat(user, span("notice", "The hatch must be open to insert a power cell."))
			return
	else
		..()
	return

/obj/machinery/mining/drill/attack_hand(mob/user)
	check_supports()

	if(need_player_check)
		to_chat(user, "You hit the manual override and reset the drill's error checking.")
		need_player_check = FALSE
		if(anchored)
			get_resource_field()
		update_icon()
		return
	else if(supported && !panel_open)
		if(use_cell_power())
			active = !active
			if(active)
				visible_message("<span class='notice'>\The [src] lurches downwards, grinding noisily.</span>")
				need_update_field = TRUE
			else
				visible_message("<span class='notice'>\The [src] shudders to a grinding halt.</span>")
		else
			to_chat(user, "<span class='notice'>The drill is unpowered.</span>")
	else
		if(use_cell_power())
			if(!supported && !panel_open)
				system_error("unbraced drill error")
				sleep(30)
				if(!supported) //if you can resolve it manually in three seconds then power to you good-sir.
					visible_message("<span class='notice'>\icon[src] [src.name] beeps, \"Unbraced drill error automatically corrected. Please brace your drill.\"</span>")
				else
					visible_message("<span class='notice'>\icon[src] [src.name] beeps, \"Unbraced drill error manually resolved. Operations may resume normally.\"</span>")
			if(supported && panel_open)
				if(cell)
					system_error("unsealed cell fitting error. Volatile cell discharge may occur if not immediately corrected")
					spark_system.queue()
					sleep(20)
					spark_system.queue()
					sleep(10)
					spark_system.queue()
					sleep(10)
					if(panel_open)
						if(prob(70))
							visible_message("<span class='danger'>\The [src]'s cell shorts out!</span>")
							cell.use(cell.charge)
						else
							visible_message("<span class='danger'>\The [src]'s cell detonates!</span>")
							explosion(src.loc, -1, -1, 2, 1)
							qdel(cell)
							component_parts -= cell
							cell = null
					else
						visible_message("<span class='notice'>\icon[src] [src.name] beeps, \"Unsealed cell fitting error manually resolved. Operations may resume normally.\"</span>")
		else
			to_chat(user, "<span class='notice'>The drill is unpowered.</span>")
	update_icon()

/obj/machinery/mining/drill/update_icon()
	if(need_player_check)
		icon_state = "mining_drill_error"
	else if(active)
		icon_state = "mining_drill_active"
	else if(supported)
		icon_state = "mining_drill_braced"
	else
		icon_state = "mining_drill"
	return

/obj/machinery/mining/drill/RefreshParts()
	..()
	harvest_speed = 0
	capacity = 0
	charge_use = 50

	for(var/obj/item/stock_parts/P in component_parts)
		if(ismicrolaser(P))
			harvest_speed = P.rating
		else if(ismatterbin(P))
			capacity = 200 * P.rating
		else if(iscapacitor(P))
			charge_use -= 10 * P.rating
	cell = locate(/obj/item/cell) in component_parts

/obj/machinery/mining/drill/proc/check_supports()

	supported = FALSE

	if((!supports || !supports.len) && initial(anchored) == 0)
		icon_state = "mining_drill"
		anchored = FALSE
		active = FALSE
	else
		anchored = 1

	if(supports && supports.len >= braces_needed)
		supported = 1

	update_icon()

/obj/machinery/mining/drill/proc/system_error(var/error)

	if(error)
		visible_message("<span class='warning'>\icon[src] [src.name] flashes a system warning: [error].</span>")
		playsound(src.loc, 'sound/machines/warning-buzzer.ogg', 100, 1)
	need_player_check = TRUE
	active = FALSE
	update_icon()

/obj/machinery/mining/drill/proc/get_resource_field()

	resource_field = list()
	need_update_field = FALSE

	var/turf/T = get_turf(src)
	if(!istype(T)) 
		return

	var/tx = T.x - 2
	var/ty = T.y - 2
	var/turf/mine_turf
	for(var/iy = 0,iy < 5, iy++)
		for(var/ix = 0, ix < 5, ix++)
			mine_turf = locate(tx + ix, ty + iy, T.z)
			if(mine_turf && mine_turf.has_resources)
				resource_field += mine_turf

	if(!resource_field.len)
		system_error("resources depleted")

/obj/machinery/mining/drill/proc/use_cell_power()
	if(!cell) 
		return FALSE
	if(cell.charge >= charge_use)
		cell.use(charge_use)
		return TRUE
	return FALSE

/obj/machinery/mining/drill/verb/unload()
	set name = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	if(usr.stat) return

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		for(var/obj/item/ore/O in contents)
			O.forceMove(B)
		to_chat(usr, "<span class='notice'>You unload the drill's storage cache into the ore box.</span>")
	else
		for(var/obj/item/ore/O in contents)
			O.forceMove(src.loc)
		to_chat(usr, "<span class='notice'>You spill the content's of the drill's storage box all over the ground. Idiot.</span>")


/obj/machinery/mining/brace
	name = "mining drill brace"
	desc = "A machinery brace for an industrial drill. It looks easily two feet thick."
	icon_state = "mining_brace"
	var/obj/machinery/mining/drill/connected

	component_types = list(
		/obj/item/circuitboard/miningdrillbrace
	)

/obj/machinery/mining/brace/attackby(obj/item/W, mob/user)
	if(connected && connected.active)
		to_chat(user, "<span class='notice'>You know you ought not work with the brace of a <i>running</i> drill, but you do anyways.</span>")
		sleep(5)
		if(istype(user, /mob/living/carbon/human))
			//Save the users active hand
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/LA = H.get_organ(BP_L_HAND)
			var/obj/item/organ/external/RA = H.get_organ(BP_R_HAND)
			var/active_hand = H.hand
			if(prob(20))
				if(active_hand)
					LA.droplimb(0,DROPLIMB_BLUNT)
				else
					RA.droplimb(0,DROPLIMB_BLUNT)
				connected.system_error("unexpected user interface error")
				return
			else
				H.apply_damage(25,BRUTE, sharp=1, edge=1)
				connected.system_error("unexpected user interface error")
				return
		else
			var/mob/living/M = user
			M.apply_damage(25,BRUTE, sharp=1, edge=1)

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return

	if(W.iswrench())

		if(istype(get_turf(src), /turf/space))
			to_chat(user, "<span class='notice'>You send the [src] careening into space. Idiot.</span>")
			var/inertia = rand(10,30)
			for(var/i in 1 to inertia)
				step_away(src,user,15,8)
				if(!(istype(get_turf(src), /turf/space)))
					break
				sleep(1)
			return

		if(connected && connected.active)
			if(prob(50))
				sleep(10)
				connected.system_error("unbraced drill error")
				sleep(30)
				if(connected && connected.active) //if you can resolve it manually in three seconds then power to you good-sir.
					visible_message("<span class='notice'>\icon[src] [src.name] beeps, \"Unbraced drill error automatically corrected. Please brace your drill.\"</span>")
			else
				connected.system_error("unexpected user interface error")
				return

		playsound(src.loc, W.usesound, 100, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]anchor the brace.</span>")

		anchored = !anchored
		if(anchored)
			connect()
		else
			disconnect()

/obj/machinery/mining/brace/proc/connect()

	var/turf/T = get_step(get_turf(src), src.dir)

	for(var/thing in T.contents)
		if(istype(thing, /obj/machinery/mining/drill))
			connected = thing
			break

	if(!connected)
		return

	if(!connected.supports)
		connected.supports = list()

	icon_state = "mining_brace_active"

	connected.supports += src
	connected.check_supports()

/obj/machinery/mining/brace/proc/disconnect()

	if(!connected) return

	if(!connected.supports) connected.supports = list()

	icon_state = "mining_brace"

	connected.supports -= src
	connected.check_supports()
	connected = null

/obj/machinery/mining/brace/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if(usr.stat) return

	if (src.anchored)
		to_chat(usr, "It is anchored in place!")
		return FALSE

	src.set_dir(turn(src.dir, 90))
	return TRUE
