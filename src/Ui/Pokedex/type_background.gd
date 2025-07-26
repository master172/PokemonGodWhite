extends Panel

var TYPE_COLORS := {
	"Normal": Color(0.8, 0.8, 0.7),       # Soft gray
	"Fighting": Color(0.8, 0.2, 0.2),     # Brick red
	"Flying": Color(0.6, 0.6, 1.0),       # Light blue
	"Poison": Color(0.6, 0.2, 0.7),       # Purple
	"Ground": Color(0.8, 0.7, 0.4),       # Brownish tan
	"Rock": Color(0.6, 0.5, 0.3),         # Stone brown
	"Bug": Color(0.5, 0.8, 0.2),          # Green
	"Ghost": Color(0.4, 0.4, 0.7),        # Dusky blue-purple
	"Steel": Color(0.6, 0.6, 0.7),        # Silvery gray
	"Fire": Color(1.0, 0.4, 0.2),         # Orange-red
	"Water": Color(0.2, 0.4, 1.0),        # Deep blue
	"Grass": Color(0.2, 0.8, 0.2),        # Vibrant green
	"Electric": Color(1.0, 1.0, 0.3),     # Bright yellow
	"Psychic": Color(1.0, 0.4, 0.7),      # Pink
	"Ice": Color(0.6, 0.9, 1.0),          # Light icy blue
	"Dragon": Color(0.5, 0.2, 1.0),       # Royal purple
	"Dark": Color(0.3, 0.3, 0.3),         # Dark gray
	"Fairy": Color(1.0, 0.7, 1.0)         # Pastel pink
}

@onready var type_label: Label = $Type

@export_enum(
	"Normal",
	"Fighting",
	"Flying",
	"Poison",
	"Ground",
	"Rock",
	"Bug",
	"Ghost",
	"Steel",
	"Fire",
	"Water",
	"Grass",
	"Electric",
	"Psychic",
	"Ice",
	"Dragon",
	"Dark",
	"Fairy",
	"None"
	) var DefType:String = "None"

func _ready() -> void:
	if DefType != "None":
		set_type(DefType)
		
func set_type(type:String)->void:
	type_label.text = type
	self_modulate = TYPE_COLORS[type]
