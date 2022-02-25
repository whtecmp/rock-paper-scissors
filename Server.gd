extends Node

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8080, 2)
	get_tree().network_peer = peer
	get_tree().connect("network_peer_connected", self, "_player_connected")

func _player_connected(id):
	print ('S: Player ' + str(id) + ' connected!')
