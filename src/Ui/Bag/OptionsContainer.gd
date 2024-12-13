extends NinePatchRect

@onready var v_box_container = $VBoxContainer


func _set_selected(num:int):
	v_box_container.get_child(num)._set_active(true)

func _unset_selected(num:int):
	v_box_container.get_child(num)._set_active(false)
