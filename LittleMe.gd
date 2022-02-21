extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var what_am_i


func change_what_am_i(new_what_am_i):
	what_am_i = new_what_am_i

func _ready():
	get_node(what_am_i).visible = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LittleMe_area_entered(area):
	pass # Replace with function body.
