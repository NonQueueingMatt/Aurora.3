/singleton/education
	/// The name of this education type.
	var/name
	/// The description of this education type. It should ideally match what's on the Aurora wiki, but from an IC point of view.
	var/description
	/// Age requirement for this education. Should match the job this is intended for. This doesn't need to be here per se, but it helps to filter results.
	var/list/minimum_character_age
	/// The jobs this education type allows you to access.
	var/list/jobs
	/// The given skills for this education type. Linked list of skill type to level.
	var/list/skills
	/// Species that CANNOT take this education, if necessary. This is a list of names, must match what's in the species pref variable.
	/// Empty list means no restrictions.
	var/list/species_restriction

/singleton/education/high_school
	name = "High School Diploma"
	description = "Your character has a high school diploma."
