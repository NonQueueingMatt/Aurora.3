#define UIDEBUG

/obj/machinery/autolathe
	name = "microlathe"
	desc = "A large machine resembling a 3D printer combined with an advanced microlathe of Nanotrasen design."
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30

	var/list/machine_recipes
	var/list/stored_material =  list(DEFAULT_WALL_MATERIAL = 0, MATERIAL_GLASS = 0)
	var/list/storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, MATERIAL_GLASS = 0)
	var/show_category = "All"

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/busy = FALSE

	var/mat_efficiency = 1
	var/build_time = 50

	var/datum/wires/autolathe/wires
	var/datum/autolathe/recipe/build_item

	component_types = list(
		/obj/item/circuitboard/autolathe,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)

/obj/machinery/autolathe/mounted
	name = "\improper mounted microlathe"
	density = FALSE
	anchored = FALSE
	idle_power_usage = FALSE
	active_power_usage = FALSE
	interact_offline = TRUE
	var/print_loc

/obj/machinery/autolathe/Initialize()
	. = ..()
	wires = new(src)

/obj/machinery/autolathe/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/autolathe/proc/update_recipe_list()
	if(!machine_recipes)
		machine_recipes = SSmaterials.autolathe_recipes

/obj/machinery/autolathe/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, SPAN_WARNING("\The [src] doesn't respond to your commands and its LEDs have gone dark."))
		return
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/autolathe/ui_interact(mob/user)
	update_recipe_list()
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new(user, src, "machines-autolathe", 1000, 700, "Nanotrasen Microlathe MK2")
		ui.data = vueui_data_change(list("current_cat"="All"), user, ui)
	ui.open()

/obj/machinery/autolathe/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list("current_cat" = "All")
	data["recipes"] = list()
	for(var/N in machine_recipes)
		var/datum/autolathe/recipe/R = machine_recipes[N]
		data["recipes"][N] = list()
		data["recipes"][N]["name"] = R.name
		var/price
		if(R.resources)
			var/list/resource_list = list()
			for(var/M in R.resources)
				resource_list += "[R.resources[M]] [M]"
			price = english_list(resource_list)
		else if(R.is_stack) //stack or a free recipe, the latter doesn't quite make sense, so let's exclude it
			price = "N/A"
		data["recipes"][N]["matter"] = price
		data["recipes"][N]["category"] = R.category

/obj/machinery/autolathe/attackby(obj/item/O, mob/user)
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is already busy printing something."))
		return

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(stat)
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(O.ismultitool() || O.iswirecutter())
			attack_hand(user)
			return

	if(O.loc != user && !istype(O, /obj/item/stack))
		return FALSE

	if(is_robot_module(O))
		return FALSE

	//Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.matter)
		to_chat(user, "\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)
		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue
		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating, /obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(!filltype)
		to_chat(user, span("notice", "\The [src] is full. Please remove material from the autolathe in order to insert more."))
		return
	else if(filltype == 1)
		to_chat(user, span("notice", "You fill \the [src] to capacity with \the [eating]."))
	else
		to_chat(user, span("notice", "You fill \the [src] with \the [eating]."))

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used / mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else
		user.remove_from_mob(O)
		qdel(O)

	updateUsrDialog()
	return

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, span("notice", "The autolathe is busy. Please wait for the completion of previous operation."))
		return

	if(href_list["make"] && machine_recipes)
		var/index = text2num(href_list["make"])
		var/multiplier = text2num(href_list["multiplier"])
		build_item = null

		if(index > 0 && index <= machine_recipes.len)
			build_item = machine_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if(!build_item || multiplier < 0 || multiplier > 100)
			var/turf/exploit_loc = get_turf(usr)
			message_admins("[key_name_admin(usr)] tried to exploit an autolathe to duplicate an item! ([exploit_loc ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[exploit_loc.x];Y=[exploit_loc.y];Z=[exploit_loc.z]'>JMP</a>" : "null"])", 0)
			log_admin("EXPLOIT : [key_name(usr)] tried to exploit an autolathe to duplicate an item!",ckey=key_name(usr))
			return

		busy = TRUE
		update_use_power(2)

		//Check if we still have the materials.
		for(var/material in build_item.resources)
			if(!isnull(stored_material[material]))
				if(stored_material[material] < round(build_item.resources[material] * mat_efficiency) * multiplier)
					return

		//Consume materials.
		for(var/material in build_item.resources)
			if(!isnull(stored_material[material]))
				stored_material[material] = max(0, stored_material[material] - round(build_item.resources[material] * mat_efficiency) * multiplier)

		//Fancy autolathe animation.
		flick("autolathe_n", src)

		sleep(build_time)

		busy = FALSE
		update_use_power(1)

		//Sanity check.
		if(!build_item || !src)
			return

		//Create the desired item.
		var/obj/item/I = new build_item.path(get_turf(src))
		I.Created()
		if(multiplier > 1 && istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			S.amount = multiplier

	updateUsrDialog()

/obj/machinery/autolathe/update_icon()
	icon_state = (panel_open ? "autolathe_t" : "autolathe")

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity[DEFAULT_WALL_MATERIAL] = mb_rating * 25000
	storage_capacity["glass"] = mb_rating * 12500
	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1 // Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.8. Maximum rating of parts is 3

/obj/machinery/autolathe/dismantle()
	for(var/mat in stored_material)
		var/material/M = SSmaterials.get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return TRUE
