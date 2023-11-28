extends StaticBody2D

@export var item:BaseItem = null
@export var pick_up_dialog:DialogueLine = null

var picked:bool = false

var saver:ItemSaver = ItemSaver.new()

var save_file_path = "user://save/Overworld/"
var save_file_name = "Items.tres"

func _ready():
	if !DirAccess.dir_exists_absolute(save_file_path):
		verify_save_directory(save_file_path)
	var SceneManager = Utils.get_scene_manager()
	if SceneManager == null:
		return
	await get_tree().create_timer(0.01).timeout
	var scene_name = SceneManager.get_current_scene().name
	save_file_name = scene_name+self.name+".tres"
	load_data()
	
func _interact():
	Utils.current_picking_up = self
	pick_up_dialog.add_symbols_to_replace({"Item":item.Name})
	DialogLayer.get_child(0)._start(pick_up_dialog)
	DialogLayer.get_child(0).connect("finished",finish)
	
func finish(dial):
	if dial == pick_up_dialog:
		Utils.get_player().set_physics_process(true)
	DialogLayer.get_child(0).disconnect("finished",finish)
		

func pick_up():
	item.pick_up()
	picked = true
	visible = false
	$CollisionShape2D.disabled = true
	saver.picked = picked
	save_data()
	
func set_load():
	if picked == true:
		visible = false
		$CollisionShape2D.disabled = true
		
#func save():
#	var save_dict = {
#		"node":self.get_path(),
#		"picked":picked,
#	}
#	return save_dict

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
	
func save_data():
	ResourceSaver.save(saver,save_file_path + save_file_name)
	
func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		saver = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	apply_data()

func apply_data():
	picked = saver.picked
	set_load()
