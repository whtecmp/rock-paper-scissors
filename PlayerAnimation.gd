extends CanvasModulate


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func transform(what_am_i):
	$Rock.visible = false;
	$Paper.visible = false;
	$Scissor.visible = false;
	get_node(what_am_i).visible = true;

func confuse():
	modulate = Color(1, 1, 1, 0.3);
	$Confusion.visible = true;
	
func unconfuse():
	modulate = Color(1, 1, 1, 1);
	$Confusion.visible = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
