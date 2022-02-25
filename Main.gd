extends Node

export(PackedScene) var Player;
export(PackedScene) var Networking;
export(PackedScene) var ClientPlayer;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var networking;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func add_player(control_scheme, position, layer_index):
	var player = Player.instance();
	player.control_scheme = control_scheme;
	player.position = position;
	player.set_collision_mask(layer_index);
	add_child(player);
	return player;

func _on_MainMenue_local_match():
	$Blocks.visible = true;
	add_player("Keyboard", Vector2(100, 100), 2);
	add_player("Gamepad", Vector2(300, 300), 36);

func _on_MainMenue_host_server():
	$Blocks.visible = true;
	networking = Networking.instance();
	add_child(networking);
	networking.start_server();
	networking.connect("start_server_game", self, "_on_Server_start_server_game")
 
func _on_MainMenue_quick_match():
	$Blocks.visible = true;
	networking = Networking.instance();
	add_child(networking);
	networking.connect_to_server()

func _on_Server_start_server_game(client_ids):
	var id_to_player = {};
	id_to_player[client_ids[0]] = add_player("Network", Vector2(100, 100), 2);
	id_to_player[client_ids[1]] = add_player("Network", Vector2(300, 300), 36);
	networking.id_to_player = id_to_player;
	var names = [];
	for id in networking.client_ids:
		names.append(networking.generate_name(id))
	for id in networking.client_ids:
		networking.rpc_id(id, "create_remote_players", networking.generate_name(id), names);
	networking.game_started = true;
