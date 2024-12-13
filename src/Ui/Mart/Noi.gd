extends TextureRect

@onready var num :Label= $VBoxContainer/Pricing/num
@onready var amount :Label= $VBoxContainer/Pricing/price

func set_values(count,price):
	num.text = str(count)
	amount.text = "$" +str(count*price)
	
