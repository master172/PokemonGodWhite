extends GameAbility

func setup():
	if Holder is BattlePokemon:
		Holder.attack_chosen.connect(say_something)

func say_something(_attack:int):
	print("😄")
