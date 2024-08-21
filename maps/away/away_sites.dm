// Hey! Listen! Update \config\away_site_blacklist.txt with your new ruins!

/datum/map_template/ruin/away_site
	abstract_type = /datum/map_template/ruin/away_site
	prefix = "maps/away/"

	/// If null, ignored, and exoplanet generation is not used.
	/// If set, away site spawning includes partial exoplanet generation.
	/// Should be assoc map of `/turf/unsimulated/marker/...` path to `/datum/exoplanet_theme/...` path,
	/// where exoplanet generation with the map value is applied only on marker turfs of the applicable map key.
	var/list/exoplanet_themes = null

/datum/map_template/ruin/away_site/New(var/list/paths = null, rename = null)

	//Apply the subfolder that all ruins are in, as the prefix will get overwritten
	prefix = "maps/away/[prefix]"

	..()

/datum/map_template/ruin/away_site/post_exoplanet_generation(bounds)
	// do away site exoplanet generation, if needed
	if(length(exoplanet_themes))
		for(var/z_index = bounds[MAP_MINZ]; z_index <= bounds[MAP_MAXZ]; z_index++)
			for(var/marker_turf_type in exoplanet_themes)
				var/datum/exoplanet_theme/exoplanet_theme_type = exoplanet_themes[marker_turf_type]
				var/datum/exoplanet_theme/exoplanet_theme = new exoplanet_theme_type()
				exoplanet_theme.generate_map(z_index, 1, 1, 254, 254, marker_turf_type)
