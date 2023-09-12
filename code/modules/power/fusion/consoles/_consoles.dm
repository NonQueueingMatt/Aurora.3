/obj/machinery/computer/fusion
	icon_keyboard = "power_key"
	icon_screen = "rust_screen"
	light_color = COLOR_ORANGE
	idle_power_usage = 250
	active_power_usage = 500
	var/ui_template
	var/initial_id_tag

/obj/machinery/computer/fusion/Initialize()
	AddComponent(/datum/component/local_network_member, initial_id_tag)
	. = ..()

/obj/machinery/computer/fusion/proc/get_local_network()
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	return fusion.get_local_network()

/obj/machinery/computer/fusion/attackby(obj/item/thing, mob/user)
	if(thing.ismultitool())
		var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
		fusion.get_new_tag(user)
		return
	else
		return ..()

/obj/machinery/computer/fusion/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	ui_interact(user)
	return TRUE

/obj/machinery/computer/fusion/proc/build_ui_data()
	var/datum/component/local_network_member/fusion = GetComponent(/datum/component/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/data = list()
	data["id"] = lan ? lan.id_tag : "unset"
	data["name"] = name
	. = data

/obj/machinery/computer/fusion/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	if(ui_template)
		var/list/data = build_ui_data()
		ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, ui_template, name, 400, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)
