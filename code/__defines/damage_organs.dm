// Damage things. TODO: Merge these down to reduce on defines.
// Way to waste perfectly good damage-type names (BRUTE) on this... If you were really worried about case sensitivity, you could have just used lowertext(damagetype) in the proc.
#define BRUTE     "brute"
#define BURN      "fire"
#define TOX       "tox"
#define OXY       "oxy"
#define CLONE     "clone"
#define PAIN      "pain"

#define CUT       "cut"
#define BRUISE    "bruise"
#define PIERCE    "pierce"

#define DAM_LASER  1
#define DAM_BULLET 2

#define STUN      "stun"
#define WEAKEN    "weaken"
#define PARALYZE  "paralize"
#define IRRADIATE "irradiate"
#define SLUR      "slur"
#define STUTTER   "stutter"
#define EYE_BLUR  "eye_blur"
#define DROWSY    "drowsy"
#define INCINERATE "incinerate"

#define FIRE_DAMAGE_MODIFIER 0.0215 // Higher values result in more external fire damage to the skin. (default 0.0215)
#define  AIR_DAMAGE_MODIFIER 2.025  // More means less damage from hot air scalding lungs, less = more damage. (default 2.025)

// Organ defines.
#define ORGAN_CUT_AWAY   (1<<0)
#define ORGAN_BLEEDING   (1<<1)
#define ORGAN_BROKEN     (1<<2)
#define ORGAN_DESTROYED  (1<<3)
#define ORGAN_ROBOT      (1<<4)
#define ORGAN_SPLINTED   (1<<5)
#define ORGAN_DEAD       (1<<6)
#define ORGAN_MUTATED    (1<<7)
#define ORGAN_ASSISTED   (1<<8)
#define ORGAN_ADV_ROBOT  (1<<9)
#define ORGAN_PLANT      (1<<10)
#define ORGAN_ARTERY_CUT (1<<11)
#define ORGAN_TENDON_CUT (1<<12)

#define DROPLIMB_EDGE 0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN 2

// Damage above this value must be repaired with surgery.
#define ROBOLIMB_SELF_REPAIR_CAP 30

//Germs and infections.
#define GERM_LEVEL_AMBIENT  110 // Maximum germ level you can reach by standing still.
#define GERM_LEVEL_MOVE_CAP 200 // Maximum germ level you can reach by running around.

#define INFECTION_LEVEL_ONE   100
#define INFECTION_LEVEL_TWO   500
#define INFECTION_LEVEL_THREE 1000

//Blood levels. These are percentages based on the species blood_volume far.
#define BLOOD_VOLUME_SAFE    85
#define BLOOD_VOLUME_OKAY    70
#define BLOOD_VOLUME_BAD     60
#define BLOOD_VOLUME_SURVIVE 30
