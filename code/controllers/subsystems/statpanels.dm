/datum/controller/subsystem/statpanels
	name = "Stat Panels"
	wait = 4
	init_order = SS_INIT_STATPANELS
	flags = FIRE_IN_LOBBY
	var/list/currentrun = list()
	var/encoded_global_data
	var/mc_data_encoded

/datum/controller/subsystem/statpanels/fire(resumed = 0)
	if (!resumed)
		var/datum/map_config/cached = SSmapping.next_map_config
		var/list/global_data = list(
			"Map: [current_map.full_name]",
			"Round ID: [game_id]",
			"Station Time: [worldtime2text()]",
			"Last Transfer Vote: [SSvote.last_transfer_vote ? time2text(SSvote.last_transfer_vote, "hh:mm") : "Never"]"
		)

		if(SSshuttle.emergency)
			var/ETA = SSshuttle.emergency.getModeStr()
			if(ETA)
				global_data += "[ETA] [SSshuttle.emergency.getTimerStr()]"
		encoded_global_data = url_encode(json_encode(global_data))

		var/list/mc_data = list(
			list("CPU:", world.cpu),
			list("Instances:", "[num2text(world.contents.len, 10)]"),
			list("World Time:", "[world.time]"),
			list("Byond:", "(FPS:[world.fps]) (TickCount:[world.time/world.tick_lag]) (TickDrift:[round(Master.tickdrift,1)]([round((Master.tickdrift/(world.time/world.tick_lag))*100,0.1)]%))"),
			list("Master Controller:", Master ? "(TickRate:[Master.processing]) (Iteration:[Master.iteration])" : "ERROR", "\ref[Master]"),
			list("Failsafe Controller:", Failsafe ? "Defcon: [Failsafe.defcon_pretty()] (Interval: [Failsafe.processing_interval] | Iteration: [Failsafe.master_iteration])" : "ERROR", "\ref[Failsafe]"),
			list("","")
		)
		for(var/datum/controller/subsystem/SS in Master.subsystems)
			mc_data[++mc_data.len] = list("\[[SS.state_letter()]][SS.name]", SS.stat_entry(), "\ref[SS]")
		mc_data_encoded = url_encode(json_encode(mc_data))
		src.currentrun = clients.Copy()

	var/list/currentrun = src.currentrun
	while(currentrun.len)
		var/client/C = currentrun[currentrun.len]
		C << output(url_encode(C.statpanel), "statbrowser:tab_change") // work around desyncs
		currentrun.len--
		var/ping_str = url_encode("Ping: [round(C.lastping, 1)]ms (Average: [round(C.avgping, 1)]ms)")
		var/other_str = url_encode(json_encode(C.mob.get_status_tab_items()))
		C << output("[encoded_global_data];[ping_str];[other_str]", "statbrowser:update")
		if(C.holder && C.statpanel == "MC")
			var/turf/T = get_turf(C.eye)
			var/coord_entry = url_encode(COORD(T))
			C << output("[mc_data_encoded];[coord_entry];[url_encode(C.holder.href_token)]", "statbrowser:update_mc")
		/*var/list/action_buttons = C.mob.get_action_buttons()
		var/action_buttons_encoded = url_encode(json_encode(proc_holders))
		C << output("[action_buttons_encoded]", "statbrowser:update_spells")*/
		if(MC_TICK_CHECK)
			return