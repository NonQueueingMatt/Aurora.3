/singleton/skill
	/// The displayed name of the skill.
	var/name
	/// A description of this skill's effects.
	var/description
	/// The maximum level someone with no education can reach in this skill. Typically, this should be FAMILIAR on occupational skills.
	/// If null, then there is no cap.
	var/uneducated_skill_cap
	/// The maximum level this skill can reach.
	var/maximum_level = SKILL_LEVEL_TRAINED
	/// The category of this skill. Used for sorting, typically.
	var/category
	/// The sub-category of this skill. Used to better sort skills.
	var/subcategory

/singleton/skill/proc/get_maximum_level(var/singleton/education/education)
	if(!istype(education))
		crash_with("SKILL: Invalid [education] fed to get_maximum_level!")

	// If there is no uneducated skill cap, it means we can always pick the maximum level.
	if(!uneducated_skill_cap)
		return maximum_level

	// Otherwise, we need to check the education...
	if(type in education.skills)
		return education.skills[type]


	return uneducated_skill_cap
