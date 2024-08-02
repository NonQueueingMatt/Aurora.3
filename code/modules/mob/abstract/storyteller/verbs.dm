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

/mob/abstract/storyteller/proc/create_object(var/mob/user)
	if (!create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(/obj), ";")
		create_object_html = file2text('html/create_object.html')
		create_object_html = replacetext(create_object_html, "null /* object types */", "\"[objectjs]\"")

	user << browse(replacetext(create_object_html, "/* ref src */", "\ref[src]"), "window=create_object;size=600x600")

/mob/abstract/storyteller/proc/create_turf(var/mob/user)
	if (!create_turf_html)
		var/turfjs = null
		turfjs = jointext(typesof(/turf), ";")
		create_turf_html = file2text('html/create_object.html')
		create_turf_html = replacetext(create_turf_html, "null /* object types */", "\"[turfjs]\"")

	user << browse(replacetext(create_turf_html, "/* ref src */", "\ref[src]"), "window=create_turf;size=425x475")

/mob/abstract/storyteller/proc/create_mob(var/mob/user)
	if (!create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "null /* object types */", "\"[mobjs]\"")

	user << browse(replacetext(create_mob_html, "/* ref src */", "\ref[src]"), "window=create_mob;size=425x475")

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

/mob/abstract/storyteller/verb/spawn_atom(var/object as text)
	set name = "Spawn"
	set category = "Storyteller"

	/// a little bit of extra sanitization never hurts
	if(usr != src)
		return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		new chosen(usr.loc)

	log_and_message_admins("spawned [chosen] at ([usr.x],[usr.y],[usr.z])")

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
