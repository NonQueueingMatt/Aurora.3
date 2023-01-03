/decl/maneuver/slide
	name = "slide"
	delay = 0
	stamina_cost = 45
	charge_cost = 1500
	reflexive_modifier = 1.5

/decl/maneuver/slide/perform(var/mob/living/user, var/atom/target, var/strength, var/reflexively = FALSE)
	. = ..()
	if(.)
		var/old_pass_flags = user.pass_flags
		user.pass_flags |= PASSTABLE|PASSRAILING
		user.visible_message(SPAN_WARNING("\The [user] crouches into a slide!"))
		user.lying = TRUE
		user.resting = TRUE
		var/old_layer = user.layer
		user.layer = LAYER_UNDER_TABLE
		user.update_canmove()
		user.update_icon()
		user.throw_at(target, 2, 1, do_throw_animation = FALSE)
		user.pass_flags = old_pass_flags
		user.lying = FALSE
		user.resting = FALSE
		user.update_canmove()
		user.update_icon()
		user.layer = old_layer

/decl/maneuver/slide/can_be_used_by(var/mob/living/user, var/atom/target, var/silent = FALSE)
	. = ..()
	if(.)
		var/can_slide_distance = 2 * user.get_acrobatics_multiplier()
		if (can_slide_distance <= 0)
			if (!silent)
				to_chat(user, SPAN_WARNING("You can't slide in your current state."))
			return FALSE
		if (!istype(target))
			if (!silent)
				to_chat(user, SPAN_WARNING("That is not a valid slide target."))
			return FALSE
		if(user.m_intent != M_RUN)
			if(!silent)
				to_chat(user, SPAN_WARNING("You need to be running to crouch into a slide!"))
			return FALSE
		if(user.l_move_time < (world.time - 0.5 SECONDS))
			if(!silent)
				to_chat(user, SPAN_WARNING("You don't have enough momentum to slide!"))
			return FALSE
		return TRUE
