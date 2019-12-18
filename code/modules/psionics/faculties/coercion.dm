/datum/psionic_faculty/coercion
	id = PSI_COERCION
	name = "Coercion"
	associated_intent = I_DISARM

/datum/psionic_power/coercion
	faculty = PSI_COERCION

/datum/psionic_power/coercion/invoke(var/mob/living/user, var/mob/living/target)
	if (!istype(target))
		to_chat(user, span("warning", "You cannot mentally attack \the [target]."))
		return FALSE

	. = ..()

/datum/psionic_power/coercion/blindstrike
	name =           "Blindstrike"
	cost =           8
	cooldown =       120
	use_ranged =     TRUE
	use_melee =      TRUE
	min_rank =       PSI_RANK_GRANDMASTER
	use_description = "Target the eyes or mouth on disarm intent and click anywhere to use a radial attack that blinds, deafens and disorients everyone near you."

/datum/psionic_power/coercion/blindstrike/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != "mouth" && user.zone_sel.selecting != BP_EYES)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(span("danger", "\The [user] suddenly throws back their head, as though screaming silently!"))
		to_chat(user, span("danger", "You strike at all around you with a deafening psionic scream!"))
		for(var/mob/living/M in orange(user, user.psi.get_rank(PSI_COERCION)))
			if(M == user)
				continue
			if(prob(60) && iscarbon(M))
				var/mob/living/carbon/C = M
				if(C.can_feel_pain())
					M.emote("scream")
			to_chat(M, span("danger", "Your senses are blasted into oblivion by a psionic scream!"))
			M.eye_blind = max(M.eye_blind,3)
			M.ear_deaf = max(M.ear_deaf,6)
			M.confused = rand(3,8)
		return TRUE

/datum/psionic_power/coercion/mindread
	name =            "Read Mind"
	cost =            25
	cooldown =        250 //It should take a WHILE to be able to use this again.
	use_melee =       TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Target the head on disarm intent at melee range to attempt to read a victim's surface thoughts."

/datum/psionic_power/coercion/mindread/invoke(var/mob/living/user, var/mob/living/target)
	if(!isliving(target) || !istype(target) || user.zone_sel.selecting != BP_HEAD)
		return FALSE
	. = ..()
	if(!.)
		return

	if(target.stat == DEAD || (target.status_flags & FAKEDEATH) || !target.client)
		to_chat(user, span("warning", "\The [target] is in no state for a mind-ream."))
		return TRUE

	user.visible_message(span("warning", "\The [user] touches \the [target]'s temple..."))
	var/question =  input(user, "Say something?", "Read Mind", "Penny for your thoughts?") as null|text
	if(!question || user.incapacitated() || !do_after(user, 20))
		return TRUE

	var/started_mindread = world.time
	to_chat(user, span("notice", "<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking an answer: <i>[question]</i></b>"))
	to_chat(target, span("notice", "<b>Your mind is compelled to answer: <i>[question]</i></b>"))

	var/answer =  input(target, question, "Read Mind") as null|text
	if(!answer || world.time > started_mindread + 25 SECONDS || user.stat != CONSCIOUS || target.stat == DEAD)
		to_chat(user, span("notice", "<b>You receive nothing useful from \the [target].</b>"))
	else
		to_chat(user, span("notice", "<b>You skim thoughts from the surface of \the [target]'s mind: <i>[answer]</i></b>"))
	msg_admin_attack("[key_name(user)] read mind of [key_name(target)] with question \"[question]\" and [answer?"got answer \"[answer]\".":"got no answer."]")
	return TRUE

/datum/psionic_power/coercion/agony
	name =          "Agony"
	cost =          8
	cooldown =      50
	use_melee =     TRUE
	min_rank =      PSI_RANK_MASTER
	use_description = "Target the chest or groin on disarm intent to use a melee attack equivalent to a strike from a stun baton."

/datum/psionic_power/coercion/agony/invoke(var/mob/living/user, var/mob/living/target)
	if(!istype(target))
		return FALSE
	if(user.zone_sel.selecting != BP_CHEST && user.zone_sel.selecting != BP_GROIN)
		return FALSE
	. = ..()
	if(.)
		user.visible_message("<span class='danger'>\The [target] has been struck by \the [user]!</span>")
		playsound(user.loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		target.stun_effect_act(0, 60, user.zone_sel.selecting)
		return TRUE

/datum/psionic_power/coercion/spasm
	name =           "Spasm"
	cost =           15
	cooldown =       100
	use_melee =      TRUE
	use_ranged =     TRUE
	min_rank =       PSI_RANK_MASTER
	use_description = "Target the arms or hands on disarm intent to use a ranged attack that may rip the weapons away from the target."

/datum/psionic_power/coercion/spasm/invoke(var/mob/living/user, var/mob/living/carbon/human/target)
	if(!istype(target))
		return FALSE

	if(!(user.zone_sel.selecting in list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND)))
		return FALSE

	. = ..()

	if(.)
		to_chat(user, "<span class='danger'>You lash out, stabbing into \the [target] with a lance of psi-power.</span>")
		to_chat(target, "<span class='danger'>The muscles in your arms cramp horrendously!</span>")
		if(prob(75))
			target.emote("scream")
		if(prob(75) && target.l_hand && target.l_hand.simulated && target.unEquip(target.l_hand))
			target.visible_message("<span class='danger'>\The [target] drops what they were holding as their left hand spasms!</span>")
		if(prob(75) && target.r_hand && target.r_hand.simulated && target.unEquip(target.r_hand))
			target.visible_message("<span class='danger'>\The [target] drops what they were holding as their right hand spasms!</span>")
		return TRUE

/datum/psionic_power/coercion/mindslave
	name =          "Mindslave"
	cost =          28
	cooldown =      200
	use_grab =      TRUE
	min_rank =      PSI_RANK_PARAMOUNT
	use_description = "Grab a victim, target the eyes, then use the grab on them while on disarm intent, in order to convert them into a loyal mind-slave. The process takes some time, and failure is punished harshly."

/datum/psionic_power/coercion/mindslave/invoke(var/mob/living/user, var/mob/living/target)
	if(!istype(target) || user.zone_sel.selecting != BP_EYES)
		return FALSE
	. = ..()
	if(.)
		if(target.stat == DEAD || (target.status_flags & FAKEDEATH))
			to_chat(user, "<span class='warning'>\The [target] is dead!</span>")
			return TRUE
		if(!target.mind || !target.key)
			to_chat(user, "<span class='warning'>\The [target] is mindless!</span>")
			return TRUE
		user.visible_message("<span class='danger'><i>\The [user] seizes the head of \the [target] in both hands...</i></span>")
		to_chat(user, "<span class='warning'>You plunge your mentality into that of \the [target]...</span>")
		to_chat(target, "<span class='danger'>Your mind is invaded by the presence of \the [user]! They are trying to make you a slave!</span>")
		if(!do_after(user, target.stat == CONSCIOUS ? 80 : 40, target, 0, 1))
			user.psi.backblast(rand(10,25))
			return TRUE
		to_chat(user, "<span class='danger'>You sear through \the [target]'s neurons, reshaping as you see fit and leaving them subservient to your will!</span>")
		to_chat(target, "<span class='danger'>Your defenses have eroded away and \the [user] has made you their mindslave.</span>")
		thralls.add_antagonist(target)
		return TRUE

/datum/psionic_power/coercion/assay
	name =            "Assay"
	cost =            15
	cooldown =        100
	use_grab =        TRUE
	min_rank =        PSI_RANK_OPERANT
	use_description = "Grab a patient, target the head, then use the grab on them while on disarm intent, in order to perform a deep coercive-redactive probe of their psionic potential."

/datum/psionic_power/coercion/assay/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != BP_HEAD)
		return FALSE
	. = ..()
	if(.)
		user.visible_message(span("warning", "\The [user] holds the head of \the [target] in both hands..."))
		to_chat(user, span("notice", "You insinuate your mentality into that of \the [target]..."))
		to_chat(target, span("warning", "Your persona is being probed by the psychic lens of \the [user]."))
		if(!do_after(user, (target.stat == CONSCIOUS ? 50 : 25), target, 0, 1))
			user.psi.backblast(rand(5,10))
			return TRUE
		to_chat(user, span("notice", "You retreat from \the [target], holding your new knowledge close."))
		to_chat(target, span("danger", "Your mental complexus is laid bare to judgement of \the [user]."))
		target.show_psi_assay(user)
		return TRUE

/datum/psionic_power/coercion/focus
	name =          "Focus"
	cost =          10
	cooldown =      80
	use_grab =     TRUE
	min_rank =      PSI_RANK_MASTER
	use_description = "Grab a patient, target the mouth, then use the grab on them while on disarm intent, in order to cure ailments of the mind."

/datum/psionic_power/coercion/focus/invoke(var/mob/living/user, var/mob/living/target)
	if(user.zone_sel.selecting != "mouth")
		return FALSE
	. = ..()
	if(.)
		user.visible_message(span("warning", "\The [user] holds the head of \the [target] in both hands..."))
		to_chat(user, span("notice", "You probe \the [target]'s mind for various ailments.."))
		to_chat(target, span("warning", "Your mind is being cleansed of ailments by \the [user]."))
		if(!do_after(user, (target.stat == CONSCIOUS ? 50 : 25), target, 0, 1))
			user.psi.backblast(rand(5,10))
			return TRUE
		to_chat(user, span("warning", "You clear \the [target]'s mind of ailments."))
		to_chat(target, span("warning", "Your mind is cleared of ailments."))

		var/coercion_rank = user.psi.get_rank(PSI_COERCION)
		if(coercion_rank >= PSI_RANK_GRANDMASTER)
			target.AdjustParalysis(-1)
		target.drowsyness = 0
		if(istype(target, /mob/living/carbon))
			var/mob/living/carbon/M = target
			M.hallucination = max(M.hallucination, 10)
		return TRUE
