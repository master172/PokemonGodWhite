class_name BattlePokemon
extends CharacterBody2D

@export var movement_speed := 256

@onready var wait_timer = $WaitTimer

@onready var animation_tree := $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var sprite_2d := $Sprite2D
@onready var action_chosen := $UiLayer/ActionChosen
@onready var stun_timer = $StunTimer
@onready var hurt = $Node/Hurt
@onready var die = $Node/Die
@onready var knock_back = $Node/KnockBack
@onready var paralysis_timer = $ParalysisTimer
@onready var dash = $Dash
@onready var collision_shape_2d = $CollisionShape2D
@onready var held_items: Node = $HeldItems
@onready var status_conditions: Node = $StatusConditions

@export var pokemon :game_pokemon = null

var knockback_vector :Vector2 = Vector2.ZERO

var previous_moves:Array = []

var Stamina:int = 0
var MaxStamina:int = 0
var RegenRate:int = 1

var normal_speed := 256
var dash_speed := 1500
var dash_duration := 0.2

var tackle := false

enum facingDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum states {
	ATTACK_SELECTION,
	NORMAL,
	ACTION_SELECTION
}

var state := states.NORMAL
var action := false
var current_facing_direction := facingDirection.UP

var init_delay := true

var input_direction := Vector2.ZERO

var knockback :bool = false
var self_knockback_vector:Vector2 = Vector2.ZERO
var knockback_modifier:int = 1500

var resting:bool = false
var stop:bool = false

signal health_changed(body)
signal defeated(pokemon)

signal attacked(body)
signal run(Value:String)
signal throw
signal switch(Value:String)
signal bag
signal attack_chosen(attack:int)

var opposing_pokemons :Array[PokeEnemy] = []
var Stun:bool = false

var damage_multiplier:float = 1

func _ready():
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",Vector2(0,-1))
	current_facing_direction = facingDirection.UP
	if pokemon != null:
		sprite_2d.texture = pokemon.get_overworld_sprite()
		RegenRate *= pokemon.level
		calc_max_stamina()
		calc_move_speed()
		if pokemon.held_item != null:
			var held_item :HeldItem = load(pokemon.held_item.held_item_file).instantiate()
			held_item.Holder = self
			held_items.add_child(held_item)
			held_item.pre_setup()
		set_inital_status()
func calc_move_speed():
	movement_speed = (pokemon.Base_Pokemon.Base_Speed * 1.5)+ 50
	normal_speed = movement_speed
		
func calc_max_stamina():
	MaxStamina = pokemon.level * (0.1 * pokemon.Max_Attack + 0.2 * pokemon.Max_Speed + 0.3 * pokemon.Max_Defense) + 50
	Stamina = MaxStamina
	
func regen_stamina():
	Stamina = min(Stamina + RegenRate , MaxStamina)
	
func get_input():
	if init_delay == false and action == false:
		if stop == false and resting == false and Stun == false:
			if Input.is_action_just_pressed("attack1"):
				_on_attack_selector_attack_chosen(0)
				emit_signal("attack_chosen",0)
			elif Input.is_action_just_pressed("attack2"):
				_on_attack_selector_attack_chosen(1)
				emit_signal("attack_chosen",1)
			elif Input.is_action_just_pressed("attack3"):
				_on_attack_selector_attack_chosen(2)
				emit_signal("attack_chosen",2)
			elif Input.is_action_just_pressed("attack4"):
				_on_attack_selector_attack_chosen(3)
				emit_signal("attack_chosen",3)

	if Input.is_action_just_pressed("No") and init_delay == false:
		if action == false:
			if state == states.NORMAL:
				AudioManager.select()
				action = true
				state = states.ACTION_SELECTION
				action_chosen.start_radial()
	if stop == false and resting == false and Stun == false:
		if state == states.NORMAL:
			input_direction = Input.get_vector("A", "D", "W", "S")
			
			if tackle == false:
				velocity = input_direction * movement_speed
						
			if input_direction != Vector2.ZERO:
				knockback_vector = input_direction
				animation_tree.set("parameters/Walk/blend_position",input_direction)
				input_to_facing_direction(input_direction)
	if state == states.NORMAL:
		if Input.is_action_just_pressed("dash") and dash.can_dash and !dash.is_dashing():
			dash.start_dash(dash_duration)

func input_to_facing_direction(input_dir):
	if input_dir == Vector2(0,-1):
		current_facing_direction = facingDirection.UP
	elif input_dir == Vector2(0,1):
		current_facing_direction = facingDirection.DOWN
	elif input_dir == Vector2(-1,0):
		current_facing_direction = facingDirection.LEFT
	elif input_dir == Vector2(1,0):
		current_facing_direction= facingDirection.RIGHT

func get_current_facing_direction():
	if current_facing_direction == facingDirection.UP:
		return Vector2(0,-1)
	elif current_facing_direction == facingDirection.DOWN:
		return Vector2(0,1)
	elif current_facing_direction == facingDirection.LEFT:
		return Vector2(-1,0)
	elif current_facing_direction == facingDirection.RIGHT:
		return Vector2(1,0)

func _physics_process(delta):
	get_input()
	move_and_slide()
	self_knockback_vector = self_knockback_vector.move_toward(Vector2.ZERO,10000*delta)
	

	if self_knockback_vector == Vector2.ZERO:
		knockback = false
	
	if knockback == true:
		velocity = self_knockback_vector
	
	if dash.is_dashing():
		movement_speed = dash_speed
	else:
		movement_speed = normal_speed
		
	
func _on_attack_selector_attack_chosen(attack):
	if Stamina > 0:
		if pokemon.get_learned_attacks_size() > attack:
			print(pokemon.get_learned_attack_name(attack))
			var can_attack = manage_stamina(attack)
			if can_attack == true:
				pokemon.initiate_attack(attack,self)
				emit_signal("attacked",self)

func manage_stamina(atk):
	var new_Stamina:int = Stamina
	if previous_moves.has(atk):
		new_Stamina -= pokemon.get_learned_attack(atk).base_action.staminaCost * pokemon.level * 0.7
	else:
		new_Stamina -= (pokemon.get_learned_attack(atk).base_action.staminaCost * pokemon.level  * 0.7) / 2
	previous_moves.append(atk)
	
	if new_Stamina <= 0:
		return false
	else:
		Stamina = new_Stamina
		return true
	manage_move_list()
	
func manage_move_list():
	if previous_moves.size() > 4:
		previous_moves.remove_at(0)
		
	
func _on_timer_timeout():
	init_delay = false

func attack_end():
	state = states.NORMAL
	resting = true
	wait_timer.start()
	animate_wait()

func recive_damage(damage,User,Attacker):
	if dash.is_dashing():
		return
	pokemon.Health -= damage*damage_multiplier
	animate_hurt()
	emit_signal("health_changed",self)
	receive_knockback(User,damage)
	if pokemon.Health <= 0:
		die.play()
		await die.finished
		pokemon.fainted = true
		pokemon.Health = 0
		pokemon.remove_friendship(1)
		emit_signal("defeated",pokemon,self)
		

func recive_plain_damage(damage:int):
	pokemon.Health -= damage
	animate_hurt()
	
	if pokemon.Health <= 0:
		die.play()
		await die.finished
		pokemon.fainted = true
		pokemon.Health = 0
		pokemon.remove_friendship(1)
		emit_signal("defeated",pokemon,opposing_pokemons[0],self)
		
func receive_knockback(body,damage):
	knockback = true
	self_knockback_vector = body.knockback_vector * knockback_modifier + Vector2(damage,damage)
	knock_back.play()
func _stop():
	stop = true

func _start():
	stop = false
	action = false
	


func _on_action_chosen_action_chosen(act):
	action = true
	state = states.NORMAL
	match act:
		0:
			emit_signal("switch","SwitchPokemon")
		1:
			emit_signal("bag")
		2:
			if BattleManager.Trainer_Battle == false:
				emit_signal("throw")
			else:
				action = false
		3:
			emit_signal("run","Run")


func _on_action_chosen_cancel():
	await get_tree().create_timer(0.1).timeout
	action = false
	state = states.NORMAL
	
func _on_action_chosen_displayed():
	velocity = Vector2.ZERO


func _on_wait_timer_timeout():
	resting = false

func animate_hurt():
	hurt.play()
	var tween = get_tree().create_tween()
	sprite_2d.modulate = Color(1, 0, 0)
	tween.tween_property(sprite_2d,"modulate",Color(1,1,1),0.5)

func animate_wait():
	var tween = get_tree().create_tween()
	sprite_2d.modulate = Color(0,0,0)
	tween.tween_property(sprite_2d,"modulate",Color(1,1,1),0.5)

func stun(duration:int = 2):
	stun_timer.start(duration)
	Stun = true

func _on_stun_timer_timeout():
	Stun = false

func animate_modulation_change(color:Color = Color(0, 0.129, 1),time:int = 1):
	var tween = get_tree().create_tween()
	self.modulate = color
		
	tween.tween_property(self, "modulate", Color(1,1,1), time).set_trans(Tween.TRANS_LINEAR)


func _on_regen_timer_timeout():
	regen_stamina()

func paralyze(time:int=1,modifier:float=0.2):
	movement_speed *= modifier
	paralysis_timer.start(time)

func _on_paralysis_timer_timeout():
	movement_speed = (pokemon.Base_Pokemon.Base_Speed * 1.5)+ 50

func add_status_condition(path:String):
	var effect :VolatileStausCondition = load(path).instantiate()
	effect.Holder = self
	status_conditions.add_child(effect)

func set_inital_status():
	if pokemon.status_condition == null:
		return
	var effect:VolatileStausCondition = load(pokemon.status_condition.status_condition).instantiate()
	effect.Holder = self
	status_conditions.add_child(effect)
	
func add_perma_status_condition(status:StatusCondition):
	if pokemon.status_condition != null:
		return
	pokemon.set_status_condition(status)
	var effect :VolatileStausCondition = load(status.status_condition).instantiate()
	effect.Holder = self
	status_conditions.add_child(effect)
