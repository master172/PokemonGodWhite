extends CharacterBody2D
@export var pokeball :Pokeball = null

signal catch_sucess
signal catch_faliure

func _physics_process(delta):
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	emit_signal("catch_faliure")

func _on_area_2d_body_entered(body):
	if body != get_parent():
		if body.is_in_group("Pokemon"):
			var catched = catch(body.get_pokemon())
			if catched == true:
				emit_signal("catch_sucess")
			else:
				emit_signal("catch_faliure")
				queue_free()
				
func catch(pokemon:game_pokemon):
	var catch_chance :int = 0
	var health_percent :int = 0
	
	health_percent = (pokemon.Health/pokemon.Max_Health)*100
	
	catch_chance = 16*((4*pokeball.CatchRate) + pokemon.get_catch_rate())/(2+pokemon.level+health_percent)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var r = rng.randi_range(1,100)
	
	print_debug(r," ",catch_chance)
	if r < catch_chance:
		return true
	return false
