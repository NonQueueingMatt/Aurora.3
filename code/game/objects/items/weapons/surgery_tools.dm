/* Surgery Tools
 * Contains:
 *		Retractor
 *		Hemostat
 *		Cautery
 *		Surgical Drill
 *		Scalpel
 *		Circular Saw
 */

/*
 * Retractor
 */
/obj/item/weapon/retractor
	name = "retractor"
	desc = "Retracts stuff."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	flags = CONDUCT
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Hemostat
 */
/obj/item/weapon/hemostat
	name = "hemostat"
	desc = "You think you have seen this before."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	flags = CONDUCT
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("attacked", "pinched")
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Cautery
 */
/obj/item/weapon/cautery
	name = "cautery"
	desc = "This stops bleeding."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	matter = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 2500)
	flags = CONDUCT
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("burnt")
	drop_sound = 'sound/items/drop/scrap.ogg'

/*
 * Surgical Drill
 */
/obj/item/weapon/surgicaldrill
	name = "surgical drill"
	desc = "You can drill using this item. You dig?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	hitsound = 'sound/weapons/saw/circsawhit.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 10000)
	flags = CONDUCT
	force = 15.0
	w_class = 3
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	attack_verb = list("drilled")
	drop_sound = 'sound/items/drop/accessory.ogg'

/*
 * Scalpel
 */
/obj/item/weapon/scalpel
	name = "scalpel"
	desc = "Cut, cut, and once more cut."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	flags = CONDUCT
	force = 10.0
	sharp = 1
	edge = 1
	w_class = 1
	slot_flags = SLOT_EARS
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	drop_sound = 'sound/items/drop/knife.ogg'

/*
 * Researchable Scalpels
 */
/obj/item/weapon/scalpel/laser1
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks basic and could be improved."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"

/obj/item/weapon/scalpel/laser2
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks somewhat advanced."
	icon_state = "scalpel_laser2_on"
	damtype = "fire"
	force = 12.0

/obj/item/weapon/scalpel/laser3
	name = "laser scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field.  This one looks to be the pinnacle of precision energy cutlery!"
	icon_state = "scalpel_laser3_on"
	damtype = "fire"
	force = 15.0

/obj/item/weapon/scalpel/manager
	name = "incision management system"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	icon_state = "scalpel_manager_on"
	force = 7.5

/*
 * Circular Saw
 */
/obj/item/weapon/circular_saw
	name = "circular saw"
	desc = "For heavy duty cutting."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw3"
	hitsound = 'sound/weapons/saw/circsawhit.ogg'
	flags = CONDUCT
	force = 15.0
	w_class = 3
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 20000,"glass" = 10000)
	attack_verb = list("attacked", "slashed", "sawed", "cut")
	sharp = 1
	edge = 1
	drop_sound = 'sound/items/drop/accessory.ogg'

//misc, formerly from code/defines/weapons.dm
/obj/item/weapon/bonegel
	name = "bone gel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = 2.0
	throwforce = 1.0
	drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/weapon/FixOVein
	name = "FixOVein"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	w_class = 2.0
	var/usage_amount = 10
	drop_sound = 'sound/items/drop/accessory.ogg'

/obj/item/weapon/bonesetter
	name = "bone setter"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = 2.0
	attack_verb = list("attacked", "hit", "bludgeoned")
	drop_sound = 'sound/items/drop/scrap.ogg'

/* Alien Surgery Tools
 * Contains:
 *		Alien Retractor
 *		Alien Hemostat
 *		Alien Cautery
 *		Alien Surgical Drill
 *		Alien Scalpel
 *		Alien Circular Saw
 *		Alien Bonegel
 *		Alien Bonesetter
 *		Alien Fix-O-Vein
 *		Alien Splicer [New Item!]
 */

/obj/item/weapon/retractor/alien
	name = "alien retractor"
	desc = "(lore bastards)"
	icon = 'icons/obj/alien_tools.dmi'
	icon_state = "retractor"
	force = 10.0
	throwforce = 10.0
	matter = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 5000)
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 2)

/*
 * Hemostat
 */
/obj/item/weapon/hemostat/alien
	name = "alien hemostat"
	desc = "(lore bastards)"
	icon = 'icons/obj/alien_tools.dmi'
	icon_state = "hemostat"
	force = 10.0
	throwforce = 10.0
	matter = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 5000)
	w_class = 2.0
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 2)

/*
 * Cautery
 */
/obj/item/weapon/cautery/alien
	name = "alien cautery"
	desc = "(lore bastards)"
	icon = 'icons/obj/alien_tools.dmi'
	icon_state = "cautery"
	force = 10.0
	throwforce = 10.0
	damtype = "fire"
	matter = list(DEFAULT_WALL_MATERIAL = 15000, "glass" = 5000)
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 2)

/*
 * Surgical Drill
 */
/obj/item/weapon/surgicaldrill/alien
	name = "alien surgical drill"
	desc = "(lore bastards)"
	icon = 'icons/obj/alien_tools.dmi'
	icon_state = "drill"
	force = 20.0
	throwforce = 10.0
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 3)

/*
 * Scalpel
 */
/obj/item/weapon/scalpel/alien
	name = "alien scalpel"
	desc = "(lore bastards)"
	icon = 'icons/obj/alien_tools.dmi'
	icon_state = "scalpel"
	force = 15.0
	throwforce = 10.0
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 2)

/*
 * Circular Saw
 */
/obj/item/weapon/circular_saw/alien
	name = "alien circular saw"
	desc = "(lore bastards)"
	icon = 'icons/obj/alien_tools.dmi'
	icon_state = "saw"
	force = 20.0
	throwforce = 10.0
	origin_tech = list(TECH_MATERIAL = 4, TECH_BIO = 3)

//misc, formerly from code/defines/weapons.dm
/obj/item/weapon/bonegel/alien
	name = "alien bone gel"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = 2.0
	throwforce = 1.0
	drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/weapon/FixOVein/alien
	name = "alien FixOVein"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 3)
	w_class = 2.0
	usage_amount = 5
	drop_sound = 'sound/items/drop/accessory.ogg'

/obj/item/weapon/bonesetter/alien
	name = "alien bone setter"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = 2.0
	attack_verb = list("attacked", "hit", "bludgeoned")
	drop_sound = 'sound/items/drop/scrap.ogg'

/obj/item/weapon/splicer
	name = "alien splicer"
	desc = "A device that houses cutting lasers, capable of amputating limbs and removing organs. Injects removed organs with survival stimulants."
	description_fluff = "This device uses complex picto-factories to create infinitesimally small life support devices, while also severing the appendage effectively with cutting lasers. This allows for the clean removal of any body part except for the torso. Limbs removed by the Splicer will not die, The Splicer can also remove any organ without killing the body, except the brain."
	icon = 'icons/obj/alien_tools.dmi'
	icon_state = "splicer"
	hitsound = 'sound/weapons/bladeslice.ogg'
	flags = CONDUCT
	force = 15.0
	w_class = 3
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	damtype = "fire"
	origin_tech = list(TECH_MATERIAL = 4, TECH_BIO = 3)
	matter = list(DEFAULT_WALL_MATERIAL = 25000,"glass" = 15000)
	attack_verb = list("attacked", "lasered", "eviscerated")
	drop_sound = 'sound/items/drop/accessory.ogg'