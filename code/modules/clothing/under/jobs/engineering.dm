//Contains: Engineering department jumpsuits
/obj/item/clothing/under/rank/chief_engineer
	name = "chief engineer's jumpsuit"
	desc = "It's a high visibility jumpsuit given to those engineers insane enough to achieve the rank of \"Chief engineer\". It has minor radiation shielding."
	icon_state = "chiefengineer"
	item_state = "g_suit"
	worn_state = "chief"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/atmospheric_technician
	name = "atmospheric technician's jumpsuit"
	desc = "It's a jumpsuit worn by atmospheric technicians."
	icon_state = "atmos"
	item_state = "atmos_suit"
	worn_state = "atmos"
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/engineer
	name = "engineer's jumpsuit"
	desc = "It's an orange high visibility jumpsuit worn by engineers. It has minor radiation shielding."
	icon_state = "engineer"
	item_state = "engi_suit"
	worn_state = "engineer"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/engineer/apprentice
	name = "engineering apprentice's jumpsuit"
	icon_state = "apprentice"
	item_state = "apprentice"
	
/obj/item/clothing/under/rank/roboticist
	name = "roboticist's jumpsuit"
	desc = "It's a slimming black jumpsuit with reinforced seams; great for industrial work."
	icon_state = "robotics"
	item_state = "bl_suit"
	worn_state = "robotics"
	siemens_coefficient = 0.75
