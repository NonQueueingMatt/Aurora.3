/obj/structure/flora
	name = "flora parent object"
	desc = DESC_PARENT
	anchored = TRUE
	density = TRUE

/obj/structure/flora/tree
	name = "tree"
	desc = "A tree."
	density = TRUE
	layer = 9
	pixel_x = -16

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "pine_[rand(1, 3)]"

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree/jungle/small/patience
	name = "Patience"
	desc = "A lush and healthy tree. A small golden plaque at its base reads its name, in plain text, Patience."
	icon_state = "patiencebottom"
	density = FALSE
	layer = 3

/obj/structure/flora/tree/jungle/small/patience_top
	name = "Patience"
	desc = "A lush and healthy tree. A small golden plaque at its base reads its name, in plain text, Patience."
	icon_state = "patiencetop"
	density = TRUE
	pixel_y = -32

/obj/structure/flora/tree/jungle/small/patience/Initialize()
	. = ..()
	var/turf/T = get_step(src, NORTH)
	if(T)
		new /obj/structure/flora/tree/jungle/small/patience_top(T)

// Rocks
/obj/structure/flora/rock
	name = "rock"
	desc = "A rock."
	icon = 'icons/obj/flora/rocks_grey.dmi'
	icon_state = "basalt"

/obj/structure/flora/rock/pile
	name = "rocks"
	desc = "A pile of rocks."
	icon_state = "lavarocks"

/obj/structure/flora/rock/ice
	name = "ice"
	desc = "A large formation made of ice."
	icon = 'icons/obj/flora/ice_rocks.dmi'
	icon_state = "rock_1"

/obj/structure/flora/rock/ice/Initialize(mapload)
	. = ..()
	icon_state = "rock_[rand(1,2)]"

// Bushes, Flowers, and Grass
/obj/structure/flora/ausbushes
	name = "bush"
	desc = "A bush."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	density = FALSE

/obj/structure/flora/ausbushes/New()
	..()
	icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/material/scythe))
		if(prob(50))
			new /obj/item/stack/material/wood(get_turf(src), 2)
		if(prob(40))
			new /obj/item/stack/material/wood(get_turf(src), 4)
		if(prob(10))
			var/pickberry = pick(list(/obj/item/seeds/berryseed, /obj/item/seeds/blueberryseed))
			new /obj/item/stack/material/wood(get_turf(src), 4)
			new pickberry(get_turf(src), 4)
			to_chat(user, SPAN_NOTICE("You find some seeds as you hack the bush away."))
		to_chat(user, SPAN_NOTICE("You slice at the bush!"))
		qdel(src)
		playsound(src, 'sound/effects/woodcutting.ogg', 50, TRUE)
	if(istype(W, /obj/item/material/hatchet)) // No items.
		to_chat(user, SPAN_NOTICE("You chop at the bush!"))
		qdel(src)
		playsound(src, 'sound/effects/woodcutting.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/New()
	..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/New()
	..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/New()
	..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/New()
	..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/New()
	..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/New()
	..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/New()
	..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/New()
	..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/New()
	..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/New()
	..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/New()
	..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/New()
	..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/New()
	..()
	icon_state = "ppflowers_[rand(1, 4)]"

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/New()
	..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/New()
	..()
	icon_state = "fullgrass_[rand(1, 3)]"