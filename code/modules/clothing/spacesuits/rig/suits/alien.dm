/obj/item/weapon/rig/unathi
	name = "NT breacher chassis control module"
	desc = "A cheap NT knock-off of an Unathi battle-rig. Looks like a fish, moves like a fish, steers like a cow."
	suit_type = "NT breacher"
	icon_state = "breacher_rig_cheap"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 60, bomb = 70, bio = 100, rad = 50)
	emp_protection = -20
	slowdown = 6
	offline_slowdown = 10
	vision_restriction = TINT_HEAVY
	offline_vision_restriction = TINT_BLIND

	species_restricted = list("Unathi")

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT

/obj/item/weapon/rig/unathi/fancy
	name = "breacher chassis control module"
	desc = "An authentic Unathi breacher chassis. Huge, bulky and absurdly heavy. It must be like wearing a tank."
	suit_type = "breacher chassis"
	icon_state = "breacher_rig"
	armor = list(melee = 90, bullet = 90, laser = 90, energy = 90, bomb = 90, bio = 100, rad = 80) //Takes TEN TIMES as much damage to stop someone in a breacher. In exchange, it's slow.
	vision_restriction = 0
	slowdown = 4
	vision_restriction = TINT_NONE

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_SPECIAL


/obj/item/weapon/rig/vaurca
	name = "combat exoskeleton control module"
	desc = "An ancient piece of equipment from a bygone age, This highly advanced Vaurcan technology rarely sees use outside of a battlefield."
	suit_type = "combat exoskeleton"
	icon_state = "vaurca_rig"
	armor = list(melee = 65, bullet = 65, laser = 100, energy = 100, bomb = 90, bio = 100, rad = 80)
	vision_restriction = 0
	slowdown = 2
	offline_slowdown = 3

	species_restricted = list("Vaurca")

	helm_type = /obj/item/clothing/head/helmet/space/rig/vaurca
	air_type =   /obj/item/weapon/tank/phoron

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy)

	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/chem_dispenser/vaurca,
		/obj/item/rig_module/boring,
		/obj/item/rig_module/lattice,
		/obj/item/rig_module/maneuvering_jets

		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_VAURCA

/obj/item/weapon/rig/vaurca/minimal
	initial_modules = list(/obj/item/rig_module/chem_dispenser/vaurca)

/obj/item/clothing/head/helmet/space/rig/vaurca
	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/weapon/rig/vaurca/adaptive
	name = "adaptive alien exoskeleton control module"
	desc = "An ancient piece of equipment from a bygone age, This highly advanced Vaurcan technology rarely sees use outside of a battlefield."
	suit_type = "adaptive alien exoskeleton"
	icon_state = "vaurca_rig"
	var/armourmod = 1
	armor = list(melee = 65, bullet = 65, laser = 65, energy = 65, bomb = 90, bio = 100, rad = 80)
	vision_restriction = 0
	slowdown = 2
	offline_slowdown = 3

	species_restricted = list("Vaurca")

	chest_type = /obj/item/clothing/suit/space/rig/vaurca/adaptive
	helm_type = /obj/item/clothing/head/helmet/space/rig/vaurca/adaptive
	boot_type =  /obj/item/clothing/shoes/magboots/rig/vaurca/adaptive
	glove_type = /obj/item/clothing/gloves/rig/vaurca/adaptive
	air_type =   /obj/item/weapon/tank/phoron

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy)

	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/chem_dispenser/vaurca,
		/obj/item/rig_module/boring,
		/obj/item/rig_module/lattice,
		/obj/item/rig_module/maneuvering_jets
		)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_VAURCA

// ADAPTIVE HEAD

/obj/item/clothing/head/helmet/space/rig/vaurca/adaptive
	var/armourmod = 1
	light_overlay = "helmet_light_dual_green"
	light_color = "#3e7c3e"

/obj/item/clothing/head/helmet/space/rig/vaurca/adaptive/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	switch(armourmod)
		if(1)
			armourmod = 2
			armor = list(melee = 70, bullet = 70, laser = 70, energy = 70, bomb = 90, bio = 100, rad = 85)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
		if(2)
			armourmod = 3
			armor = list(melee = 75, bullet = 75, laser = 75, energy = 75, bomb = 95, bio = 100, rad = 90)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
		if(3)
			armourmod = 4
			armor = list(melee = 85, bullet = 85, laser = 85, energy = 85, bomb = 95, bio = 100, rad = 90)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
	return 0

// ADAPTIVE GLOVES
/obj/item/clothing/gloves/rig/vaurca/adaptive
	var/armourmod = 1

/obj/item/clothing/gloves/rig/vaurca/adaptive/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	switch(armourmod)
		if(1)
			armourmod = 2
			armor = list(melee = 70, bullet = 70, laser = 70, energy = 70, bomb = 90, bio = 100, rad = 85)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
		if(2)
			armourmod = 3
			armor = list(melee = 75, bullet = 75, laser = 75, energy = 75, bomb = 95, bio = 100, rad = 90)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
		if(3)
			armourmod = 4
			armor = list(melee = 85, bullet = 85, laser = 85, energy = 85, bomb = 95, bio = 100, rad = 90)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
	return 0

// ADAPTIVE BOOTS

/obj/item/clothing/shoes/magboots/rig/vaurca/adaptive
	var/armourmod = 1

/obj/item/clothing/shoes/magboots/rig/vaurca/adaptive/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	switch(armourmod)
		if(1)
			armourmod = 2
			armor = list(melee = 70, bullet = 70, laser = 70, energy = 70, bomb = 90, bio = 100, rad = 85)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
		if(2)
			armourmod = 3
			armor = list(melee = 75, bullet = 75, laser = 75, energy = 75, bomb = 95, bio = 100, rad = 90)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
		if(3)
			armourmod = 4
			armor = list(melee = 85, bullet = 85, laser = 85, energy = 85, bomb = 95, bio = 100, rad = 90)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
	return 0

//ADAPTIVE CHEST

/obj/item/clothing/suit/space/rig/vaurca/adaptive
	var/armourmod = 1

/obj/item/clothing/suit/space/rig/vaurca/adaptive/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	switch(armourmod)
		if(1)
			armourmod = 2
			armor = list(melee = 70, bullet = 70, laser = 70, energy = 70, bomb = 90, bio = 100, rad = 85)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
		if(2)
			armourmod = 3
			armor = list(melee = 75, bullet = 75, laser = 75, energy = 75, bomb = 95, bio = 100, rad = 90)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
		if(3)
			armourmod = 4
			armor = list(melee = 85, bullet = 85, laser = 85, energy = 85, bomb = 95, bio = 100, rad = 90)
			to_chat(user, "<span class='alien'>Your armour adapts to the attack, hardening!</span>")
	return 0


/obj/item/weapon/rig/tesla
	name = "tesla suit control module"
	desc = "A tajaran hardsuit designated to be used by the special forces of the Tesla Brigade."
	suit_type = "tesla suit"
	icon_state = "tesla_rig"
	armor = list(melee = 70, bullet = 50, laser = 35, energy = 15, bomb = 55, bio = 100, rad = 60)
	vision_restriction = 0
	slowdown = 2
	offline_slowdown = 3
	siemens_coefficient = 0

	species_restricted = list("Tajara")

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy)

	initial_modules = list(
		/obj/item/rig_module/actuators/combat,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/tesla_coil,
		/obj/item/rig_module/mounted/tesla)

	allowed_module_types = MODULE_GENERAL | MODULE_LIGHT_COMBAT | MODULE_HEAVY_COMBAT | MODULE_UTILITY