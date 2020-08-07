/obj/item/device/assembly/timer
	name = "timer"
	desc = "Used to time things. Works well with contraptions which has to count down. Tick tock."
	icon_state = "timer"
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound =  'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500, MATERIAL_GLASS = 50)

	wires = WIRE_PULSE

	secured = 0

	var/timing = 0
	var/time = 10

	proc
		timer_end()


	activate()
		if(!..())	return 0//Cooldown check

		timing = !timing

		update_icon()
		return 0


	toggle_secure()
		secured = !secured
		if(secured)
			START_PROCESSING(SSprocessing, src)
		else
			timing = 0
			STOP_PROCESSING(SSprocessing, src)
		update_icon()
		return secured


	timer_end()
		if(!secured)	return 0
		pulse(0)
		if(!holder)
			visible_message("[icon2html(src, usr)] *beep* *beep*", "*beep* *beep*")
		cooldown = 2
		addtimer(CALLBACK(src, .proc/process_cooldown), 10)
		return


	process()
		if(timing && (time > 0))
			time--
		if(timing && time <= 0)
			timing = 0
			timer_end()
			time = 10
		return


	update_icon()
		cut_overlays()
		attached_overlays = list()
		if(timing)
			add_overlay("timer_timing")
			attached_overlays += "timer_timing"
		if(holder)
			holder.update_icon()
		return


	interact(mob/user as mob)//TODO: Have this use the wires
		if(!secured)
			user.show_message("<span class='warning'>The [name] is unsecured!</span>")
			return 0
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = text("<TT><B>Timing Unit</B>\n[] []:[]\n<A href='?src=\ref[];tp=-30'>-</A> <A href='?src=\ref[];tp=-1'>-</A> <A href='?src=\ref[];tp=1'>+</A> <A href='?src=\ref[];tp=30'>+</A>\n</TT>", (timing ? text("<A href='?src=\ref[];time=0'>Timing</A>", src) : text("<A href='?src=\ref[];time=1'>Not Timing</A>", src)), minute, second, src, src, src, src)
		dat += "<BR><BR><A href='?src=\ref[src];refresh=1'>Refresh</A>"
		dat += "<BR><BR><A href='?src=\ref[src];close=1'>Close</A>"
		user << browse(dat, "window=timer")
		onclose(user, "timer")
		return


	Topic(href, href_list)
		..()
		if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
			usr << browse(null, "window=timer")
			onclose(usr, "timer")
			return

		if(href_list["time"])
			timing = text2num(href_list["time"])
			update_icon()

		if(href_list["tp"])
			var/tp = text2num(href_list["tp"])
			time += tp
			time = min(max(round(time), 0), 600)

		if(href_list["close"])
			usr << browse(null, "window=timer")
			return

		if(usr)
			attack_self(usr)

		return
