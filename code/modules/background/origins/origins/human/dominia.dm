#define CITIZENSHIPS_DOMINIA list(CITIZENSHIP_DOMINIA, CITIZENSHIP_COALITION, CITIZENSHIP_BIESEL)
#define RELIGIONS_DOMINIA list(RELIGION_MOROZ, RELIGION_CHRISTIANITY, RELIGION_NONE)

/decl/origin_item/culture/dominia
	name = "Empire of Dominia"
	desc = "The Empire of Dominia (often simply referred to as \"the Empire\") is an autocratic monarchy that is heavily influenced by its state religion, the Moroz Holy Tribunal, which is often regarded as an offshoot of old Earth faiths. Imperial society is sharply divided between Morozians, which are themselves divided between noble Primaries and commoner Secondaries, and Ma'zals, which make up the population of its conquered worlds. Militaristic and expansionist, the Empire has been increasingly brought into conflict with its neighbors: the Serene Republic of Elyra and Coalition of Colonies. Dominians are often stereotyped as militant, religious, and egotistical."
	possible_origins = list(
		/decl/origin_item/origin/moroz,
		/decl/origin_item/origin/imperial_core_worlds,
		/decl/origin_item/origin/novi_jadran,
		/decl/origin_item/origin/imperial_frontier
	)

/decl/origin_item/origin/moroz
	name = "Moroz"
	desc = "Morozians represent the peak of Imperial society. They are the nearest to the Emperor, the Goddess, and live upon the Imperial capital planet. But Morozians themselves are not a homogenous group: they are divided between typical Morozians - both Secondaries and Primaries - rebellious Fisanduhians, which still fight to liberate what is left of their mountainous home from the wider Empire, and the nomadic Lyodii that call Moroz's icecaps home."
	possible_accents = list(ACCENT_DOMINIA_VULGAR, ACCENT_DOMINIA_HIGH, ACCENT_FISANDUH)
	possible_citizenships = CITIZENSHIPS_DOMINIA
	possible_religions = RELIGIONS_DOMINIA

/decl/origin_item/origin/imperial_core_worlds
	name = "Imperial Core Worlds"
	desc = "The Imperial Core consists of worlds colonized mostly by Morozians with little involvement by Ma'zals such as Sparta, Alterim Obrirava, and Alterim Balteulis. Much of the culture of these planets is shared with the Imperial capital of Moroz, and the pomp-and-circumstance of Dominian noble life is well alive on these worlds as well. Much of the wealth of Dominians living in the Imperial Core has been built off of resources extracted from worlds conquered by the Empire. In the Empire, to be Morozian is to bear a badge of honor - yet with that honor comes an understanding that one must act as a Morozian, and not debase oneself to the level of a Ma'zal."
	possible_accents = list(ACCENT_DOMINIA_VULGAR, ACCENT_DOMINIA_HIGH)
	possible_citizenships = CITIZENSHIPS_DOMINIA
	possible_religions = list(RELIGION_MOROZ)

/decl/origin_item/origin/novi_jadran
	name = "Novi Jadran"
	desc = "A tundra planet peacefully annexed by the Empire of Dominia fifty years ago, where the influence of the local nobles is much stronger than anywhere else. Novi Jadran is commonly viewed as a very loyal colony, with its inhabitants adhering to a mostly rural lifestyle. The planet itself is behind in many technological aspects such as electricity and urbanization, with most of the population living outside of its few large urban population centers: this is due to neglect on the local nobles' part, who prefer to host lavish parties instead."
	possible_accents = list(ACCENT_DOMINIA_VULGAR)
	possible_citizenships = CITIZENSHIPS_DOMINIA
	possible_religions = list(RELIGION_MOROZ)

/decl/origin_item/origin/imperial_frontier
	name = "Imperial Frontier"
	desc = "The Imperial Frontier consists of worlds conquered by the Empire of Dominia and mostly populated by Ma'zals. Military governments are common here, as are the often-hated viceroyalties that the Empire has become infamous for abroad. The planets of the Imperial Frontier stand at varying levels of development, but most of their resources are sent back to the region that truly matters to the Empire: the Imperial Core."
	possible_accents = list(ACCENT_DOMINIA_VULGAR, ACCENT_COC, ACCENT_NCF)
	possible_religions = list(RELIGION_NONE, RELIGION_MOROZ, RELIGION_CHRISTIANITY, RELIGION_ISLAM, RELIGION_BUDDHISM, RELIGION_HINDU, RELIGION_TAOISM, RELIGION_JUDAISM, RELIGION_OTHER)

