extends AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = Time.get_time_dict_from_system()
	var TimeInSeconds = time.hour * 3600 + time.minute * 60 + time.second
	var CurrentFrame = remap(TimeInSeconds,0,86400,0,24)
	play("Default")
	seek(CurrentFrame)
	
