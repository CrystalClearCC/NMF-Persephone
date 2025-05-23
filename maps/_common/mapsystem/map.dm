/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/description // Basic info about the map. Shows up in the new player options.
	var/path

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/restricted_levels = list()  // Z-levels that dont allow ghosts to randomly move around
	var/list/empty_levels = null     // Empty Z-levels that may be used for various things (currently used by bluespace jump)
	var/list/meteor_levels = list() //What z-levels the meteors can hit

	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.

	var/list/base_turf_by_z = list() // Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels

	//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
	var/list/accessible_z_levels = list()

	var/list/allowed_jobs
		//Job datums to use.
		//Works a lot better so if we get to a point where three-ish maps are used
		//We don't have to C&P ones that are only common between two of them
		//That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
		//Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
		//This is probably a lot longer explanation than it needs to be.

	var/station_name  = "BAD Station"
	var/station_short = "Baddy"
	var/dock_name     = "THE PirateBay"
	var/dock_short    = "Piratebay"
	var/boss_name     = "Captain Roger"
	var/boss_short    = "Cap'"
	var/company_name  = "BadMan"
	var/company_short = "BM"

	var/command_spawn_enabled = FALSE
	var/command_spawn_message = "Someone didn't fill this in."

	var/list/spawn_types

	var/shuttle_call_restarts = TRUE // if true, calling crew transfer or evac just restarts the round in ten minute
	var/shuttle_call_restart_timer
	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_recall_message
	var/emergency_shuttle_called_message

	var/evac_controller_type = /datum/evacuation_controller

	var/list/station_networks = list() 		// Camera networks that will show up on the console.

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list()
		// map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
		// this is in order to support multiple holodeck program listings for different holodecks
		// second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
		// as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!

	var/force_spawnpoint = FALSE
	var/allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")
	var/default_spawn = "Arrivals Shuttle"

	var/list/lobby_icons = list() // The icons which contains the lobby images. A dmi is picked at random.
	var/lobby_icon                // This is what the game uses to store the chosen dmi.
	var/list/lobby_screens = list() // The list of lobby screen to pick() from. Leave this unset to fill from the lobby icon DMI.
	var/lobby_transitions = FALSE          // If a number, transition between the lobby screens with this delay instead of picking just one.

	var/use_overmap = FALSE		//If overmap should be used (including overmap space travel override)
	var/overmap_size = 20		//Dimensions of overmap zlevel if overmap is used.
	var/overmap_z = 0		//If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.
	var/overmap_event_areas = 0 //How many event "clouds" will be generated
	var/list/map_shuttles = list() // A list of all our shuttles.
	var/default_sector = SECTOR_CERBERUS //What is the default space sector for this map

	//event messages

	var/meteors_detected_message = "A meteor storm has been detected on collision course with the station. Estimated three minutes until impact, please activate station shields, and seek shelter in the central ring."
	var/meteor_contact_message = "Contact with meteor wave imminent, all hands brace for impact."
	var/meteor_end_message = "The station has cleared the meteor shower, please return to your stations."

	var/ship_detected_end_message = "The NDV Icarus reports that it has downed an unknown vessel that was approaching your station. Prepare for debris impact - please evacuate the surface level if needed."
	var/ship_meteor_contact_message = "Ship debris colliding now, all hands brace for impact."
	var/ship_meteor_end_message = "The last of the ship debris has hit or passed by the station, it is now safe to commence repairs."

	var/dust_detected_message = "A belt of space dust is approaching the station."
	var/dust_contact_message = "The station is now passing through a belt of space dust."
	var/dust_end_message = "The station has now passed through the belt of space dust."

	var/radiation_detected_message = "High levels of radiation detected near the station. Please evacuate into one of the shielded maintenance tunnels."
	var/radiation_contact_message = "The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt."
	var/radiation_end_message = "The station has passed the radiation belt. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all-access again shortly."

	var/list/rogue_drone_detected_messages = list("A combat drone wing operating out of the NDV Icarus has failed to return from a sweep of this sector, if any are sighted approach with caution.",
													"Contact has been lost with a combat drone wing operating out of the NDV Icarus. If any are sighted in the area, approach with caution.",
													"Unidentified hackers have targetted a combat drone wing deployed from the NDV Icarus. If any are sighted in the area, approach with caution.")
	var/rogue_drone_end_message = "Icarus drone control reports the malfunctioning wing has been recovered safely."
	var/rogue_drone_destroyed_message = "Icarus drone control registers disappointment at the loss of the drones, but the survivors have been recovered."

/datum/map/New()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs)
		allowed_jobs = subtypesof(/datum/job)
	if (!spawn_types)
		spawn_types = subtypesof(/datum/spawnpoint)

/datum/map/proc/generate_asteroid()
	return

// Override to set custom access requirements for camera networks.
/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = current_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/get_empty_zlevel()
	if(empty_levels == null)
		world.maxz++
		empty_levels = list(world.maxz)
	return pick(empty_levels)

/datum/map/proc/setup_shuttles()

// Called right after SSatlas finishes loading the map & multiz is setup.
/datum/map/proc/finalize_load()
