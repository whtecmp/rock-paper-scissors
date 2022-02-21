extends Node

func _ready():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(8080, 2)
	get_tree().network_peer = peer 
