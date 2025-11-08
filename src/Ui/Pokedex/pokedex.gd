extends Control


@onready var nav_line = $MainContainer/MainBar/HBoxContainer/NavLine
@onready var search_bar = $MainContainer/MainBar/HBoxContainer/SearchBar
@onready var home = $MainContainer/ContentContainer/SideBar/ListContainer/Home
@onready var poke_search = $MainContainer/ContentContainer/MainContainer/PokeSearch
@onready var poke_info = $PokeInfo
@onready var taxonomy: Button = $MainContainer/ContentContainer/SideBar/ListContainer/Taxonomy
@onready var universal: Button = $MainContainer/ContentContainer/SideBar/ListContainer/Universal
@onready var alphabetcial: Button = $MainContainer/ContentContainer/SideBar/ListContainer/Alphabetcial
@onready var party: Button = $MainContainer/ContentContainer/SideBar/ListContainer/Party

enum states {
	HOME,
	PARTY,
	TAXONOMY,
	UNIVERSAL,
	ALPHABETICAL,
	INFO,
}

@onready var side_list:Array[Button] = [home,party,taxonomy,universal,alphabetcial]
var side_list_index:int = 0
@onready var max_side_options = side_list.size()

var current_state = states.HOME
var current_selected = 0
var max_selected = 0

enum ui_states {
	SEARCH,
	SIDE_NAV,
	POKEMON,
	INFO
}

var current_ui_state = ui_states.SEARCH
var current_button_active:Button
# Called when the node enters the scene tree for the first time.
func _ready():
	TouchInput.pokedex_active()
	search_bar.grab_focus()
	
func change_state(state):
	current_state = state
	if current_state == states.HOME:
		poke_search.visible = true
	else:
		poke_search.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("A"):
		if current_ui_state in [ui_states.SEARCH,ui_states.POKEMON] and search_bar.is_editing() == false:
			search_bar.release_focus()
			home.grab_focus()
			current_ui_state = ui_states.SIDE_NAV
			current_button_active = home
			poke_search.active = false
			poke_search.deactivate()
	elif event.is_action_pressed("D"):
		if current_ui_state == ui_states.SIDE_NAV:
			current_button_active.release_focus()
			current_button_active = null
			await get_tree().create_timer(0.1).timeout
			search_bar.grab_focus()
			current_ui_state = ui_states.SEARCH
	elif event.is_action_pressed("S"):
		if current_ui_state == ui_states.SIDE_NAV:
			side_list_index = (side_list_index + 1) % max_side_options
			current_button_active.release_focus()
			current_button_active = side_list[side_list_index]
			current_button_active.grab_focus()
		elif current_ui_state == ui_states.SEARCH and search_bar.is_editing() == false:
			current_ui_state = ui_states.POKEMON
			search_bar.release_focus()
			poke_search.active = true
			poke_search.set_active()
	elif event.is_action_pressed("W"):
		if current_ui_state == ui_states.SIDE_NAV:
			side_list_index = (side_list_index + max_side_options -1) % max_side_options
			current_button_active.release_focus()
			current_button_active = side_list[side_list_index]
			current_button_active.grab_focus()
	elif event.is_action_pressed("No"):
		if poke_info.visible == false and search_bar.is_editing() == false:
			TouchInput.pokedex_inactive()
			Utils.get_scene_manager().transition_exit_pokedex_scene()
				
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
	search_bar.release_focus()
	current_ui_state = ui_states.INFO
	
	poke_info._set_details(poke)
	poke_info.visible = true


func _on_poke_info_closed():
	poke_search.active = true
	poke_search.set_active()
	current_ui_state = ui_states.POKEMON


func _on_poke_search_leaving() -> void:
	if current_ui_state == ui_states.POKEMON:
		poke_search.reset()
		poke_search.active = false
		poke_search.set_inactive()
		poke_search.set_inactive()
		current_ui_state = ui_states.SEARCH
		await get_tree().create_timer(0.1).timeout
		search_bar.grab_focus()
		
