/obj/effect/decal/remains
	name = "remains"
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = 0

/obj/effect/decal/remains/human
	desc = "They look like human remains. They have a strange aura about them."

/obj/effect/decal/remains/xeno
	desc = "They look like the remains of something... alien. They have a strange aura about them."
	icon_state = "remainsxeno"

/obj/effect/decal/remains/robot
	desc = "They look like the remains of something mechanical. They have a strange aura about them."
	icon = 'icons/mob/robots.dmi'
	icon_state = "remainsrobot"

/obj/effect/decal/remains/rat
	name = "rat skeleton"
	desc = "Looks like the remains of a small rodent. It doesn't squeak anymore."
	icon = 'icons/mob/npc/rat.dmi'
	icon_state = "skeleton"

/obj/effect/decal/remains/lizard
	desc = "They look like the remains of a small reptile."
	icon_state = "lizard"

/obj/effect/decal/remains/attack_hand(mob/user)
	to_chat(user, "<span class='notice'>[src] sinks together into a pile of ash.</span>")
	var/turf/simulated/floor/F = get_turf(src)
	if (istype(F))
		new /obj/effect/decal/cleanable/ash(F)
	qdel(src)

/obj/effect/decal/remains/robot/attack_hand(mob/user)
	return
