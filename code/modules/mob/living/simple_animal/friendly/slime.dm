/mob/living/simple_animal/slime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "grey baby slime"
	icon_living = "grey baby slime"
	icon_dead = "grey baby slime dead"
	speak_emote = list("chirps")
	health = 100
	maxHealth = 100
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	emote_see = list("jiggles", "bounces in place")
	var/colour = "grey"
	pass_flags = PASSTABLE

/mob/living/simple_animal/slime/Bump(atom/movable/AM as mob|obj, yes)

	spawn( 0 )
		if((!( yes ) || now_pushing))
			return
		now_pushing = 1
		if(ismob(AM))
			var/mob/tmob = AM
			if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
				if(prob(70))
					to_chat(src, "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>")
					now_pushing = 0
					return
			if(!(tmob.status_flags & CANPUSH))
				now_pushing = 0
				return

			tmob.LAssailant = src
		now_pushing = 0
		..()
		if(!( istype(AM, /atom/movable) ))
			return
		if(!( now_pushing ))
			now_pushing = 1
			if(!( AM.anchored ))
				var/t = get_dir(src, AM)
				if(istype(AM, /obj/structure/window/full))
					for(var/obj/structure/window/win in get_step(AM,t))
						now_pushing = 0
						return
				if(!AM.get_push_able(src))
					to_chat(src, "[AM] is too heavy to push.")
					now_pushing = 0
					return
				else
					if(src.client)
						client.move_delay += pulling.calculate_movedelay()
					AM.affect_pushstamina(src)
					if(Adjacent(AM))
						step(AM, t)
			now_pushing = null
		return
	return

/mob/living/simple_animal/adultslime
	name = "pet slime"
	desc = "A lovable, domesticated slime."
	icon = 'icons/mob/slimes.dmi'
	health = 200
	maxHealth = 200
	icon_state = "grey adult slime"
	icon_living = "grey adult slime"
	icon_dead = "grey baby slime dead"
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	emote_see = list("jiggles", "bounces in place")
	var/colour = "grey"
	del_on_death = 1

/mob/living/simple_animal/adultslime/New()
	..()
	overlays += "aslime-:33"


/mob/living/simple_animal/slime/adult/death(gibbed)
	for(var/i in 1 to 2)
		var/mob/living/simple_animal/slime/S = new /mob/living/simple_animal/slime (src.loc)
		S.icon_state = "[colour] baby slime"
		S.icon_living = "[colour] baby slime"
		S.icon_dead = "[colour] baby slime dead"
		S.colour = "[colour]"
	..()