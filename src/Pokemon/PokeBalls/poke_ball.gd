extends CharacterBody2D
@export var pokeball :Pokeball = null

func _physics_process(delta):
	
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_body_entered(body):
	if body != not get_parent():
		if body.is_in_group("Pokemon") or body.is_in_group("PlayerPokemon"):
			catch(body.get_pokemon())
		
func catch(pokemon:game_pokemon):
	var catch_chance :int = 0
	var health_percent :int = 0
	
	var one_percent = int(pokemon.Max_Health/100)
	health_percent = pokemon.Health/one_percent
	
	catch_chance = 16*((4*pokeball.CatchRate) + pokemon.get_catch_rate())/(2+pokemon.level+2+health_percent)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var r = rng.randi_range(1,100)
	
	if r < catch_chance:
		return true
	return false
