/obj/machinery/computer/ship/sensors
	name = "sensors console"
	icon_screen = "sensors"
	icon_keyboard = "cyan_key"
	light_color = LIGHT_COLOR_CYAN
	extra_view = 4
	var/obj/machinery/shipsensors/sensors
	circuit = /obj/item/circuitboard/ship/sensors

/obj/machinery/computer/ship/sensors/attempt_hook_up(var/obj/effect/overmap/visitable/sector)
	. = ..()
	if(!.)
		return
	find_sensors()

/obj/machinery/computer/ship/sensors/proc/find_sensors()
	if(!linked)
		return
	for(var/obj/machinery/shipsensors/S in SSmachinery.machinery)
		if(linked.check_ownership(S))
			sensors = S
			break

/obj/machinery/computer/ship/sensors/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "sensors")
		return

	var/data[0]

	data["viewing"] = viewing_overmap(user)
	if(sensors)
		data["on"] = sensors.use_power
		data["range"] = sensors.range
		data["health"] = sensors.health
		data["max_health"] = sensors.max_health
		data["heat"] = sensors.heat
		data["critical_heat"] = sensors.critical_heat
		if(sensors.health == 0)
			data["status"] = "DESTROYED"
		else if(!sensors.powered())
			data["status"] = "NO POWER"
		else if(!sensors.in_vacuum())
			data["status"] = "VACUUM SEAL BROKEN"
		else
			data["status"] = "OK"
		var/list/distress_beacons = list()
		for(var/caller in SSdistress.active_distress_beacons)
			var/datum/distress_beacon/beacon = SSdistress.active_distress_beacons[caller]
			var/obj/effect/overmap/vessel = beacon.caller
			var/mob/living/carbon/human/H = beacon.user
			var/job_string = H.job ? "[H.job] " : ""
			var/bearing = round(90 - Atan2(vessel.x - linked.x, vessel.y - linked.y),5)
			if(bearing < 0)
				bearing += 360
			distress_beacons.Add(list(list("caller" = vessel.name, "sender" = "[job_string][H.name]", "bearing" = bearing)))
		if(length(distress_beacons))
			data["distress_beacons"] = distress_beacons
		var/list/contacts = list()
		for(var/obj/effect/overmap/O in view(7,linked))
			if(linked == O)
				continue
			if(!O.scannable)
				continue
			var/bearing = round(90 - Atan2(O.x - linked.x, O.y - linked.y),5)
			if(bearing < 0)
				bearing += 360
			contacts.Add(list(list("name"=O.name, "ref"="\ref[O]", "bearing"=bearing)))
		if(length(contacts))
			data["contacts"] = contacts
	else
		data["status"] = "MISSING"
		data["range"] = "N/A"
		data["on"] = 0

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "shipsensors.tmpl", "[linked.name] Sensors Control", 420, 530, src)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/sensors/Topic(href, href_list)
	if (..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		if(usr)
			viewing_overmap(usr) ? unlook(usr) : look(usr)
		return TOPIC_REFRESH

	if (href_list["link"])
		find_sensors()
		return TOPIC_REFRESH

	if(sensors)
		if (href_list["range"])
			var/nrange = input("Set new sensors range", "Sensor range", sensors.range) as num|null
			if(!CanInteract(usr, default_state))
				return TOPIC_NOACTION
			if (nrange)
				sensors.set_range(Clamp(nrange, 1, world.view))
			return TOPIC_REFRESH
		if (href_list["toggle"])
			sensors.toggle()
			return TOPIC_REFRESH

	if (href_list["scan"])
		var/obj/effect/overmap/O = locate(href_list["scan"])
		if(istype(O) && !QDELETED(O) && (O in view(7,linked)))
			playsound(loc, "sound/machines/dotprinter.ogg", 30, 1)
			new/obj/item/paper/(get_turf(src), O.get_scan_data(usr), "paper (Sensor Scan - [O])")
		return TOPIC_HANDLED

	if (href_list["play_message"])
		var/caller = href_list["play_message"]
		var/datum/distress_beacon/beacon = SSdistress.active_distress_beacons[caller]
		var/mob/living/carbon/human/sender = beacon.user
		var/user_name = beacon.user_name
		var/accent_icon = sender.get_accent_icon()
		visible_message(SPAN_NOTICE("\The [src] beeps a few times as it replays the distress message."))
		playsound(src, 'sound/machines/compbeep5.ogg')
		visible_message(SPAN_ITALIC("[accent_icon] <b>[user_name]</b> explains, \"[beacon.distress_message]\""))
		return TOPIC_HANDLED

/obj/machinery/computer/ship/sensors/process()
	..()
	if(!linked)
		return
	if(sensors && sensors.use_power && sensors.powered())
		var/sensor_range = round(sensors.range*1.5) + 1
		linked.set_light(sensor_range, sensor_range+1, light_color)
	else
		linked.set_light(0)

/obj/machinery/shipsensors
	name = "sensors suite"
	desc = "Long range gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "sensors"
	anchored = 1
	var/max_health = 200
	var/health = 200
	var/critical_heat = 50 // sparks and takes damage when active & above this heat
	var/heat_reduction = 0.5 // mitigates this much heat per tick - can sustain range 2
	var/heat = 0
	var/range = 1
	idle_power_usage = 5000

/obj/machinery/shipsensors/attackby(obj/item/W, mob/user)
	var/damage = max_health - health
	if(damage && W.iswelder())

		var/obj/item/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.use(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src, 'sound/items/welder.ogg', 100, 1)
			if(WT.use_tool(src, user, max(5, damage / 5), volume = 50) && WT && WT.isOn())
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				take_damage(-damage)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		return
	..()

/obj/machinery/shipsensors/proc/in_vacuum()
	var/turf/T=get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/environment = T.return_air()
		if(environment && environment.return_pressure() > MINIMUM_PRESSURE_DIFFERENCE_TO_SUSPEND)
			return 0
	return 1

/obj/machinery/shipsensors/update_icon()
	if(use_power)
		icon_state = "sensors"
	else
		icon_state = "sensors_off"

/obj/machinery/shipsensors/examine(mob/user)
	. = ..()
	if(health <= 0)
		to_chat(user, "\The [src] is wrecked.")
	else if(health < max_health * 0.25)
		to_chat(user, "<span class='danger'>\The [src] looks like it's about to break!</span>")
	else if(health < max_health * 0.5)
		to_chat(user, "<span class='danger'>\The [src] looks seriously damaged!</span>")
	else if(health < max_health * 0.75)
		to_chat(user, "\The [src] shows signs of damage!")

/obj/machinery/shipsensors/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	..()

/obj/machinery/shipsensors/proc/toggle()
	if(!use_power && (health == 0 || !in_vacuum()))
		return // No turning on if broken or misplaced.
	if(!use_power) //need some juice to kickstart
		use_power_oneoff(idle_power_usage*5)
	update_use_power(!use_power)
	queue_icon_update()

/obj/machinery/shipsensors/process()
	..()
	if(use_power) //can't run in non-vacuum
		if(!in_vacuum())
			toggle()
		if(heat > critical_heat)
			src.visible_message("<span class='danger'>\The [src] violently spews out sparks!</span>")
			spark(src, 3, alldirs)

			take_damage(rand(10,50))
			toggle()
		heat += active_power_usage/15000

	if (heat > 0)
		heat = max(0, heat - heat_reduction)

/obj/machinery/shipsensors/power_change()
	. = ..()
	if(use_power && !powered())
		toggle()

/obj/machinery/shipsensors/proc/set_range(nrange)
	range = nrange
	change_power_consumption(1500 * (range**2), POWER_USE_ACTIVE)

/obj/machinery/shipsensors/emp_act(severity)
	if(!use_power)
		return
	take_damage(20/severity)
	toggle()

/obj/machinery/shipsensors/proc/take_damage(value)
	health = min(max(health - value, 0),max_health)
	if(use_power && health == 0)
		toggle()

// For small shuttles
/obj/machinery/shipsensors/weak
	heat_reduction = 0.35 // Can sustain range 1
	desc = "Miniturized gravity scanner with various other sensors, used to detect irregularities in surrounding space. Can only run in vacuum to protect delicate quantum BS elements."
