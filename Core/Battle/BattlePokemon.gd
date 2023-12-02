class_name BattlePokemon
extends CharacterBody2D

@export var movement_speed := 256

@onready var wait_timer = $WaitTimer

@onready var animation_tree := $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var sprite_2d := $Sprite2D
@onready var attack_selector := $UiLayer/BattleSelector
@onready var action_chosen := $UiLayer/ActionChosen
@onready var stun_timer = $StunTimer
@onready var hurt = $Node/Hurt
@onready var die = $Node/Die
@onready var knock_back = $Node/KnockBack
@onready var paralysis_timer = $ParalysisTimer

@export var pokemon :game_pokemon = null

var knockback_vector :Vector2 = Vector2.ZERO

var previous_moves:Array = []

var Stamina:int = 0
var MaxStamina:int = 0
var RegenRate:int = 1

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
var attacking := false
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

var opposing_pokemons :Array[PokeEnemy] = []
var Stun:bool = false

func _ready():
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",Vector2(0,-1))
	current_facing_direction = facingDirection.UP
	if pokemon != null:
		sprite_2d.texture = pokemon.get_overworld_sprite()
		RegenRate *= pokemon.level
		calc_max_stamina()
		movement_speed = (pokemon.Base_Pokemon.Base_Speed * 1.5)+ 50
		
func calc_max_stamina():
	MaxStamina = pokemon.level * (0.1 * pokemon.Max_Attack + 0.2 * pokemon.Max_Speed + 0.3 * pokemon.Max_Defense) + 50
	Stamina = MaxStamina
	
func regen_stamina():
	Stamina = min(Stamina + RegenRate , MaxStamina)
	
func get_input():
				
			
	if knockback == false:
		if Input.is_action_just_pressed("Yes") and init_delay == false:
			if attacking == false and action == false:
				if stop == false and resting == false and Stun == false:
					AudioManager.select()
					state = states.ATTACK_SELECTION
					attack_selector.start_radial()
		elif Input.is_action_just_pressed("No") and init_delay == false:
			if attacking == false and action == false:
				AudioManager.select()
				action = true
				state = states.ACTION_SELECTION
				action_chosen.start_radial()
		else:
			if stop == false and resting == false and Stun == false:
				if state == states.NORMAL:
					input_direction = Input.get_vector("A", "D", "W", "S")
						
					velocity = input_direction * movement_speed
						
					if input_direction != Vector2.ZERO:
						knockback_vector = input_direction
						animation_tree.set("parameters/Walk/blend_position",input_direction)
						input_to_facing_direction(input_direction)

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
		
func _on_attack_selector_attack_chosen(attack):
	if Stamina > 0:
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


func _on_attack_selector_cancel():
	attacking = false
	state = states.NORMAL

func attack_prep():
	attacking = true

func attack_end():
	attacking = false
	state = states.NORMAL
	resting = true
	wait_timer.start()
	animate_wait()

func recive_damage(damage,User,Attacker):
	pokemon.Health -= damage
	animate_hurt()
	emit_signal("health_changed",self)
	receive_knockback(User,damage)
	if pokemon.Health <= 0:
		die.play()
		await die.finished
		pokemon.fainted = true
		pokemon.Health = 0
		emit_signal("defeated",pokemon,self)
		

		
func receive_knockback(body,damage):
	knockback = true
	self_knockback_vector = body.knockback_vector * knockback_modifier + Vector2(damage,damage)
	knock_back.play()
func _stop():
	stop = true

func _start():
	stop = false
	action = false
	
func _on_attack_selector_displayed():
	velocity = Vector2.ZERO


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
	attacking = false
	
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
