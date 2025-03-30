extends Control

@onready var poke_image = $VBoxContainer/PokeInfo/PokeImage

@onready var Name = $VBoxContainer/PokeInfo/HBoxContainer/VBoxContainer/Name
@onready var progress_bar = $VBoxContainer/PokeInfo/HBoxContainer/VBoxContainer/ProgressBar
@onready var level = $VBoxContainer/PokeInfo/HBoxContainer/VBoxContainer/Level

@onready var scroll_container = $VBoxContainer/OverContainer/MovesContainer/Panel2/ScrollContainer
@onready var learnable = $VBoxContainer/OverContainer/MovesContainer/Panel2/ScrollContainer/Learnable

@onready var learned = $VBoxContainer/OverContainer/MovesContainer/Panel/Learned

const learned_move = preload("res://src/Ui/MoveManager/move_1.tscn")
const learnable_move = preload("res://src/Ui/MoveManager/learnable_1.tscn")

var active:bool = false

enum states {LEARNED,LEARNABLE,SWITCHING}
var state = states.LEARNED

var current_selected:int = 0
var max_selectable:int = 4

var pokemon:game_pokemon

var index1:int = 0
var index2:int = 0

signal quit

func all_update():
	update()
	add_learned_moves()
	add_learnable_moves()
	
	await get_tree().create_timer(0.1).timeout
	set_learned_max_selected()
	set_learned_active()
	
func update_move_forgot():
	add_learned_moves()
	add_learnable_moves()
	
	await get_tree().create_timer(0.1).timeout
	set_learned_max_selected()
	set_learnable_active()
	
func update_move_learned():
	add_learned_moves()
	add_learnable_moves()
	
	await get_tree().create_timer(0.1).timeout
	set_learnable_active()
	set_learnable_max_selected()
	
	
func update():
	if pokemon != null:
		poke_image.texture = pokemon.get_front_sprite()
		Name.text = pokemon.Nick_name
		level.text = "Level : "+str(pokemon.level)
		progress_bar.max_value = pokemon.Max_Health
		progress_bar.value = pokemon.Health

func add_learned_moves():
	for i in learned.get_children():
		i.queue_free()
		
	for i in range(pokemon.learned_attacks.size()):
		var Move = learned_move.instantiate()
		Move.pokemon = pokemon
		Move.index = i
		learned.add_child(Move)
	
	
func add_learnable_moves():
	for i in learnable.get_children():
		i.queue_free()
		
	for i in range(pokemon.learnable_attacks.size()):
		var Move = learnable_move.instantiate()
		Move.pokemon = pokemon
		Move.index = i
		learnable.add_child(Move)
	
func set_learned_active():
	learned.get_child(current_selected).set_active(true)

func set_learned_inactive():
	learned.get_child(current_selected).set_active(false)

func set_learnable_active():
	if learnable.get_child_count() >= current_selected + 1:
		learnable.get_child(current_selected).set_active(true)

func set_learnable_inactive():
	if learnable.get_child_count() >= current_selected + 1:
		learnable.get_child(current_selected).set_active(false)
	
func _input(event):
	if active == true:
		if event.is_action_pressed("W"):
			AudioManager.input()
			if state == states.LEARNED:
				set_learned_inactive()
				if max_selectable > 0:
					current_selected  = (current_selected +max_selectable - 1) % max_selectable
				set_learned_active()
			elif state == states.SWITCHING:
				set_learned_inactive()
				if max_selectable > 0:
					current_selected  = (current_selected +max_selectable - 1) % max_selectable
				set_learned_active()
			elif state == states.LEARNABLE:
				set_learnable_inactive()
				if max_selectable > 0:
					current_selected  = (current_selected +max_selectable - 1) % max_selectable
				set_learnable_active()
				
				if current_selected > 5:
					scroll_container.scroll_vertical -= 79
				
				if current_selected == max_selectable -1:
					scroll_container.scroll_vertical = (learnable.get_child_count() -1) * 79
				
		elif event.is_action_pressed("A"):
			AudioManager.input()
			if state == states.LEARNABLE:
				set_learnable_inactive()
				current_selected = 0
				set_learned_max_selected()
				state = states.LEARNED
				set_learned_active()
				
		elif event.is_action_pressed("S"):
			AudioManager.input()
			if state == states.LEARNED:
				set_learned_inactive()
				if max_selectable > 0:
					current_selected = (current_selected + 1) %max_selectable
				set_learned_active()
			elif state == states.SWITCHING:
				set_learned_inactive()
				if max_selectable > 0:
					current_selected = (current_selected + 1) %max_selectable
				set_learned_active()
			elif state == states.LEARNABLE:
				set_learnable_inactive()
				if max_selectable > 0:
					current_selected = (current_selected + 1) %max_selectable
				set_learnable_active()
				
				if current_selected > 6:
					scroll_container.scroll_vertical += 79
				
				if current_selected == 0:
					scroll_container.scroll_vertical = 0
				
		elif event.is_action_pressed("D"):
			AudioManager.input()
			if state == states.LEARNED:
				set_learned_inactive()
				current_selected = 0
				set_learnable_max_selected()
				state = states.LEARNABLE
				set_learnable_active()

				
		elif event.is_action_pressed("Yes"):
			AudioManager.select()
			if state == states.LEARNED:
				if pokemon.get_learned_attacks_size() > 1:
					pokemon.forget_move_manual(current_selected)
					if current_selected >0:
						current_selected -=1
					update_move_forgot()
					
			elif state == states.LEARNABLE:
				if pokemon.get_learned_attacks_size() <= 3:
					pokemon.learn_move_manual(current_selected)
					if current_selected >0:
						current_selected -= 1
					await get_tree().create_timer(0.1).timeout
					update_move_learned()
				else:
					state = states.SWITCHING
					set_learnable_inactive()
					index2 = current_selected
					current_selected = 0
					set_learned_max_selected()
					set_learned_active()
					
			elif state == states.SWITCHING:
				index1 = current_selected
				pokemon.replace_moves_manual(index1,index2)
				set_learned_inactive()
				current_selected = index2
				set_learnable_active()
				state = states.LEARNABLE
				index1 = 0
				index2 = 0
				switch_update()
				
		elif event.is_action_pressed("No"):
			AudioManager.cancel()
			if state == states.LEARNED:
				active = false
				emit_signal("quit")
			elif state == states.LEARNABLE:
				active = false
				emit_signal("quit")
			elif state == states.SWITCHING:
				state = states.LEARNED
				index2 = 0

func set_learned_max_selected():
	max_selectable = pokemon.learned_attacks.size()

func set_learnable_max_selected():
	max_selectable = pokemon.learnable_attacks.size()

func switch_update():
	for i in learnable.get_children():
		i.update()
	for i in learned.get_children():
		i.update()
