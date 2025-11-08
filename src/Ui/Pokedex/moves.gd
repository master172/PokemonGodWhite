extends VBoxContainer
@onready var scroll_container: ScrollContainer = $ScrollContainer

func reset_data():
	scroll_container.reset_data()
