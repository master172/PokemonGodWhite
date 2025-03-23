extends Control


@onready var nav_line = $MainContainer/MainBar/HBoxContainer/NavLine
@onready var search_bar = $MainContainer/MainBar/HBoxContainer/SearchBar
@onready var home = $MainContainer/ContentContainer/SideBar/ListContainer/Home
@onready var poke_search = $MainContainer/ContentContainer/MainContainer/PokeSearch
@onready var poke_info = $PokeInfo

enum states {
	HOME,
	PARTY,
	TAXONOMY,
	UNIVERSAL,
	ALPHABETICAL,
	INFO,
}

var current_state = states.HOME
var current_selected = 0
var max_selected = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	TouchInput.pokedex_active()
	nav_line.grab_focus()
	poke_info
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func change_state(state):
	current_state = state
	if current_state == states.HOME:
		poke_search.visible = true
	else:
		poke_search.visible = false
		
func _input(event):
	if event is InputEventAction:
		if event.is_action_pressed("D"):
			if nav_line.has_focus():
				nav_line.release_focus()
				search_bar.grab_focus()
		elif event.is_action_pressed("A"):
			if search_bar.has_focus():
				search_bar.release_focus()
				nav_line.grab_focus()
		elif event.is_action_pressed("S"):
			if nav_line.has_focus():
				nav_line.release_focus()
				await get_tree().create_timer(0.1).timeout
				home.grab_focus()
			elif search_bar.has_focus():
				search_bar.release_focus()
				poke_search.active = true
				poke_search.set_active()
		elif event.is_action_pressed("No"):
			if poke_info.visible == false:
				TouchInput.pokedex_inactive()
				Utils.get_scene_manager().transistion_exit_pokedex_scene()
				
func _on_search_bar_text_submitted(new_text):
	poke_search._on_line_edit_text_submitted(new_text)

func _on_home_pressed():
	change_state(states.HOME)

func _on_party_pressed():
	change_state(states.PARTY)


func _on_taxonomy_pressed():
	change_state(states.TAXONOMY)

func _on_universal_pressed():
	change_state(states.UNIVERSAL)

func _on_alphabetcial_pressed():
	change_state(states.UNIVERSAL)

func _on_poke_search_pokemon_searched():
	change_state(states.HOME)


func _on_poke_search_selected(poke):
	poke_search.active = false
	
	poke_info._set_details(poke)
	poke_info.visible = true


func _on_poke_info_closed():
	poke_search.active = true
	poke_search.set_active()
