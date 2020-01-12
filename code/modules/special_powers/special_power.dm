/datum/special_power
	var/name             // Name. If null, the power won't be generated on roundstart.
	var/cost             // Base stamina cost for using this power.
	var/cooldown         // Deciseconds cooldown after using this power.
	var/use_ranged       // This power functions from a distance.
	var/use_melee        // This power functions at melee range.
	var/use_grab         // This power has a variant invoked via grab.
	var/use_manifest     // This power manifests an item in the user's hands.
	var/admin_log = TRUE // Whether or not using this power prints an admin attack log.
	var/use_description  // A short description of how to use this power, shown via assay.
	// A sound effect to play when the power is used.
	var/use_sound = 'sound/effects/psi/power_used.ogg'

/datum/special_power/proc/invoke(var/mob/living/user, var/atom/target) //Proc called when invoking the power.
	return

/datum/special_power/psionic/proc/handle_post_power(var/mob/living/user, var/atom/target) //Proc called after the power is invoked.
	return
