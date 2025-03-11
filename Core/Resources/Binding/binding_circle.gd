extends Node2D

@onready var effect_sprite:Sprite2D = $EffectSprite
@export var Circle_type :BindingCircle = null

signal catch_sucess
signal catch_faliure

func burn():
	print_debug("Burning")
	effect_sprite.self_modulate = Color("ff50f4")
	effect_sprite.get_material().set_shader_parameter("dissolve_value",1.0)
	effect_sprite.get_material().set_shader_parameter("burn_color",Color.RED)
	var tween = get_tree().create_tween()
	tween.tween_property(effect_sprite,"material:shader_parameter/dissolve_value",0.0,0.5)
	await tween.finished
	queue_free()

func _ready():
	effect_sprite.texture = Circle_type.sprite

func construct(pokemon:game_pokemon):
	print_debug("Constructing")
	effect_sprite.self_modulate = Color("ff50f4")
	effect_sprite.get_material().set_shader_parameter("dissolve_value",0.0)
	effect_sprite.get_material().set_shader_parameter("burn_color",Color.BLACK)
	var tween = get_tree().create_tween()
	tween.tween_property(effect_sprite,"material:shader_parameter/dissolve_value",1.0,1.0)
	await tween.finished
	try_binding(pokemon)
	

func bind():
	effect_sprite.get_material().set_shader_parameter("dissolve_value",1.0)
	var tween = get_tree().create_tween()
	tween.tween_property(effect_sprite,"self_modulate",Color("77fff5"),1.0)
	await tween.finished
	queue_free()

func try_binding(pokemon:game_pokemon):
	var catched = catch(pokemon)
	if catched == true:
		emit_signal("catch_sucess")
		bind()
	else:
		emit_signal("catch_faliure")
		burn()

func catch(pokemon:game_pokemon):
	var catch_chance :int = 0
	var health_percent :int = 0
	
	health_percent = (pokemon.Health/pokemon.Max_Health)*100
	
	catch_chance = 16*((4*Circle_type.CatchRate) + pokemon.get_catch_rate())/(2+pokemon.level+health_percent)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var r = rng.randi_range(1,100)
	
	print_debug(r," ",catch_chance)
	if r < catch_chance:
		return true
	return false