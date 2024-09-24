extends Control


@onready var nav_line = $MainContainer/MainBar/HBoxContainer/NavLine
@onready var search_bar = $MainContainer/MainBar/HBoxContainer/SearchBar
@onready var home = $MainContainer/ContentContainer/SideBar/ListContainer/Home
@onready var poke_search = $MainContainer/ContentContainer/MainContainer/PokeSearch

# Called when the node enters the scene tree for the first time.
func _ready():
	nav_line.grab_focus()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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


func _on_search_bar_text_submitted(new_text):
	poke_search._on_line_edit_text_submitted(new_text)
