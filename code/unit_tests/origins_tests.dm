/datum/unit_test/cultures
	name = "Cultures Test - All cultures shall be filled out"

/datum/unit_test/cultures/start_test()
	var/failures = 0
	var/list/decl/origin_item/culture/all_cultures = decls_repository.get_decls_of_subtype(/decl/origin_item/culture)
	for(var/decl/origin_item/culture/OC as anything in all_cultures)
		if(!istext(OC.name))
			log_unit_test("Culture [OC.name] does not have a name!")
			failures++
		if(!istext(OC.desc))
			log_unit_test("Culture [OC.name] does not have a description!")
			failures++
		if(!islist(OC.possible_origins))
			log_unit_test("Culture [OC.name]'s possible_origins list is not a list!")
			failures++
		if(!length(OC.possible_origins))
			log_unit_test("Culture [OC.name] does not have any possible origins!")
			failures++
	if(failures)
		fail("[failures] error(s) found.")
	else
		pass("All cultures are filled out properly.")
	return TRUE

/datum/unit_test/origins
	name = "Origins Test - All origins shall be filled out"

/datum/unit_test/origins/start_test()
	var/failures = 0
	var/list/decl/origin_item/origin/all_origins = decls_repository.get_decls_of_subtype(/decl/origin_item/origin)
	for(var/decl/origin_item/origin/OI as anything in all_origins)
		if(!istext(OI.name))
			log_unit_test("Origin [OI.name] does not have a name!")
			failures++
		if(!istext(OI.desc))
			log_unit_test("Origin [OI.name] does not have a description!")
			failures++
		if(!islist(OI.possible_accents) || !islist(OI.possible_citizenships) || !islist(OI.possible_religions))
			log_unit_test("Origin [OI.name] is missing at least one list in the possible accents, citizenships or religions!")
			failures++
		if(!length(OI.possible_accents) || !length(OI.possible_citizenships) || !length(OI.possible_religions))
			log_unit_test("Origin [OI.name] is missing at least one entry in the possible accents, citizenships or religions lists!")
			failures++
	if(failures)
		fail("[failures] error(s) found.")
	else
		pass("All origins are filled out properly.")
	return TRUE