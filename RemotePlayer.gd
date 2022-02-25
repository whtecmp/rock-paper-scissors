extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var what_am_i = "Paper";
var confused = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$PlayerAnimation.transform(what_am_i);
	if confused:
		$PlayerAnimation.confuse();
	else:
		$PlayerAnimation.unconfuse();
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
