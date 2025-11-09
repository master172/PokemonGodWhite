extends TextureRect

func change_selected(value:bool):
	if value == true:
		texture.region = Rect2(54,4,54,16)
	else:
		texture.region = Rect2(0,4,54,16)
