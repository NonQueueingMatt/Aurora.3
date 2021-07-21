
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Large finds - (Potentially) active alien machinery from the dawn of time

/datum/artifact_find
	var/artifact_id
	var/artifact_find_type
	var/artifact_detect_range

/datum/artifact_find/New()
	artifact_detect_range = rand(5,300)

	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

	artifact_find_type = pick(\
	1;/obj/machinery/wish_granter,\
	5;/obj/machinery/power/supermatter,\
	5;/obj/structure/constructshell,\
	5;/obj/machinery/syndicate_beacon,\
	25;/obj/machinery/power/supermatter/shard,\
	50;/obj/structure/cult/pylon,\
	100;/obj/machinery/auto_cloner,\
	100;/obj/machinery/giga_drill,\
	100;/obj/machinery/replicator,\
	150;/obj/structure/crystal,\
	1000;/obj/machinery/artifact)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Boulders - sometimes turn up after excavating turf - excavate further to try and find large xenoarch finds

/obj/structure/boulder
	name = "boulder"
	desc = "Leftover rock from an excavation, it's been partially dug out already but there's still a lot to go."
	icon = 'icons/obj/mining.dmi'
	icon_state = "boulder1"
	density = 1
	opacity = 1
	anchored = 1
	material = MATERIAL_SANDSTONE
	var/excavation_level = 0
	var/datum/geosample/geologic_data
	var/datum/artifact_find/artifact_find
	var/last_act = 0

/obj/structure/boulder/Initialize(mapload, var/coloration = "#9c9378")
	. = ..()
	icon_state = "boulder[rand(1,6)]"
	if(coloration)
		color = coloration
	excavation_level = rand(5,50)

/obj/structure/boulder/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/device/core_sampler))
		src.geologic_data.artifact_distance = rand(-100,100) / 100
		src.geologic_data.artifact_id = artifact_find.artifact_id

		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
		return

	if (istype(W, /obj/item/device/depth_scanner))
		var/obj/item/device/depth_scanner/C = W
		C.scan_atom(user, src)
		return

	if (istype(W, /obj/item/device/measuring_tape))
		var/obj/item/device/measuring_tape/P = W
		user.visible_message("<span class='notice'>[user] extends [P] towards [src].</span>","<span class='notice'>You extend [P] towards [src].</span>")
		if(do_after(user,40))
			to_chat(user, "<span class='notice'>[icon2html(P, user)] [src] has been excavated to a depth of [2*src.excavation_level]cm.</span>")
		return

	if (istype(W, /obj/item/pickaxe))
		var/obj/item/pickaxe/P = W

		if(last_act + P.digspeed > world.time)//prevents message spam
			return
		last_act = world.time

		to_chat(user, "<span class='warning'>You start [P.drill_verb] [src].</span>")



		if(!do_after(user,P.digspeed))
			return

		to_chat(user, "<span class='notice'>You finish [P.drill_verb] [src].</span>")
		excavation_level += P.excavation_amount

		if(excavation_level > 100)
			//failure
			user.visible_message("<span class='warning'><b>[src] suddenly crumbles away.</b></span>",\
			"<span class='warning'>[src] has disintegrated under your onslaught, any secrets it was holding are long gone.</span>")
			qdel(src)
			return

		if(prob(excavation_level))
			//success
			if(artifact_find)
				var/spawn_type = artifact_find.artifact_find_type
				var/obj/O = new spawn_type(get_turf(src))
				if(istype(O,/obj/machinery/artifact))
					var/obj/machinery/artifact/X = O
					if(X.my_effect)
						X.my_effect.artifact_id = artifact_find.artifact_id
				src.visible_message("<span class='warning'><b>[src] suddenly crumbles away.</b></span>")
			else
				user.visible_message("<span class='warning'><b>[src] suddenly crumbles away.</b></span>",\
				"<span class='notice'>[src] has been whittled away under your careful excavation, but there was nothing of interest inside.</span>")
			qdel(src)

/obj/structure/boulder/CollidedWith(AM)
	. = ..()
	if(istype(AM,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if((istype(H.l_hand,/obj/item/pickaxe)) && (!H.hand))
			var/obj/item/pickaxe/P = H.l_hand
			if(P.autodrill)
				attackby(H.l_hand,H)
		else if((istype(H.r_hand,/obj/item/pickaxe)) && H.hand)
			var/obj/item/pickaxe/P = H.r_hand
			if(P.autodrill)
				attackby(H.r_hand,H)

	else if(istype(AM,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active,/obj/item/pickaxe))
			attackby(R.module_active,R)
