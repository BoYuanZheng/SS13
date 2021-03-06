/datum/round_event_control/blob
	name = "Blob"
	typepath = /datum/round_event/blob
	event_flags = EVENT_STANDARD
	max_occurrences = 1
	earliest_start = 48000 // 1 hour 20 minutes
	weight = 5

/datum/round_event/blob
	alert_when	= 120
	end_when = -1
	var/blobwincount = 350
	var/obj/effect/blob/core/Blob


	Alert()
		priority_announce("Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", 'sound/AI/outbreak5.ogg')

	Start()
		if (!prevent_stories) EventStory("A Confirmed outbreak of level 5 biohazard was reported aboard [station_name()].")
		var/turf/T = pick(blobstart)
		if(!T)
			return CancelSelf()
		Blob = new /obj/effect/blob/core(T, 200, null, 3)
		for(var/i = 1; i < rand(3, 6), i++)
			Blob.process()


	Tick()
		if(!blob_cores.len)
			AbruptEnd()
			return
		if(IsMultiple(active_for, 3))
			Blob.process()
		if(blobwincount <= blobs.len)//Blob took over
			return 1
		return 0

	End()
		if(!blob_cores.len)
			OnPass()
		else
			OnFail()

	OnFail()
		if (!prevent_stories) EventStory("The level 5 biohazard consumed what was left of [station_name()].",1)

	OnPass()
		if (!prevent_stories) EventStory("The crew managed to destroy the level 5 biohazard.")
		for(var/mob/living/carbon/human/L in player_list)
			if(L.stat != DEAD)
				events.AddAwards("eventmedal_blob",list("[L.key]"))