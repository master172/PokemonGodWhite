extends GameAbility

var health_to_start:int = 0
@export var divisor:int = 2
func setup():
	health_to_start = Holder.pokemon.Max_Health/divisor
	Holder.health_changed.connect(on_health_changed)

func on_health_changed(body:CharacterBody2D):
	if body.pokemon.Health <= health_to_start:
		body.damage_multiplier = 0.5
	else:
		body.damage_multiplier = 1
