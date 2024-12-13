extends wind_gust


func move_path():
	for pf in pf_dict:		
		pf.trail_offset += trail_speed
		if pf.trail_offset >= 0.0 and pf.trail_offset <= 1.0:
			pf.progress_ratio = pf.trail_offset
		
		if pf.trail_offset >= 1.0:
			pf.progress_ratio = 1.0
