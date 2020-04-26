var/datum/controller/subsystem/materials/SSmaterials

/datum/controller/subsystem/materials
	name = "Materials"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	var/list/materials
	var/list/materials_by_name

	var/list/autolathe_recipes
	var/list/autolathe_categories

/datum/controller/subsystem/materials/New()
	NEW_SS_GLOBAL(SSmaterials)

/datum/controller/subsystem/materials/Initialize()
	create_material_lists()
	create_autolathe_lists()
	. = ..()

/datum/controller/subsystem/materials/proc/create_material_lists()
	if(LAZYLEN(materials))
		return

	materials = list()
	materials_by_name = list()

	for(var/M in subtypesof(/material))
		var/material/material = new M
		if(material.name)
			materials += material
			materials_by_name[lowertext(material.name)] = material

/datum/controller/subsystem/materials/proc/create_autolathe_lists()
	if(LAZYLEN(autolathe_recipes))
		return
	
	autolathe_recipes = list()
	autolathe_categories = list()

	for(var/R in subtypesof(/datum/autolathe/recipe))
		var/datum/autolathe/recipe/recipe = new R
		if(!recipe.category)
			log_ss("Materials", "Recipe with no category: [recipe.type].")
		if(!recipe.name)
			log_ss("Materials", "Recipe with no name: [recipe.type].")
		autolathe_recipes[recipe.name] = recipe
		autolathe_categories |= recipe.category

		var/obj/item/I = new recipe.path

		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = round(I.matter[material]*1.25) // More expensive to produce than they are to recycle.
		qdel(I)

/datum/controller/subsystem/materials/proc/get_material_by_name(var/M)
	if(!materials_by_name)
		create_material_lists()
	. = materials_by_name[M]
	if(!.)
		log_debug("Material not found: [M].")

/datum/controller/subsystem/materials/proc/material_display_name(var/M)
	var/material/material = get_material_by_name(M)
	if(material)
		return material.display_name
