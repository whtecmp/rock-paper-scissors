extends Node

export(PackedScene) var ClientPlayer;
export(PackedScene) var RemotePlayer;
export(PackedScene) var LittleMe;

signal start_server_game;
signal i_lost;
var client_ids = [];
var id_to_player = {};
var is_server = false;
var game_started = false;
var my_name;

func _ready():
	pass

func _physics_process(delta):
	if is_server and game_started:
		var name_to_update = {};
		for id in client_ids:
			name_to_update[generate_name(id)] = {
				"position": id_to_player[id].position,
				"what_am_i": id_to_player[id].what_am_i
			};
		var main = get_parent();
		var little_mes_info = [];
		for child in main.get_children():
			if "LittleMe" in child.get_name():
				little_mes_info.append({
					"position": child.position, 
					"what_am_i": child.what_am_i
					});
		for id in client_ids:
			rpc_id(id, "update_me", name_to_update, little_mes_info)

func start_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8080, 2)
	get_tree().network_peer = peer
	get_tree().connect("network_peer_connected", self, "_player_connected")
	is_server = true;
	
func connect_to_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client('127.0.0.1', 8080)
	get_tree().network_peer = peer

func restart_server(winner_index):
	var i = 0;
	for id in client_ids:
		if winner_index == i:
			rpc_id(id, "i_won");
		else:
			rpc_id(id, "i_lost");
		get_tree().network_peer.disconnect_peer(id);
		i += 1
	client_ids = [];
	id_to_player = {};
	game_started = false;

func _player_connected(id):
	print ('S: Player ' + str(id) + ' connected!')
	client_ids.append(id);
	if len(client_ids) == 2:
		emit_signal("start_server_game", client_ids)

func generate_name(id):
	return "Player_" + str(id)

remote func set_action(action):
	var id = get_tree().get_rpc_sender_id()
	id_to_player[id].set_action(action);

remote func update_me(name_to_update, little_mes_info):
	for name in name_to_update:
		var node = get_parent().get_node(str(name));
		var update = name_to_update[name];
		node.position = update["position"];
		node.what_am_i = update["what_am_i"];
	var main = get_parent();
	for child in main.get_children():
		if "LittleMe" in child.get_name():
			child.queue_free()
	for info in little_mes_info:
		var little_me = LittleMe.instance();
		little_me.position = info["position"];
		little_me.what_am_i = info["what_am_i"];
		main.add_child(little_me)

remote func create_remote_players(_my_name, names):
	var main = get_parent();
	my_name = _my_name
	var client_player = ClientPlayer.instance();
	client_player.set_name(my_name)
	client_player.networking = self;
	main.add_child(client_player);
	for name in names:
		if name != my_name:
			var remote_player = RemotePlayer.instance();
			remote_player.set_name(name);
			main.add_child(remote_player);

remote func i_won():
	#get_tree().network_peer.close_connection();
	get_parent().restart("You Won! :)", 0);

remote func i_lost():
	#get_tree().network_peer.close_connection();
	get_parent().restart("You Lost! :(", 0);
