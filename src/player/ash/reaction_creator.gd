extends Node

var neutral_reactions = [
    "is looking at you curiously.",
    "is watching your movements closely.",
    "seems comfortable around you.",
    "is standing calmly beside you.",
    "looks like it’s starting to trust you.",
    "tilted its head, trying to understand you."
]

var high_friendship_reactions = [
    "is gazing at you with admiration!",
    "lets out a happy cry!",
    "looks like it’s enjoying your company!",
    "seems to trust you a lot!",
    "is standing close to you, looking proud!",
    "is bouncing up and down excitedly!"
]

var max_friendship_reactions = [
    "is glowing with happiness!",
    "seems to want to play with you!",
    "is so happy, it can’t stop smiling!",
    "looks ready to take on anything with you!",
    "is nuzzling against you affectionately!",
    "looks like it considers you its best friend!"
]

var low_friendship_reactions = [
    "is staring at you with a blank expression.",
    "seems uneasy being so close to you.",
    "is watching you cautiously.",
    "doesn’t seem very comfortable around you.",
    "turned away as if it doesn’t care.",
    "flinched when you reached out."
]

var very_low_friendship_reactions = [
    "is avoiding your gaze…",
    "doesn't seem to like you very much.",
    "glares at you, seemingly uninterested.",
    "looks like it wants to be left alone.",
    "growled at you softly…",
    "doesn’t seem to want to be here."
]

var natural_scenic_reactions = [
    "is happily sniffing at the scent of the flowers!",
    "is staring at the ocean.",
    "doesn’t seem interested in the scenery."
]

var beach_water_reactions = [
    "is staring at the rolling waves.",
    "is playing in the sand!",
    "looks uncomfortable being near water…"
]

var hot_fire_reactions = [
    "is feeling the heat from the magma!",
    "looks excited by the warmth!",
    "seems uncomfortable in this heat…"
]

var spooky_location_reactions = [
    "is trembling with fear!",
    "seems nervous about something…",
    "is looking around cautiously.",
    "is growling at something unseen."
]

var status_asleep = [
    "is fast asleep… It’s breathing softly.",
    "let out a small snore."
]

var status_burned = [
    "looks like it’s in pain from its burn…",
    "is whimpering softly…"
]

var status_frozen = [
    "seems frozen stiff!",
    "can’t move at all!"
]

var status_paralyzed = [
    "is shivering slightly… It seems stiff!"
]

var status_poisoned = [
    "looks very ill… It might faint!",
    "is struggling to stand…"
]

func get_default_response(pokemon:game_pokemon):
    if pokemon.friendship >= 255:
        return max_friendship_reactions[randi() % max_friendship_reactions.size()]
    elif pokemon.friendship >= 150:
        return high_friendship_reactions[randi() % high_friendship_reactions.size()]
    elif pokemon.friendship >= 100:
        return neutral_reactions[randi() % neutral_reactions.size()]
    elif pokemon.friendship >= 50:
        return low_friendship_reactions[randi() % low_friendship_reactions.size()]
    else:
        return very_low_friendship_reactions[randi() % very_low_friendship_reactions.size()]