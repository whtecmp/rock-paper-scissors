extends CanvasModulate

signal local_match
signal host_server
signal quick_match

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_LocalMatch_pressed():
	emit_signal("local_match")
	visible = false;

func _on_HostServer_pressed():
	emit_signal("host_server")
	visible = false;

func _on_QuickOnlineMatch_pressed():
	emit_signal("quick_match")
	visible = false;
