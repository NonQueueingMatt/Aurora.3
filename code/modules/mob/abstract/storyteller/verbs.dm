// Okay, these verbs are a lot of ugly copypaste. The issue is that we don't really have any other choice.
// The alternative (and the first thing I tried) was to make the Storyteller into basically admin perms, but that introduces way too many issues.

/mob/abstract/storyteller/verb/storyteller_panel()
	set name = "Storyteller Panel"
	set category = "Storyteller"

	open_storyteller_panel()

/mob/abstract/storyteller/proc/open_storyteller_panel()
	var/dat = {"
		<center><B>Storyteller Panel</B></center><hr>\n
		"}
	dat += {"
		<BR>
		<A href='?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='?src=\ref[src];create_mob=1'>Create Mob</A><br>
		"}

	usr << browse(dat, "window=storytellerpanel;size=210x280")

/mob/abstract/storyteller/Topic(href, href_list)
	. = ..()
	if(href_list["create_object"])
		if(usr != src)
			return
		return create_object(usr)

	else if(href_list["create_turf"])
		if(usr != src)
			return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(usr != src)
			return
		return create_mob(usr)

	else if(href_list["object_list"])
		if(!GLOB.config.allow_admin_spawning)
			to_chat(usr, "Spawning of items is not allowed.")
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()
		var/removed_paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				removed_paths += dirty_path
				continue
			else if(!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
				removed_paths += dirty_path
				continue
			else if(ispath(path, /obj/effect/bhole))
				if(!check_rights(R_FUN, 0))
					removed_paths += dirty_path
					continue
			paths += path

		if(!paths ||( length(paths) > 5))
			return

		var/atom/target
		var/list/offset = text2list(href_list["offset"],",")
		var/number = dd_range(1, 100, text2num(href_list["object_count"]))
		var/X = offset.len > 0 ? text2num(offset[1]) : 0
		var/Y = offset.len > 1 ? text2num(offset[2]) : 0
		var/Z = offset.len > 2 ? text2num(offset[3]) : 0
		var/tmp_dir = href_list["object_dir"]
		var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
		if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = 2
		var/obj_name = sanitize(href_list["object_name"])
		switch(href_list["offset_type"])
			if ("absolute")
				target = locate(0 + X, 0 + Y, 0 + Z)
			if ("relative")
				target = locate(loc.x + X, loc.y + Y, loc.z + Z)

		if(target)
			for (var/path in paths)
				for (var/i = 0; i < number; i++)
					if(ispath(path, /turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N)
							if(obj_name)
								N.name = obj_name
					else
						var/atom/O = new path(target)
						if(O)
							O.set_dir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(ismob(O))
									var/mob/M = O
									M.set_name(obj_name)

		log_and_message_admins("created [number] [english_list(paths)]")

/mob/abstract/storyteller/proc/create_object(var/mob/user)
	if (!create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(/obj), ";")
		create_object_html = file2text('html/create_object.html')
		create_object_html = replacetext(create_object_html, "null /* object types */", "\"[objectjs]\"")

	user << browse(replacetext(create_object_html, "/* ref src */", "\ref[src]"), "window=create_object;size=700x700")

/mob/abstract/storyteller/proc/create_turf(var/mob/user)
	if (!create_turf_html)
		var/turfjs = null
		turfjs = jointext(typesof(/turf), ";")
		create_turf_html = file2text('html/create_object.html')
		create_turf_html = replacetext(create_turf_html, "null /* object types */", "\"[turfjs]\"")

	user << browse(replacetext(create_turf_html, "/* ref src */", "\ref[src]"), "window=create_turf;size=700x700")

/mob/abstract/storyteller/proc/create_mob(var/mob/user)
	if (!create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "null /* object types */", "\"[mobjs]\"")

	user << browse(replacetext(create_mob_html, "/* ref src */", "\ref[src]"), "window=create_mob;size=700x700")

/mob/abstract/storyteller/verb/storyteller_local_narrate()
	set name = "Local Narrate"
	set category = "Storyteller"

	var/list/mob/message_mobs = list()
	var/choice = tgui_alert(usr, "Narrate to mobs in view, or in range?", "Narrate Selection", list("In view", "In range", "Cancel"))
	if(choice != "Cancel")
		if(choice == "In view")
			message_mobs = mobs_in_view(world.view, src)
		else
			for(var/mob/M in range(world.view, src))
				message_mobs += M
	else
		return

	var/msg = html_decode(sanitize(tgui_input_text(src, "What do you want to narrate?", "Local Narrate", max_length = MAX_PAPER_MESSAGE_LEN)))
	if(!msg)
		return

	for(var/M in message_mobs)
		to_chat(M, msg)

	log_admin("LocalNarrate: [key_name(usr)] : [msg]")
	message_admins("<span class='notice'>\bold LocalNarrate: [key_name_admin(usr)] : [msg]<BR></span>", 1)

/mob/abstract/storyteller/verb/storyteller_global_narrate()
	set name = "Global Narrate"
	set category = "Storyteller"

	var/msg = html_decode(sanitize(tgui_input_text(src, "What do you want to narrate?", "Global Narrate", max_length = MAX_PAPER_MESSAGE_LEN)))

	if (!msg)
		return
	to_world("[msg]")
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins("<span class='notice'>\bold GlobalNarrate: [key_name_admin(usr)] : [msg]<BR></span>", 1)

/mob/abstract/storyteller/verb/storyteller_direct_narrate(var/mob/M)
	set name = "Direct Narrate"
	set category = "Storyteller"

	if(!M)
		var/list/client_mobs = list()
		for(var/mob/client_mob in get_mob_with_client_list())
			client_mobs[client_mob.name] = client_mob
		var/mob_name = tgui_input_list(src, "Who are you narrating to?", "Direct Narrate", client_mobs)
		if(mob_name)
			M = client_mobs[mob_name]

	if(!M)
		return

	var/msg = html_decode(sanitize(tgui_input_text(src, "What do you want to narrate?", "Direct Narrate", max_length = MAX_PAPER_MESSAGE_LEN)))

	if(!msg)
		return

	to_chat(M, msg)
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	message_admins("<span class='notice'>\bold DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]<BR></span>", 1)
	feedback_add_details("admin_verb","DIRN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/mob/abstract/storyteller/verb/toggle_build_mode()
	set name = "Toggle Build Mode"
	set category = "Storyteller"

	if(usr != src)
		return

	var/datum/click_handler/handler = GetClickHandler()
	if(handler.type == /datum/click_handler/build_mode)
		usr.PopClickHandler()
	else
		usr.PushClickHandler(/datum/click_handler/build_mode)

/mob/abstract/storyteller/verb/send_distress_message()
	set name = "Create Command Report"
	set category = "Storyteller"

	var/reporttitle = sanitizeSafe(tgui_input_text(usr, "Pick a title for the report.", "Title"))
	if(!reporttitle)
		reporttitle = "NanoTrasen Update"
	var/reportbody = sanitize(tgui_input_text(usr, "Please enter anything you want. Anything. Serious.", "Body", multiline = TRUE), extra = FALSE)
	if(!reportbody)
		return

	var/announce = tgui_alert(usr, "Should this be announced to the general population?", "Announcement", list("Yes","No"))
	switch(announce)
		if("Yes")
			command_announcement.Announce("[reportbody]", reporttitle, new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
		if("No")
			to_world(SPAN_WARNING("New [SSatlas.current_map.company_name] Update available at all communication consoles."))
			sound_to(world, ('sound/AI/commandreport.ogg'))

	log_admin("Storyteller [key_name(src)] has created a command report: [reportbody]")
	message_admins("Storyteller [key_name_admin(src)] has created a command report", 1)

	//New message handling
	post_comm_message(reporttitle, reportbody)

/mob/abstract/storyteller/verb/change_mob_name(var/mob/victim)
	set name = "Change Mob Name"

	var/new_name = tgui_input_text(src, "Enter a new name.", "Change Mob Name", max_length = MAX_NAME_LEN)
	if(!new_name)
		return

	log_admin("[key_name(src)] has renamed [victim] to [new_name].")
	victim.set_name(new_name)

/mob/abstract/storyteller/verb/change_obj_name(var/obj/thing)
	set name = "Change Object Name"

	var/new_name = tgui_input_text(src, "Enter a new name.", "Change Object Name", max_length = MAX_NAME_LEN)
	if(!new_name)
		return

	log_admin("[key_name(src)] has renamed [thing] to [new_name].")
	thing.name = new_name

/mob/abstract/storyteller/verb/change_obj_desc(var/obj/thing)
	set name = "Change Object Description"

	var/new_desc = tgui_input_text(src, "Enter a new description.", "Change Object Description", max_length = MAX_MESSAGE_LEN)
	if(!new_desc)
		return

	log_admin("[key_name(src)] has changed [thing]'s description to [new_desc].")
	thing.desc = new_desc

/mob/abstract/storyteller/verb/teleport(A in GLOB.ghostteleportlocs)
	set name = "Teleport to Area"
	set category = "Storyteller"

	var/area/chosen_area = GLOB.ghostteleportlocs[A]
	if(!chosen_area)
		return

	var/list/area_turfs = list()
	for(var/turf/T in get_area_turfs(chosen_area))
		area_turfs += T

	if(!area_turfs || !length(area_turfs))
		to_chat(usr, "No area available.")
		return

	var/turf/P = pick(area_turfs)
	forceMove(P)
	log_admin("[key_name(usr)] has teleported to [P.x] [P.y] [P.z].")

/mob/abstract/storyteller/verb/teleport_to_actor()
	set name = "Teleport to Antagonist"
	set category = "Storyteller"

	var/list/antagonists = list()
	for(var/antag_type in GLOB.all_antag_types)
		var/datum/antagonist/A = GLOB.all_antag_types[antag_type]
		for(var/datum/mind/mind in A.current_antagonists)
			var/mob/M = mind.current
			if(M)
				// technically you could be more than one antag
				antagonists |= M
	var/mob/chosen_mob = tgui_input_list(src, "Choose an antagonist to teleport to.", "Teleport to Antagonist", antagonists)
	if(chosen_mob)
		forceMove(get_turf(chosen_mob))
	log_admin("[key_name(usr)] has teleported to [chosen_mob].")

/mob/abstract/storyteller/verb/set_outfit(var/mob/living/carbon/human/H)
	set name = "Set Outfit"
	set category = "Storyteller"

	do_dressing(H)

/mob/abstract/storyteller/proc/show_traitor_panel(var/mob/M)
	set name = "Edit Antagonist"
	set category = "Storyteller"

	if(!istype(M))
		to_chat(usr, SPAN_WARNING("This can only be used on mobs!"))
		return

	if(!M.mind)
		to_chat(usr, SPAN_WARNING("This mob has no mind!"))
		return

	M.mind.edit_memory()
