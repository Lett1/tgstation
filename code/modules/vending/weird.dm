/obj/machinery/weird_vendor
	name = "\improper Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = BELOW_OBJ_LAYER
	density = TRUE
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	max_integrity = 300
	integrity_failure = 100
	armor = list("melee" = 20, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 70)
	circuit = null
	payment_department = ACCOUNT_SRV
	use_power = NO_POWER_USE

	var/code_entered = ""
	var/money_stored = 0
	

/obj/machinery/weird_vendor/ui_interact(mob/user)
	var/list/dat = list()

	dat += "Credit: [money_stored]<br>Selection: [code_entered]<table> <tr> <td> <A href='?src=[REF(src)];button=1'>1</A> </td><td> <A href='?src=[REF(src)];button=2'>2</A> </td><td> <A href='?src=[REF(src)];button=3'>3</A> </td></tr><tr> <td> <A href='?src=[REF(src)];button=4'>4</A> </td><td> <A href='?src=[REF(src)];button=5'>5</A> </td><td> <A href='?src=[REF(src)];button=6'>6</A> </td></tr><tr> <td> <A href='?src=[REF(src)];button=7'>7</A> </td><td> <A href='?src=[REF(src)];button=8'>8</A> </td><td> <A href='?src=[REF(src)];button=9'>9</A> </td></tr></table>"

	var/datum/browser/popup = new(user, "vending", (name))
	popup.add_stylesheet(get_asset_datum(/datum/asset/spritesheet/vending))
	popup.set_content(dat.Join(""))
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/machinery/weird_vendor/Topic(href, href_list)
	if(..())
		return

	to_chat(world, english_list(href_list))

	if(href_list["button"])
		to_chat(world, "button pressed")
		code_entered += href_list["button"]

	if(length(code_entered) >= 4)
		if(money_stored <= 0)
			say("Please insert coin.")
			code_entered = ""
		else
			vend_item()

	updateUsrDialog()

/obj/machinery/weird_vendor/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/holochip))
		insert_money(W, user)
		return
	else if(istype(W, /obj/item/stack/spacecash))
		insert_money(W, user, TRUE)
		return
	else if(istype(W, /obj/item/coin))
		insert_money(W, user, TRUE)
		return
	else
		return ..()

/obj/machinery/weird_vendor/proc/insert_money(obj/item/I, mob/user, physical_currency)
	var/cash_money = I.get_item_credit_value()
	if(!cash_money)
		to_chat(user, "<span class='warning'>[src] won't accept [I]!</span>")
		return

	money_stored += cash_money
	to_chat(user, "<span class='notice'>You insert [I] into [src].</span>")

	updateUsrDialog()

	qdel(I)

/obj/machinery/weird_vendor/proc/vend_item()
	

	var/product = null

	switch(money_stored)
		if(1 to 10)
			product = /obj/item/reagent_containers/food/drinks/sillycup
		if(10 to 200)
			//Cheap items
		if(200 to 1000)
			//Good items
		if(1000 to 5000)
			//rare items
		else
			//special items
	
	new product(get_turf(src))
	code_entered = ""
	money_stored = 0

// SCREAMING CAN

/obj/item/reagent_containers/food/drinks/soda_cans/scream
	name = "screaming \[UNTRANSLATABLE\]"
	icon_state = "lemon-lime"

/obj/item/reagent_containers/food/drinks/soda_cans/scream/open_soda(mob/user)
	. = ..()
	var/screamsound = pick('sound/voice/human/femalescream_1.ogg', 
	'sound/voice/human/femalescream_2.ogg', 
	'sound/voice/human/femalescream_3.ogg', 
	'sound/voice/human/femalescream_4.ogg', 
	'sound/voice/human/femalescream_5.ogg',
	'sound/voice/human/wilhelm_scream.ogg',
	'sound/voice/human/malescream_1.ogg',
	'sound/voice/human/malescream_2.ogg',
	'sound/voice/human/malescream_3.ogg', 
	'sound/voice/human/malescream_4.ogg', 
	'sound/voice/human/malescream_5.ogg')

	playsound(src, screamsound, 100, TRUE)
	// TODO: add chat message

	user.adjust_nutrition(20)

// CANDY GUN

/obj/item/gun/ballistic/automatic/pistol/candygun
	name = "\improper Candy Gun"
	desc = "A handgun made out of hard sugar. Shoots yummy candy bullets."
	icon_state = "m1911"
	w_class = WEIGHT_CLASS_NORMAL
	mag_type = /obj/item/ammo_box/magazine/candy
	can_suppress = FALSE

/obj/item/ammo_box/magazine/candy
	name = "candy gun magazine"
	icon_state = "45-8"
	ammo_type = /obj/item/ammo_casing/candy
	caliber = ".45"
	max_ammo = 8

/obj/item/ammo_casing/candy
	name = "candy bullet casing"
	desc = "A bullet casing made out of sugar."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/candy

/obj/item/projectile/bullet/candy
	name = ".45 CND bullet"
	damage = 0

/obj/item/projectile/bullet/candy/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/carbon/M = target

	M.adjust_nutrition(2)

// Fedora hat

/obj/item/reagent_containers/food/snacks/meat/teriyakifedora
	name = "fedora"
	desc = "Meathat: Teriyaki Fedora. Now you can have your hat and eat it too!"
	icon_state = "fedora"
	item_state = "fedora"
	slot_flags = ITEM_SLOT_HEAD
	icon = 'icons/obj/clothing/hats.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	filling_color = "#854817"
	tastes = list("fish" = 1, "enlightment" = 1)
	foodtype = MEAT

// Doritos Atomic Flavor

/obj/item/reagent_containers/food/snacks/chips/atomicflavor
	name = "chips"
	desc = "Atomic flavor"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/condensedcapsaicin = 10, /datum/reagent/consumable/sodiumchloride = 1)
	junkiness = 20
	filling_color = "#FFD700"
	tastes = list("salt" = 1, "crisps" = 1, "lava" = 1)
	foodtype = JUNKFOOD | FRIED

/obj/item/reagent_containers/food/snacks/chips/atomicflavor/On_Consume(mob/living/eater)
	. = ..()
	new /datum/hallucination/fire(eater)

// Choko nuke disk
/obj/item/reagent_containers/food/snacks/chocolatebar/nukedisk
	name = "nuclear authentication disk"
	desc = "Upon smelling it, it turns out to be made out of chocolate."
	icon = 'icons/obj/module.dmi'
	icon_state = "nucleardisk"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2)
	filling_color = "#A0522D"
	tastes = list("chocolate" = 1, "flukes" = 1, "captainship" = 1)
	foodtype = JUNKFOOD | SUGAR

// Mountain Dew: Dorito Blaze
/datum/reagent/consumable/vomitol
	name = "Vomitol"
	description = "Causes instant vomiting on consumption."
	color = "#89A203"
	metabolization_rate = INFINITY
	taste_description = "garbage"
	can_synth = FALSE

/datum/reagent/consumable/vomitol/on_mob_add(mob/living/L)
	. = ..()
	var/mob/living/carbon/C = L
	C.vomit(5,FALSE,TRUE)

/obj/item/reagent_containers/food/snacks/chips/doritoblaze
	name = "chips"
	desc = "Dorito blaze flavor"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/vomitol = 1)
	junkiness = 20
	filling_color = "#FFD700"
	tastes = list("salt" = 1, "crisps" = 1)
	foodtype = JUNKFOOD | FRIED | GROSS

// Taste me!
/obj/item/reagent_containers/food/snacks/cakeslice/plain/tasteme
	name = "taste me!"
	desc = "A slice of cake with a a piece of paper stuck onto it. It reads \"Taste me!\""
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, "vitamin" = 1)
	tastes = list("cake" = 1, "magic"= 1)

/obj/item/reagent_containers/food/snacks/cakeslice/plain/tasteme/On_Consume(mob/living/eater)
	. = ..()
	var/mob/living/carbon/C = eater
	C.dna.add_mutation(/datum/mutation/human/gigantism)

// Dream puffs

/datum/reagent/consumable/zolpidem
	name = "Zolpidem"
	description = "A medicinal substance often used to treat sleeping disorders."
	reagent_state = LIQUID
	color = "#00f041"
	taste_mult = 0
	can_synth = FALSE

/datum/reagent/consumable/zolpidem/on_mob_life(mob/living/carbon/M)
	switch(current_cycle)
		if(5)
			to_chat(M, "<span class='warning'>You start to feel tired...</span>" )
		if(6 to 12)
			M.drowsyness += 1
		if(13 to INFINITY)
			M.Sleeping(40, 0)
			. = 1
	..()

/obj/item/reagent_containers/food/snacks/cakeslice/plain/dreampuff
	name = "dream puff"
	desc = "Made out of dough and whipped hopes and dreams."
	list_reagents = list(/datum/reagent/consumable/nutriment = 4,/datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/zolpidem = 4)
	tastes = list("cake" = 1) // Need some better taste for it

// Canned bees

/obj/item/reagent_containers/food/drinks/soda_cans/enerbee
	name = "EnerBee Drink"
	desc = "You can hear faint buzzing inside the can."
	icon_state = "lemon-lime"

/obj/item/reagent_containers/food/drinks/soda_cans/enerbee/open_soda(mob/user)
	. = ..()
	for(var/i in 1 to rand(2,4))
		var/mob/living/simple_animal/hostile/poison/bees/short/new_bee = new(get_turf(user), 20 SECONDS)
		var/beegent = new /datum/reagent/consumable/nutriment()
		new_bee.assign_reagent(beegent)

// Powdered water

/datum/reagent/water_powder
	name = "Powdered Water"
	description = "Water that has been solidified into a dry powder."
	color = "#AAAAAA"
	can_synth = FALSE

/datum/chemical_reaction/rehydrated_water
	name = "Rehydrated Water"
	id = "rehydrated_water"
	results = list(/datum/reagent/water = 10)
	required_reagents = list(/datum/reagent/water_powder = 1, /datum/reagent/water = 1)

// Piscina

/datum/reagent/consumable/piscina
	name = "Piscina"
	description = "A salty drink made from fish."
	color = "#100800" // rgb: 16, 8, 0
	taste_description = "fish"
	glass_name = "glass of Piscina"

/obj/item/reagent_containers/food/drinks/soda_cans/piscina
	name = "Piscina"
	desc = "Made from the freshest fish of neo-greece. Taste the sea."
	icon_state = "cola"
	list_reagents = list(/datum/reagent/consumable/piscina = 30)
	foodtype = MEAT

// Gator-Aid

/datum/reagent/consumable/gator_aid
	name = "Gator-Aid"
	description = "Apparently this passes for a drink in some parts of the galaxy."
	color = "#04491c"
	taste_description = "swamp water"
	glass_name = "glass of Gator-Aid"

/obj/item/reagent_containers/food/drinks/soda_cans/gator_aid
	name = "Gator-Aid"
	desc = "The space-athletes drink of choice."
	icon_state = "cola"
	list_reagents = list(/datum/reagent/consumable/gator_aid = 30)
	foodtype = GROSS

// Polyglot tablets

/obj/item/reagent_containers/food/snacks/polyglot
	name = "Polyglot"
	desc = "Years of linguistic development condensed into a single bar."
	icon_state = "chocolatebar"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/nutriment/vitamin = 1, /datum/reagent/consumable/coco = 1)
	bitesize = 10
	filling_color = "#A0522D"
	tastes = list("language" = 1)
	foodtype = JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/polyglot/On_Consume(mob/living/eater)
	. = ..()

	var/datum/language_holder/target_lang_holder = eater.get_language_holder()
	var/datum/language/granted_language = pick(subtypesof(/datum/language) - /datum/language/common)

	to_chat(world, granted_language)

	target_lang_holder.grant_language(granted_language)

// American AIR

/obj/item/reagent_containers/food/drinks/soda_cans/air/american
	name = "american air"
	desc = "A real patriot knows not to breathe the same air as communists. A real patriot remembers. Let your love of freedom breathe freely, with American Air."

// Bag of alien eyes

/obj/item/reagent_containers/food/snacks/chips/alien_eyes
	name = "alien eyes"
	desc = "A transparent bag with what appears to be eyes of some unknown species inside. Gooey on the inside."
	icon_state = "chips"
	trash = /obj/item/trash/chips
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/drug/space_drugs = 10)
	junkiness = 20
	filling_color = "#FFD700"
	tastes = list("something indescribable" = 1, "jelly" = 1)
	foodtype = JUNKFOOD | GROSS

// THUNDER BAR

/obj/item/reagent_containers/food/snacks/thunderbar
	name = "thunder bar"
	desc = "SHOCKINGLY GOOD."
	icon_state = "chocolatebar"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/coco = 2)
	filling_color = "#A0522D"
	tastes = list("chocolate" = 1, "lightning" = 1)
	foodtype = JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/thunderbar/On_Consume(mob/living/eater)
	. = ..()
	var/turf/T = get_step(get_step(eater, NORTH), NORTH)
	T.Beam(eater, icon_state="lightning[rand(1,12)]", time = 5)
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		H.electrocution_animation(40)
	// TODO: make this heal ethereal
	// TODO: make this play a sound

// Hot potato

/obj/item/reagent_containers/food/snacks/grown/potato/hot
	name = "hot potato"
	desc = "Fresh out of the pot!"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/capsaicin = 30)

/obj/item/reagent_containers/food/snacks/grown/potato/hot/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return

	var/prot = 0

	if(istype(user))
		if(user.gloves)
			var/obj/item/clothing/gloves/G = user.gloves
			if(G.max_heat_protection_temperature)
				prot = (G.max_heat_protection_temperature > 360)
	else
		prot = 1
	
	if(!(prot > 0 || HAS_TRAIT(user, TRAIT_RESISTHEAT) || HAS_TRAIT(user, TRAIT_RESISTHEATHANDS)))
		to_chat(user, "<span class='warning'>You try to pickup the [src], but you burn your hand on it!</span>")
		user.dropItemToGround(src)
		var/obj/item/bodypart/affecting = user.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
		if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
			user.update_damage_overlays()
		return TRUE

// Cold potato

/obj/item/reagent_containers/food/snacks/grown/potato/cold
	name = "cold potato"
	desc = "A solid chunk of a frozen potato."
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/frostoil = 10)

// FOOD

/obj/item/reagent_containers/food/snacks/food
	name = "food"
	desc = "Consume."
	icon_state = "chocolatebar"
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	foodtype = JUNKFOOD

// Unlucky charms
/obj/item/reagent_containers/food/snacks/unlucky_charms
	name = "old cereal"
	icon_state = "sosjerky"
	desc = "It reminds you of harder times. Best before 10-02-1999."
	trash = /obj/item/trash/sosjerky
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	junkiness = 10
	filling_color = "#8B0000"
	tastes = list("stale cereal" = 1, "dashed hopes and dreams" = 1)
	foodtype = JUNKFOOD

/obj/item/reagent_containers/food/snacks/unlucky_charms/On_Consume(mob/living/eater)
	. = ..()
	SEND_SIGNAL(eater, COMSIG_ADD_MOOD_EVENT, src, /datum/mood_event/sapped)

// Canned rainbow

/obj/item/reagent_containers/food/drinks/soda_cans/canned_rainbow
	name = "ingemaakte reënboog"
	desc = "Smaak die reënboog, nou as 'n drankie."
	icon_state = "cola"
	list_reagents = list(/datum/reagent/colorful_reagent = 30)

// Bacon jumpsuit

/obj/item/reagent_containers/food/snacks/meat/bacon_shoes
	name = "bacon shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"
	item_color = "brown"

	body_parts_covered = FEET
	slot_flags = ITEM_SLOT_FEET
	icon = 'icons/obj/clothing/shoes.dmi'

	list_reagents = list(/datum/reagent/consumable/nutriment = 5)
	filling_color = "#854817"
	tastes = list("bacon" = 1)
	foodtype = MEAT

// Pie in the sky
// Floats around, not affected by gravity

/obj/item/reagent_containers/food/snacks/cakeslice/plain/pie_in_the_sky
	name = "pie in the sky"
	desc = "You will eat, bye and bye,\nIn that glorious land above the sky;\nWork and pray, live on hay,\nYou’ll get pie in the sky when you die."
	list_reagents = list(/datum/reagent/consumable/nutriment = 4, /datum/reagent/consumable/nutriment/vitamin = 1)
	tastes = list("cake" = 1, "clouds"= 1)

/obj/item/reagent_containers/food/snacks/cakeslice/plain/pie_in_the_sky/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/forced_gravity, FALSE)

// Fractal cookie
// Contains a fuckload of nutriment

/obj/item/reagent_containers/food/snacks/cookie/fractal
	name = "fractal cookie"
	desc = "Upon closer inspection it turns out that the chocolate bits are in fact smaller cookies which in turn contain even smaller cookies. This seems to continue on forever."
	bitesize = 500
	list_reagents = list(/datum/reagent/consumable/nutriment = 1000)
	volume = 1000

// Can of laughter DX
// Contains superlaughter

/obj/item/reagent_containers/food/drinks/soda_cans/can_of_laughter_dx
	name = "can of laughter DX"
	desc = "Turns even the bleakest days into sunny rainbow filled ones."
	icon_state = "cola"
	list_reagents = list(/datum/reagent/consumable/superlaughter = 30)
	foodtype = SUGAR | JUNKFOOD

// Clown candy
// Turns you into a gamer

/obj/item/reagent_containers/food/snacks/clown_candy
	name = "clown candy"
	desc = "Made from clowns for clowns."
	icon_state = "chocolatebar"
	list_reagents = list(/datum/reagent/consumable/sugar = 2, /datum/reagent/consumable/laughter = 2)
	tastes = list("honking" = 1)
	bitesize = 100
	foodtype = JUNKFOOD | SUGAR

/obj/item/reagent_containers/food/snacks/clown_candy/On_Consume(mob/living/carbon/eater)
	. = ..()

	var/obj/item/clothing/mask/gas/clown_hat/cursed/magichead = new(get_turf(eater))
	eater.visible_message("<span class='danger'>[eater]'s face twists and contorts into a funny shape!</span>", \
						   "<span class='danger'>Your face feels like it's melting!</span>")
	if(!eater.dropItemToGround(eater.wear_mask))
		qdel(eater.wear_mask)
	eater.equip_to_slot_if_possible(magichead, SLOT_WEAR_MASK, 1, 1)

	eater.flash_act()

/obj/item/clothing/mask/gas/clown_hat/cursed

/obj/item/clothing/mask/gas/clown_hat/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

// Sound bites
// Cookies in different shapes, each one makes a different sound

/obj/item/reagent_containers/food/snacks/sound_bite
	name = "sound bite"
	desc = "SoundBites (TM). Rip and hear! "
	icon_state = "COOKIE!!!"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	filling_color = "#F0E68C"
	tastes = list("cookie" = 1)
	foodtype = GRAIN | SUGAR

	var/soundbite = null

/obj/item/reagent_containers/food/snacks/sound_bite/Initialize(mapload)
	. = ..()
	switch(rand(1,5))
		if(1)
			soundbite = 'sound/items/bikehorn.ogg'
			desc += "This one is shaped like a bike horn."
		if(2)
			soundbite = 'sound/effects/explosion1.ogg'
			desc += "This one looks like an explosion."
		if(3)
			soundbite = 'sound/voice/human/wilhelm_scream.ogg'
			desc += "This one looks like someone screaming."
		if(4)
			soundbite = 'sound/effects/reee.ogg'
			desc += "This one looks like a frog?"
		if(5)
			soundbite = 'sound/weapons/saberon.ogg'
			desc += "This one looks like a sword."
	
/obj/item/reagent_containers/food/snacks/sound_bite/On_Consume(mob/living/eater)
	playsound(src, soundbite, 100, TRUE) // Sound before parent to prevent the sound from being canceled cause the cookie got deleted
	. = ..()

// Triangle chips
// Gives you the glow mutation
/obj/item/reagent_containers/food/snacks/chips/triangles
	name = "triangle chips"
	desc = "Triangular chips with eyes in the centers."
	icon_state = "chips"
	trash = /obj/item/trash/chips
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sodiumchloride = 4)
	junkiness = 20
	filling_color = "#FFD700"
	tastes = list("salt" = 1, "crisps" = 1, "conspiracies" = 1)
	foodtype = JUNKFOOD | FRIED

/obj/item/reagent_containers/food/snacks/chips/triangles/On_Consume(mob/living/eater)
	. = ..()

	if(iscarbon(eater))
		var/mob/living/carbon/M = eater
		M.dna.add_mutation(/datum/mutation/human/glow)

// Hangover-b-gone pill
// Contains antihol

/obj/item/reagent_containers/pill/antihol
	name = "hangover-b-gone"
	desc = "Used to stimulate burn healing."
	icon_state = "pill_happy"
	list_reagents = list(/datum/reagent/medicine/antihol = 20)
	rename_with_volume = TRUE

// Corgi cube

/obj/item/reagent_containers/food/snacks/monkeycube/corgi
	name = "corgi cube"
	desc = "Just add water!"
	color = "#FFA500"
	tastes = list("dog food" = 1, "bones" = 1)
	foodtype = MEAT | SUGAR
	spawned_mob = /mob/living/simple_animal/pet/dog/corgi
