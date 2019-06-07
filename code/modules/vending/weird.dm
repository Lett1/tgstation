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
	'sound/voice/human/malescream_1.ogg'
	'sound/voice/human/malescream_2.ogg',
	'sound/voice/human/malescream_3.ogg', 
	'sound/voice/human/malescream_4.ogg', 
	'sound/voice/human/malescream_5.ogg')

	playsound(src, screamsound, 100, TRUE)

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

	M.adjust_nutrition(5)

// Fedora hat

/obj/item/reagent_containers/food/snacks/meat/teriyakifedora
	name = "fedora"
	desc = "Meathat: Teriyaki Fedora. Now you can have your hat and eat it too!"
	icon_state = "fedora"
	item_state = "fedora"
	slot_flags = ITEM_SLOT_HEAD
	icon = 'icons/obj/clothing/hats.dmi'
	list_reagents = list("nutriment" = 5)
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
	list_reagents = list("nutriment" = 1, "condensedcapsaicin" = 10, "sodiumchloride" = 1)
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
	list_reagents = list("nutriment" = 2, "sugar" = 2, "cocoa" = 2)
	filling_color = "#A0522D"
	tastes = list("chocolate" = 1, "flukes" = 1, "captainship" = 1)
	foodtype = JUNKFOOD | SUGAR

// Mountain Dew: Dorito Blaze
/datum/reagent/vomitol
	name = "Vomitol"
	id = "vomitol"
	description = "Causes instant vomiting on consumption."
	color = "#89A203"
	metabolization_rate = INFINITY
	taste_description = "garbage"
	can_synth = FALSE

/datum/reagent/vomitol/on_mob_add(mob/living/L)
	. = ..()
	var/mob/living/carbon/C = L
	C.vomit(5,FALSE,TRUE)

/obj/item/reagent_containers/food/snacks/chips/doritoblaze
	name = "chips"
	desc = "Dorito blaze flavor"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	bitesize = 4
	list_reagents = list("nutriment" = 1, "vomitol" = 1)
	junkiness = 20
	filling_color = "#FFD700"
	tastes = list("salt" = 1, "crisps" = 1)
	foodtype = JUNKFOOD | FRIED | GROSS

// Taste me!
/obj/item/reagent_containers/food/snacks/cakeslice/plain/tasteme
	name = "taste me!"
	desc = "A slice of cake with a a piece of paper stuck onto it. It reads \"Taste me!\""
	list_reagents = list("nutriment" = 4, "vitamin" = 1)
	tastes = list("cake" = 1, "magic"= 1)

/obj/item/reagent_containers/food/snacks/cakeslice/plain/tasteme/On_Consume(mob/living/eater)
	. = ..()
	var/mob/living/carbon/C = eater
	C.dna.add_mutation(/datum/mutation/human/gigantism)

// Dream puffs

/datum/reagent/zolpidem
	name = "Zolpidem"
	id = "zolpidem"
	description = "A medicinal substance often used to treat sleeping disorders."
	reagent_state = LIQUID
	color = "#00f041"
	taste_mult = 0
	can_synth = FALSE

/datum/reagent/zolpidem/on_mob_life(mob/living/carbon/M)
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
	list_reagents = list("nutriment" = 4, "vitamin" = 1, "zolpidem" = 4)
	tastes = list("cake" = 1) // Need some better taste for it


// Canned bees

/obj/item/reagent_containers/food/drinks/soda_cans/bees
	name = "EnerBee Drink"
	desc = "You can hear faint buzzing inside the can."
	icon_state = "lemon-lime"

/obj/item/reagent_containers/food/drinks/soda_cans/bees/open_soda(mob/user)
	. = ..()
	for(var/i in 1 to rand(3,6))
		var/mob/living/simple_animal/hostile/poison/bees/short/new_bee = new(get_turf(user), 20 SECONDS)
		new_bee.assign_reagent(/datum/reagent/consumable/nutriment)

