//http://www.youtube.com/watch?v=-1GadTfGFvU
//i could have done these as just an ordinary plant, but fuck it - there would have been too much snowflake code

/obj/machinery/apiary
	name = "apiary tray"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "hydrotray3"
	density = 1
	anchored = 1
	var/nutrilevel = 0
	var/yieldmod = 1
	var/mut = 1
	var/toxic = 0
	var/dead = 0
	var/health = -1
	var/maxhealth = 100
	var/lastcycle = 0
	var/cycledelay = 100
	var/harvestable_honey = 0
	var/beezeez = 0
	var/swarming = 0

	var/bees_in_hive = 0
	var/list/owned_bee_swarms = list()
	var/hydrotray_type = /obj/machinery/portable_atmospherics/hydroponics

//overwrite this after it's created if the apiary needs a custom machinery sprite
/obj/machinery/apiary/Initialize()
	..()
	add_overlay(image('icons/obj/apiary_bees_etc.dmi', icon_state = "apiary"))

/obj/machinery/apiary/bullet_act(var/obj/item/projectile/Proj) //Works with the Somatoray to modify plant variables.
	if(istype(Proj ,/obj/item/projectile/energy/floramut))
		mut++
	else if(istype(Proj ,/obj/item/projectile/energy/florayield))
		if(!yieldmod)
			yieldmod += 1
		else if (prob(1/(yieldmod * yieldmod) *100))//This formula gives you diminishing returns based on yield. 100% with 1 yield, decreasing to 25%, 11%, 6, 4, 2...
			yieldmod += 1
	else
		..()
		return

/obj/machinery/apiary/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/queen_bee))
		if(health > 0)
			to_chat(user, "<span class='warning'>There is already a queen in there.</span>")
		else
			health = 10
			nutrilevel += 10
			user.drop_from_inventory(O,get_turf(src))
			qdel(O)
			to_chat(user, "<span class='notice'>You carefully insert the queen into [src], she gets busy making a hive.</span>")
			bees_in_hive = 0
	else if(istype(O, /obj/item/beezeez))
		beezeez += 100
		nutrilevel += 10
		user.drop_from_inventory(O,get_turf(src))
		qdel(O)
		if(health > 0)
			to_chat(user, "<span class='notice'>You insert [O] into [src]. A relaxed humming appears to pick up.</span>")
		else
			to_chat(user, "<span class='notice'>You insert [O] into [src]. Now it just needs some bees.</span>")
		qdel(O)
	else if(istype(O, /obj/item/material/minihoe))
		if(health > 0)
			to_chat(user, "<span class='danger'>You begin to dislodge the apiary from the tray, the bees don't like that.</span>")
			angry_swarm(user)
		else
			to_chat(user, "<span class='notice'>You begin to dislodge the dead apiary from the tray.</span>")
		if(do_after(user, 50/O.toolspeed))
			new hydrotray_type(src.loc)
			new /obj/item/apiary(src.loc)
			to_chat(user, "<span class='warning'>You dislodge the apiary from the tray.</span>")
			qdel(src)
	else if(istype(O, /obj/item/bee_net))
		var/obj/item/bee_net/N = O
		if(N.caught_bees > 0)
			to_chat(user, "<span class='notice'>You empty the bees into the apiary.</span>")
			bees_in_hive += N.caught_bees
			N.caught_bees = 0
		else
			to_chat(user, "<span class='notice'>There are no more bees in the net.</span>")
	else if(istype(O, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/G = O
		if(harvestable_honey > 0)
			if(health > 0)
				to_chat(user, "<span class='warning'>You begin to harvest the honey. The bees don't seem to like it.</span>")
				angry_swarm(user)
			else
				to_chat(user, "<span class='notice'>You begin to harvest the honey.</span>")
			if(do_after(user,50/O.toolspeed))
				G.reagents.add_reagent("honey",harvestable_honey)
				harvestable_honey = 0
				to_chat(user, "<span class='notice'>You successfully harvest the honey.</span>")
		else
			to_chat(user, "<span class='notice'>There is no honey left to harvest.</span>")
	else
		angry_swarm(user)
		..()

/obj/machinery/apiary/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/apiary/machinery_process()

	if(swarming > 0)
		swarming -= 1
		if(swarming <= 0)
			for(var/mob/living/simple_animal/bee/B in src.loc)
				bees_in_hive += B.strength
				qdel(B)
	else if(bees_in_hive < 10)
		for(var/mob/living/simple_animal/bee/B in src.loc)
			bees_in_hive += B.strength
			qdel(B)

	if(world.time > (lastcycle + cycledelay))
		lastcycle = world.time
		if(health < 0)
			return

		//magical bee formula
		if(beezeez > 0)
			beezeez -= 1

			nutrilevel += 2
			health += 1
			toxic = max(0, toxic - 1)

		//handle nutrients
		nutrilevel -= bees_in_hive / 10 + owned_bee_swarms.len / 5
		if(nutrilevel > 0)
			bees_in_hive += 1 * yieldmod
			if(health < maxhealth)
				health++
		else
			//nutrilevel is less than 1, so we're effectively subtracting here
			health += max(nutrilevel - 1, round(-health / 2))
			bees_in_hive += max(nutrilevel - 1, round(-bees_in_hive / 2))
			if(owned_bee_swarms.len)
				var/mob/living/simple_animal/bee/B = pick(owned_bee_swarms)
				B.target_turf = get_turf(src)

		//clear out some toxins
		if(toxic > 0)
			toxic -= 1
			health -= 1

		if(health <= 0)
			return

		//make a bit of honey
		if(harvestable_honey < 50)
			harvestable_honey += 0.5

		//make some new bees
		if(bees_in_hive >= 10 && prob(bees_in_hive * 10))
			var/mob/living/simple_animal/bee/B = new(get_turf(src), src)
			owned_bee_swarms.Add(B)
			B.mut = mut
			B.toxic = toxic
			bees_in_hive -= 1

		//find some plants, harvest
		for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(7, src))
			if(H.seed && !H.dead && prob(owned_bee_swarms.len * 10))
				src.nutrilevel++
				H.nutrilevel++
				if(mut < H.mutation_mod - 1)
					mut = H.mutation_mod - 1
				else if(mut > H.mutation_mod - 1)
					H.mutation_mod = mut

				//flowers give us pollen (nutrients)
/* - All plants should be giving nutrients to the hive.
				if(H.myseed.type == /obj/item/seeds/harebell || H.myseed.type == /obj/item/seeds/sunflowerseed)
					src.nutrilevel++
					H.nutrilevel++
*/
				//have a few beneficial effects on nearby plants
				if(prob(10))
					H.lastcycle -= 5
				if(prob(10))
					H.seed.set_trait(TRAIT_ENDURANCE,max(H.seed.get_trait(TRAIT_ENDURANCE)*1.5,H.seed.get_trait(TRAIT_ENDURANCE)+1))
				if(H.toxins && prob(10))
					H.toxins = min(0, H.toxins - 1)
					toxic++

/obj/machinery/apiary/proc/die()
	if(owned_bee_swarms.len)
		var/mob/living/simple_animal/bee/B = pick(owned_bee_swarms)
		B.target_turf = get_turf(src)
		B.strength -= 1
		if(B.strength <= 0)
			qdel(B)
		else if(B.strength <= 5)
			B.icon_state = "bees[B.strength]"
	bees_in_hive = 0
	health = 0

/obj/machinery/apiary/proc/angry_swarm(var/mob/M)
	for(var/mob/living/simple_animal/bee/B in owned_bee_swarms)
		B.feral = 25
		B.target_mob = M

	swarming = 25

	while(bees_in_hive > 0)
		var/spawn_strength = bees_in_hive
		if(bees_in_hive >= 5)
			spawn_strength = 6

		var/mob/living/simple_animal/bee/B = new(get_turf(src), src)
		B.target_mob = M
		B.strength = spawn_strength
		B.feral = 25
		B.mut = mut
		B.toxic = toxic
		bees_in_hive -= spawn_strength

/obj/machinery/apiary/verb/harvest_honeycomb()
	set src in oview(1)
	set name = "Harvest honeycomb"
	set category = "Object"

	while(health > 15)
		health -= 15
		var/obj/item/reagent_containers/food/snacks/honeycomb/H = new(src.loc)
		if(toxic > 0)
			H.reagents.add_reagent("toxin", toxic)

	to_chat(usr, "<span class='notice'>You harvest the honeycomb from the hive. There is a wild buzzing!</span>")
	angry_swarm(usr)
