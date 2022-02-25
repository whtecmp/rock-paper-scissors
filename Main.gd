extends Node

export(PackedScene) var Player;
export(PackedScene) var Server;
export(PackedScene) var ClientPlayer;

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
	add_player("Keyboard", Vector2(100, 100), 2);
	add_player("Gamepad", Vector2(300, 300), 36);

func _on_MainMenue_host_server():
	var server = Server.instance();
	add_child(server);
	server.start_server();
	server.connect("start_server_game", self, "_on_Server_start_server_game")
 
func _on_MainMenue_quick_match():
	var server = Server.instance();
	add_child(server);
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client('127.0.0.1', 8080)
	get_tree().network_peer = peer
	var client_player = ClientPlayer.instance();
	client_player.server = server;
	add_child(client_player);

func _on_Server_start_server_game(client_ids):
	var id_to_player = {};
	id_to_player[client_ids[0]] = add_player("Network", Vector2(100, 100), 2);
	id_to_player[client_ids[1]] = add_player("Network", Vector2(300, 300), 36);
	$Server.id_to_player = id_to_player;
