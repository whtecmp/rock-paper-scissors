extends Node

signal start_server_game
var client_ids = [];
var id_to_player = {};

func _ready():
	pass

func start_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8080, 2)
	get_tree().network_peer = peer
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
	print ('S: Player ' + str(id) + ' connected!')
	client_ids.append(id);
	if len(client_ids) == 2:
		emit_signal("start_server_game", client_ids)

remote func set_action(action):
	var id = get_tree().get_rpc_sender_id()
	id_to_player[id].set_action(action);
