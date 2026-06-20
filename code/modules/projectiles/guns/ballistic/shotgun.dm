//IN THIS DOCUMENT: Shotgun template, Double barrel shotguns, Pump-action shotguns, Semi-auto shotgun
// See gun.dm for keywords and the system used for gun balance



//////////////////////
// SHOTGUN TEMPLATE //
//////////////////////


/obj/item/gun/ballistic/shotgun
	slowdown = 0.3 //Bulky gun slowdown with rebate since generally smaller than assault rifles
	name = "shotgun template"
	desc = "Should not exist"
	icon = 'icons/fallout/objects/guns/ballistic.dmi'
	lefthand_file = 'icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_prefix = "shotgun"
	icon_state = "shotgun"
	item_state = "shotgun"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot
	force = 15 //Decent clubs generally speaking
	fire_delay = 4 //Typical pump action, pretty fast.
	spread = 2
	recoil = 1
	can_scope = FALSE
	flags_1 =  CONDUCT_1
	casing_ejector = FALSE
	var/recentpump = 0 // to prevent spammage
	spawnwithmagazine = TRUE
	var/pump_sound = 'sound/weapons/shotgunpump.ogg'
	fire_sound = 'sound/f13weapons/shotgun.ogg'
	insert_sound = 'sound/weapons/guns/insert_shell_shot.ogg'


/obj/item/gun/ballistic/shotgun/process_chamber(mob/living/user, empty_chamber = 0)
	return ..() //changed argument value

/obj/item/gun/ballistic/shotgun/can_shoot()
	return !!chambered?.BB

/obj/item/gun/ballistic/shotgun/attack_self(mob/living/user)
	if(recentpump > world.time)
		return
	pump(user, TRUE)
	if(HAS_TRAIT(user, TRAIT_FAST_PUMP))
		recentpump = world.time + 2
	else
		recentpump = world.time + 10

/obj/item/gun/ballistic/shotgun/blow_up(mob/user)
	. = 0
	if(chambered && chambered.BB)
		process_fire(user, user, FALSE)
		. = 1

/obj/item/gun/ballistic/shotgun/proc/pump(mob/M, visible = TRUE)
	if(visible)
		M.visible_message("<span class='warning'>[M] racks [src].</span>", "<span class='warning'>You rack [src].</span>")
	playsound(M, pump_sound, 60, 1)
	pump_unload(M)
	pump_reload(M)
	update_icon()	//I.E. fix the desc
	return 1

/obj/item/gun/ballistic/shotgun/proc/pump_unload(mob/M)
	if(chambered)//We have a shell in the chamber
		chambered.forceMove(drop_location())//Eject casing
		chambered.bounce_away()
		chambered = null

/obj/item/gun/ballistic/shotgun/proc/pump_reload(mob/M)
	if(!magazine.ammo_count())
		return 0
	var/obj/item/ammo_casing/AC = magazine.get_round() //load next casing.
	chambered = AC

/obj/item/gun/ballistic/shotgun/examine(mob/user)
	. = ..()
	if (chambered)
		. += "A [chambered.BB ? "live" : "spent"] one is in the chamber."

/obj/item/gun/ballistic/shotgun/lethal
	mag_type = /obj/item/ammo_box/magazine/internal/shot/lethal



////////////////////////////////////////
//DOUBLE BARREL & PUMP ACTION SHOTGUNS//
////////////////////////////////////////


//Caravan shotgun							Keywords: Shotgun, Double barrel, saw-off, extra damage +3, extra pen 5%
/obj/item/gun/ballistic/revolver/caravan_shotgun
	name = "caravan shotgun"
	desc = "A beat-up pre-war European style over/under double barrel shotgun. It still works, surprisingly."
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	lefthand_file = 'icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "caravan"
	item_state = "shotgundouble"
	icon_prefix = "shotgundouble"
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_delay = 2
	spread = 20
	force = 20
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/simple
	sawn_desc = "A beat-up pre-war European style over/under double barrel shotgun. The stock has been mostly sawn away, and so has the barrel."
	fire_sound = 'sound/f13weapons/caravan_shotgun.ogg'
	recoil = 1.55

/obj/item/gun/ballistic/revolver/caravan_shotgun/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/circular_saw) || istype(A, /obj/item/gun/energy/plasmacutter) | istype(A, /obj/item/twohanded/chainsaw))
		sawoff(user)
	if(istype(A, /obj/item/melee/transforming/energy))
		var/obj/item/melee/transforming/energy/W = A
		if(W.active)
			sawoff(user)

/obj/item/gun/ballistic/revolver/caravan_shotgun/update_icon_state()
	if(sawn_off)
		icon_state = "[initial(icon_state)]-sawn"
	else if(!magazine || !magazine.ammo_count(0))
		icon_state = "[initial(icon_state)]-e"
	else
		icon_state = "[initial(icon_state)]"


//Widowmaker				Keywords: Shotgun, Double barrel, saw-off, extra damage +2, extra pen 15%
/obj/item/gun/ballistic/revolver/widowmaker
	name = "coach gun"
	desc = "An All-American wild west classic, courtesy of Winchester. Omar's coming!"
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	lefthand_file = 'icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "widowmaker"
	item_state = "shotgundouble"
	icon_prefix = "shotgundouble"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_delay = 2
	spread = 20
	force = 20
	sawn_desc = "...\"What is this, a pirate gun?\"..."
	fire_sound = 'sound/f13weapons/max_sawn_off.ogg'
	recoil = 0.55

/obj/item/gun/ballistic/revolver/widowmaker/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/circular_saw) || istype(A, /obj/item/gun/energy/plasmacutter) | istype(A, /obj/item/twohanded/chainsaw))
		sawoff(user)
	if(istype(A, /obj/item/melee/transforming/energy))
		var/obj/item/melee/transforming/energy/W = A
		if(W.active)
			sawoff(user)

/obj/item/gun/ballistic/revolver/widowmaker/update_icon_state()
	if(sawn_off)
		icon_state = "[initial(icon_state)]-sawn"
	else if(!magazine || !magazine.ammo_count(0))
		icon_state = "[initial(icon_state)]-e"
	else
		icon_state = "[initial(icon_state)]"

//Single shotgun
/obj/item/gun/ballistic/revolver/singleshotgun
	name = "single-shot shotgun"
	desc = "An old-world New England Pardner shotgun, 2077 production line - right before the nukes."
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	lefthand_file = 'icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "single"
	item_state = "shotgundouble"
	icon_prefix = "single"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/pardner
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10 //More or less the AMR's firing delay. To prevent instant reload firing.
	force = 10
	slowdown = 0.1
	extra_damage = 4
	extra_penetration = 0.05

/obj/item/gun/ballistic/revolver/singleshotgun/axe
	name = "'77 hatchet shotgun"
	desc = "A New England Pardner that has been sawn down and had a fireaxe tightly attached to the barrel. The stock has been replaced by something more comfortable to hold on to."
	icon_state = "singleaxe"
	slowdown = 0.08
	force = 35
	armour_penetration = 0.1 //Not for the bullet. This is the gun.
	wound_bonus = 15 //Same as above
	extra_damage = 2 //Half of parent
	icon_prefix = "singleaxe"
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'

//Hunting shotgun				Keywords: Shotgun, Pump-action, 4 rounds
/obj/item/gun/ballistic/shotgun/hunting
	name = "hunting shotgun"
	desc = "The pinnacle of firearms engineering, a pump-action shotgun with wood furniture. With its 12 gauge chamber, it doesn't matter what you're hunting - it'll go down."
	icon_state = "hunting"
	item_state = "shotgunpump"
	icon_prefix = "hunting"
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	mag_type = /obj/item/ammo_box/magazine/internal/shot/lethal
	fire_delay = 3

/obj/item/gun/ballistic/shotgun/hunting/update_icon_state()
	if(sawn_off)
		icon_state = "[initial(icon_state)]-sawn"
	else if(!magazine || !magazine.ammo_count(0))
		icon_state = "[initial(icon_state)]-e"
	else
		icon_state = "[initial(icon_state)]"


//Police Shotgun				Keywords: Shotgun, Pump-action, 6 rounds, Folding stock, Flashlight rail
/obj/item/gun/ballistic/shotgun/police
	name = "police shotgun"
	desc = "A pre-war pump-action SPAS-12 shotgun that was widely adopted by police institutions across the European Commonwealth and United States."
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	icon_state = "police"
	item_state = "shotgunpolice"
	icon_prefix = "police"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/police
	w_class = WEIGHT_CLASS_NORMAL
	recoil = 0.5
	fire_delay = 3
	var/stock = FALSE
	can_flashlight = TRUE
	gunlight_state = "flightangle"
	flight_x_offset = 23
	flight_y_offset = 21

/obj/item/gun/ballistic/shotgun/police/AltClick(mob/living/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	toggle_stock(user)
	return TRUE

/obj/item/gun/ballistic/shotgun/police/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to toggle the stock.</span>"

/obj/item/gun/ballistic/shotgun/police/proc/toggle_stock(mob/living/user)
	stock = !stock
	if(stock)
		w_class = WEIGHT_CLASS_BULKY
		to_chat(user, "You unfold the stock.")
		recoil = 0.1
		spread = 0
	else
		w_class = WEIGHT_CLASS_NORMAL
		to_chat(user, "You fold the stock.")
		recoil = 0.5
	update_icon()

/obj/item/gun/ballistic/shotgun/police/update_icon_state()
	icon_state = "[current_skin ? unique_reskin[current_skin] : "police"][stock ? "" : "fold"]"


//Trench shotgun					Keywords: Shotgun, Pump-action, 5 rounds, Bayonet
/obj/item/gun/ballistic/shotgun/trench
	name = "trench shotgun"
	desc = "A pump-action combat shotgun that can take a bayonet, with a blisteringly fast rate of fire. Banned by NO international conventions."
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	icon_state = "trench"
	item_state = "shotguntrench"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/trench
	var/select = 0
	actions_types = list(/datum/action/item_action/toggle_firemode)
	can_bayonet = TRUE
	fire_delay = 2
	bayonet_state = "bayonet"
	knife_x_offset = 24
	knife_y_offset = 22

/obj/item/gun/ballistic/shotgun/trench/update_icon_state()
	if(!magazine || !magazine.ammo_count(0))
		icon_state = "[initial(icon_state)]-e"
	else
		icon_state = "[initial(icon_state)]"


///////////////////////////
//SEMI-AUTOMATIC SHOTGUNS//
///////////////////////////

//Semi-auto shotgun template
/obj/item/gun/ballistic/shotgun/automatic/combat
	name = "semi-auto shotgun template"
	fire_delay = 6
	recoil = 0.1
	spread = 2

/obj/item/gun/ballistic/shotgun/automatic/shoot_live_shot(mob/living/user, pointblank = FALSE, mob/pbtarget, message = 1, stam_cost = 0)
	..()
	src.pump(user)

/obj/item/gun/ballistic/shotgun/automatic/combat/update_icon_state()
	if(!magazine || !magazine.ammo_count(0))
		icon_state = "[initial(icon_state)]-e"
	else
		icon_state = "[initial(icon_state)]"

//Browning Auto-5						Keywords: Shotgun, Semi-auto, 4 rounds internal
/obj/item/gun/ballistic/shotgun/automatic/combat/auto5
	name = "repeating shotgun"
	desc = "The crown jewel of self-loading shotguns, Browning's own Auto-5. It was the first commercially succesful semi-automatic shotgun ever made."
	fire_delay = 5
	recoil = 2
	icon_state = "auto5"
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	item_state = "shotgunauto5"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/com/compact
	fire_sound = 'sound/f13weapons/auto5.ogg'
	insert_sound = 'sound/weapons/guns/insert_shell_auto.ogg'

//Lever action shotgun					Keywords: Shotgun, Lever-action, 5 round magazine, Pistol grip
/obj/item/gun/ballistic/shotgun/automatic/combat/shotgunlever
	name = "lever action shotgun"
	desc = "An old-timey sawn down Model 1887 lever action shotgun that was quickly forgotten due to the existence of other more effective repeating shotguns. It looks cool, though."
	icon_state = "lever"
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	item_state = "shotgunlever"
	icon_prefix = "lever"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/trench
	fire_delay = 6
	slowdown = 0.25
	recoil = 2.1
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	fire_sound = 'sound/f13weapons/shotgun.ogg'
	can_bayonet = TRUE
	bayonet_state = "bayonet"
	knife_x_offset = 23
	knife_y_offset = 23

//Winchester City-Killer				Keywords: Shotgun, Full-auto, 10 rounds internal
/obj/item/gun/ballistic/shotgun/automatic/combat/citykiller
	name = "combat shotgun"
	desc = "A bullpup variant of the Winchester City-Killer combat shotgun in excellent condition. It's been fitted with the DesertWarfare© environmental sealant modification for extra reliability."
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	icon_state = "citykiller"
	item_state = "shotguncity"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/com/citykiller
	fire_delay = 5
	autofire_shot_delay = 4.15
	automatic = 1
	fire_sound = 'sound/f13weapons/riot_shotgun.ogg'
	insert_sound = 'sound/weapons/guns/insert_shell_auto.ogg'


//Riot shotgun							Keywords: Shotgun, Semi-auto, 12 round magazine, Pistol grip
/obj/item/gun/ballistic/automatic/shotgun/riot
	name = "riot shotgun"
	desc = "An accurate long-barreled semi-automatic shotgun designed for riot control use by the National Guard. It takes drum magazines."
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	lefthand_file = 'icons/fallout/onmob/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/fallout/onmob/weapons/guns_righthand.dmi'
	icon_state = "riot"
	item_state = "shotgunriot"
	w_class = WEIGHT_CLASS_BULKY
	mag_type = /obj/item/ammo_box/magazine/d12g
	fire_delay = 4
	burst_size = 1
	recoil = 1.1
	automatic_burst_overlay = FALSE
	semi_auto = TRUE
	fire_sound = 'sound/f13weapons/riot_shotgun.ogg'

	reload_sound = 'sound/weapons/guns/hrifle_magin.ogg'	//Prob closest to 7.62 noise
	reload_sound_empty = 'sound/weapons/guns/hrifle_magin.ogg'
	unload_sound = 'sound/weapons/guns/hrifle_magout.ogg'

//Khan S.E unique riot shotgun.
/obj/item/gun/ballistic/automatic/shotgun/riot/boss
	name = "Left Hand"
	desc = "A modified, fully metal and notably heavy riot shotgun with a large ammo drum and notably rapid semi-automatic fire, designed to fight in close quarters. \
	This one has engravings, dedicated to a Khan Senior Enforcer."
	fire_delay = 3
	recoil = 1
	slowdown = 0.65 //added so it's not just a straight upgrade sort of unique. total of 0.8 slowdown when used with S.E armor

/obj/item/gun/ballistic/automatic/shotgun/caws
	name = "precision shotgun"
	desc = "A carefully engineered H&K CAWS shotgun with a long barrel, scope, and cutting edge ergonomics. It was fielded in limited quantities to United States special forces and certain counter-terror organisations in the European Commonwealth."
	icon_state = "caws"
	icon = 'icons/obj/guns/gunfruits2022/shotguns.dmi'
	item_state = "cshotgun1"
	fire_sound = 'sound/f13weapons/repeater_fire.ogg'
	mag_type = /obj/item/ammo_box/magazine/d12g
	is_automatic = TRUE
	autofire_shot_delay = 3.55
	fire_delay = 4
	recoil = 1.35
	automatic = 1
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY

// BETA // Obsolete
/obj/item/gun/ballistic/shotgun/shotttesting
	name = "shotgun"
	icon_state = "shotgunpolice"
	item_state = "shotgunpolice"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/lethal/test
	extra_damage = 7
