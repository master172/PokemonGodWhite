extends encounterManager
class_name SurfEncounterManager


func check_encounter():
	if Utils.can_encounter == true and Utils.get_player().is_surfing == true:
		if Utils.get_scene_manager() != null:
			if encounter() == true:
				var Rng = RandomNumberGenerator.new()
				var pokemon = [get_encounter_pokemon(),Rng.randi_range(min_level,max_level),]
				if pokemon == null:
					return
				if talisman_attuned(pokemon):
					return
				var pokemon_to_encounter = game_pokemon.new(pokemon[0],pokemon[1])
				BattleManager.current_ai_level = 0
				Utils.get_scene_manager().transition_to_battle_scene(pokemon_to_encounter,map)
				Utils.get_player().change_animation(false)
