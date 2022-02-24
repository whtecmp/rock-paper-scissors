extends Node

export(PackedScene) var Player; 

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_player(control_scheme, position, layer_index):
	var player = Player.instance();
	player.control_scheme = control_scheme;
	player.position = position;
	player.set_collision_mask(layer_index);
	get_node("../Main").add_child(player);
	return player;

func _on_MainMenue_local_match():
	add_player("Keyboard", Vector2(100, 100), 2);
	add_player("Gamepad", Vector2(300, 300), 36);

