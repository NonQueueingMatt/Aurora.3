/mob/abstract/ghost
	layer = OBSERVER_LAYER
	plane = OBSERVER_PLANE

	/// Toggle darkness.
	var/see_darkness = FALSE
	/// Is the ghost able to see things humans can't?
	var/ghostvision = FALSE
	/// This variable generally controls whether a ghost has restrictions on where it can go or not (ex. if the ghost can bypass holy places).
	var/has_ghost_restrictions = TRUE
	/// The mob or thing we are following.
	var/atom/movable/following
	/// Necessary for seeing wires.
	var/obj/item/device/multitool/ghost_multitool

/mob/abstract/ghost/Initialize(mapload)
	. = ..()
	sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	see_invisible = SEE_INVISIBLE_OBSERVER
	add_verb(src, /mob/abstract/ghost/proc/dead_tele)
	ghost_multitool = new(src)

/mob/abstract/ghost/Destroy()
	stop_following()
	QDEL_NULL(ghost_multitool)
	return ..()

/mob/abstract/ghost/ClickOn(var/atom/A, var/params)
	if(!canClick())
		return
	setClickCooldown(4)
	// You are responsible for checking config.ghost_interaction when you override this function
	// Not all of them require checking, see below
	A.attack_ghost(src)

/mob/abstract/ghost/Post_Incorpmove()
	stop_following()
	teleport_if_needed()

/// Teleports the observer away from z-levels they shouldnt be on, if needed.
/mob/abstract/ghost/proc/teleport_if_needed()
	return

/mob/abstract/ghost/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "Ghost"

	see_darkness = !see_darkness
	update_sight()

/mob/abstract/ghost/proc/update_sight()
	set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)
	set_see_invisible(SEE_INVISIBLE_LEVEL_TWO)

	if (!see_darkness)
		set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	else
		set_see_invisible(ghostvision ? SEE_INVISIBLE_OBSERVER : SEE_INVISIBLE_LIVING)

/mob/abstract/ghost/verb/toggle_ghostsee()
	set name = "Toggle Ghost Vision"
	set category = "Ghost"
	set desc = "Toggles your ability to see things only ghosts can see, like ghosts."

	ghostvision = !ghostvision
	update_sight()
	to_chat(usr, SPAN_NOTICE("You [(ghostvision ? "now" : "no longer")] have ghost vision."))

/mob/abstract/ghost/proc/dead_tele()
	set name = "Teleport"
	set category = "Ghost"
	set desc= "Teleport to a location."

	if(!istype(usr, /mob/abstract/ghost))
		to_chat(usr, SPAN_WARNING("You need to be a ghost!"))
		return

	var/area_name = tgui_input_list(src, "Select an area to teleport to.", "Teleport", GLOB.ghostteleportlocs)

	remove_verb(usr, /mob/abstract/ghost/proc/dead_tele)
	ADD_VERB_IN(usr, 30, /mob/abstract/ghost/proc/dead_tele)

	var/area/thearea = GLOB.ghostteleportlocs[area_name]
	if(!thearea)
		return

	var/list/L = list()
	var/holyblock = FALSE

	if(usr.invisibility <= SEE_INVISIBLE_LIVING || (usr.mind in cult.current_antagonists))
		for(var/turf/T in get_area_turfs(thearea))
			if(!T.holy && has_ghost_restrictions)
				L+=T
			else
				holyblock = TRUE
	else
		for(var/turf/T in get_area_turfs(thearea))
			L+=T

	if(!L || !L.len)
		if(holyblock && has_ghost_restrictions)
			to_chat(usr, SPAN_WARNING("This area has been entirely made into sacred grounds, you cannot enter it while you are in this plane of existence!"))
			return
		else
			to_chat(usr, "No area available.")
			return

	var/turf/P = pick(L)
	if(on_restricted_level(P.z) && has_ghost_restrictions)
		to_chat(usr, "You can not teleport to this area.")
		return

	stop_following()
	usr.forceMove(pick(L))

/mob/abstract/ghost/verb/follow()
	set name = "Follow"
	set category = "Ghost"
	set desc = "Follow and haunt a mob."

	var/datum/tgui_module/follow_menu/GM = new /datum/tgui_module/follow_menu(usr)
	GM.ui_interact(usr)

// This is the ghost's follow verb with an argument
/mob/abstract/ghost/proc/ManualFollow(var/atom/movable/target)
	if(!target || target == following || target == src)
		return

	stop_following()
	following = target
	GLOB.moved_event.register(following, src, TYPE_PROC_REF(/atom/movable, move_to_destination))
	GLOB.destroyed_event.register(following, src, PROC_REF(stop_following))

	to_chat(src, SPAN_NOTICE("Now following \the <b>[following]</b>."))
	move_to_destination(following, following.loc, following.loc)
	update_sight()

/mob/abstract/ghost/proc/stop_following()
	if(following)
		to_chat(src, SPAN_NOTICE("No longer following \the <b>[following]</b>."))
		GLOB.moved_event.unregister(following, src)
		GLOB.destroyed_event.unregister(following, src)
		following = null

/mob/abstract/ghost/proc/on_restricted_level(var/check)
	if(!check)
		check = z
	//Check if they are a staff member
	if(check_rights(R_MOD|R_ADMIN|R_DEV, show_msg=FALSE, user=src))
		return FALSE

	//Check if the z level is in the restricted list
	if (!(check in SSatlas.current_map.restricted_levels))
		return FALSE

	return TRUE
