extends Node2D

export var control_scheme = "Keyboard";
var networking;
var confused = false;

var control_scheme_to_key_to_action = {
	"Keyboard": {
		"ui_left": "left",
		"ui_right": "right",
		"ui_up": "up",
		"ui_down": "down",
		"z": "rock",
		"x": "paper",
		"c": "scissor"
	},
	"Gamepad": {
		"c_left": "left",
		"c_right": "right",
		"c_up": "up",
		"c_down": "down",
		"c_al": "rock",
		"c_ad": "paper",
		"c_ar": "scissor"
	},
}
var key_to_action;
var what_am_i = "Paper";

func _ready():
	key_to_action = control_scheme_to_key_to_action[control_scheme]

func _physics_process(delta):
	for key in key_to_action:
		if Input.is_action_just_pressed(key):
			networking.rpc_id(1, "set_action", key_to_action[key])
			return
	$PlayerAnimation.transform(what_am_i);
	if confused:
		$PlayerAnimation.confuse();
	else:
		$PlayerAnimation.unconfuse();
