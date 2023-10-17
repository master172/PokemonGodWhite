extends Resource

class_name GameAction

@export var base_action:BaseAction = null





func _init(Base_Action:BaseAction = BaseAction.new()):
	base_action = Base_Action

func Name():
	return base_action.name

func start_attack(User:CharacterBody2D):
	if base_action.action != null:
		var attack = base_action.action.instantiate()
		attack.set_holder(self)
		attack.set_user(User)
		if attack.has_method("set_target"):
			attack.set_target(User.opposing_pokemons)
		User.add_child(attack)
		
		if attack.has_method("_attack"):
			attack._attack()
	
func calculate_damage(body,User):
	var attack_rng = RandomNumberGenerator.new()
	var critical = 1
	var pokemon:game_pokemon = User.pokemon
	var opposing_pokemon:game_pokemon = body.pokemon
	
	var crit_threshold = (pokemon.Base_Pokemon.Base_Speed/2)
	var crit_chance = attack_rng.randi_range(0,255)
	
	if crit_chance < crit_threshold:
		critical = 2
	
	var stab = 1
	
	if pokemon.get_Type1() == base_action.Type:
		stab += 0.5
	if pokemon.get_Type2() == base_action.Type:
		stab += 0.5
	
	var type = 0
	
	var random_multiplier:int = attack_rng.randi_range(85,100)
	var random:float = float(random_multiplier)/100
	
	type += BattleManager.get_type_modifier(base_action.Type,opposing_pokemon.get_Type1())
	
	if opposing_pokemon.get_Type2() != "NONE":
		var mod = BattleManager.get_type_modifier(base_action.Type,opposing_pokemon.get_Type2())
		if mod <1:
			type -= mod 
		elif mod == 1:
			type = type
		elif mod >1:
			type += mod
	var damage:int = ((((2*pokemon.level/5)+2)*base_action.power*(pokemon.Attack/opposing_pokemon.Defense)/50)+2)*critical*stab*type*random
	body.recive_damage(damage,User,User)
	
	print(" ")
	print("pokemon: ",pokemon.Nick_name)
	print("reciver: ",opposing_pokemon.Nick_name)
	print("Attack: ",base_action.name)
	print("crit_threshold: ",crit_threshold)
	print("crit_chance: ",crit_chance)
	print("type: ",type)
	print("critical: ",critical)
	print("stab: ",stab)
	print("random: ",random)
	
	print(damage, ": damage")
	print(" ")
