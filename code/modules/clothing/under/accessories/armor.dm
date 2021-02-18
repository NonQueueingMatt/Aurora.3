//Leg guards.
/obj/item/clothing/accessory/leg_guard
	name = "corporate leg guards"
	desc = "These will protect your legs and feet."
	desc_info = "These items must be hooked onto plate carriers for them to work!"
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "legguards_sec"
	w_class = ITEMSIZE_NORMAL
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	body_parts_covered = LEGS|FEET
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/boots.ogg'
	pickup_sound = 'sound/items/pickup/boots.ogg'

/obj/item/clothing/accessory/leg_guard/Initialize()
	. = ..()
	overlay_state = "[icon_state]_overlay"
	update_icon()

/obj/item/clothing/accessory/leg_guard/ablative
	name = "ablative leg guards"
	desc = "These will protect your legs and feet from energy weapons."
	icon_state = "legguards_ablative"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/ballistic
	name = "ballistic leg guards"
	desc = "These will protect your legs and feet from ballistic weapons."
	icon_state = "legguards_ballistic"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/riot
	name = "riot leg guards"
	desc = "These will protect your legs and feet from close combat weapons."
	icon_state = "legguards_riot"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/military
	name = "military leg guards"
	desc = "These will protect your legs and feet from most things."
	icon_state = "legguards_military"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/leg_guard/heavy
	name = "heavy leg guards"
	desc = "These leg guards will protect your legs and feet from most things."
	icon_state = "legguards_heavy"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)

//Arm guards.
/obj/item/clothing/accessory/arm_guard
	name = "corporate arm guards"
	desc = "These arm guards will protect your hands and arms."
	icon = 'icons/clothing/kit/modular_armor.dmi'
	icon_state = "armguards_sec"
	body_parts_covered = HANDS|ARMS
	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)
	w_class = ITEMSIZE_NORMAL
	contained_sprite = TRUE
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/clothing/accessory/arm_guard/Initialize()
	. = ..()
	overlay_state = "[icon_state]_overlay"
	update_icon()

/obj/item/clothing/accessory/arm_guard/ablative
	name = "ablative arm guards"
	desc = "These arm guards will protect your hands and arms from energy weapons."
	icon_state = "armguards_ablative"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_RESISTANT
	)

/obj/item/clothing/accessory/arm_guard/ballistic
	name = "ballistic arm guards"
	desc = "These arm guards will protect your hands and arms from ballistic weapons."
	icon_state = "armguards_ballistic"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR
	)

/obj/item/clothing/accessory/arm_guard/riot
	name = "riot arm guards"
	desc = "These arm guards will protect your hands and arms from close combat weapons."
	icon_state = "armguards_riot"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR
	)

/obj/item/clothing/accessory/arm_guard/military
	name = "military arm guards"
	desc = "These arm guards will protect your hands and arms from most things."
	icon = 'icons/clothing/kit/heavy_armor.dmi'
	item_state = "armguards_military"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/clothing/accessory/arm_guard/heavy
	name = "heavy arm guards"
	desc = "These arm guards will protect your hands and arms from most things."
	icon = 'icons/clothing/kit/heavy_armor.dmi'
	item_state = "armguards_heavy"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
