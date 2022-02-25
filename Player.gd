extends KinematicBody2D

export(PackedScene) var little_me_scene

signal i_lost;

var velocity = 400;
var direction = Vector2(1, 0);
onready var what_am_i = "Paper";
var confused = false;
var hit_points = 5; 
var latest_action = null;
var my_index;

export var control_scheme = "Keyboard";
var control_scheme_to_key_to_what = {
	"Keyboard": {
		"z": "Rock",
		"x": "Paper",
		"c": "Scissor"
	},
	"Gamepad": {
		"c_al": "Rock",
		"c_ad": "Paper",
		"c_ar": "Scissor"
	},
	"Network": {
		"rock": "Rock",
		"paper": "Paper",
		"scissor": "Scissor"
	}
}

var key_to_what;

var control_scheme_to_key_to_vector = {
	"Keyboard": {
		"ui_left": Vector2(-1, 0),
		"ui_right": Vector2(1, 0),
		"ui_up": Vector2(0, -1),
		"ui_down": Vector2(0, 1),
	},
	"Gamepad": {
		"c_left": Vector2(-1, 0),
		"c_right": Vector2(1, 0),
		"c_up": Vector2(0, -1),
		"c_down": Vector2(0, 1),
	},	
	"Network": {
		"left": Vector2(-1, 0),
		"right": Vector2(1, 0),
		"up": Vector2(0, -1),
		"down": Vector2(0, 1),
	}
}
var key_to_vector;

onready var control_scheme_to_action_checker = {
	"Keyboard": funcref(Input, "is_action_just_pressed"),
	"Gamepad": funcref(Input, "is_action_just_pressed"),
	"Network": funcref(self, "check_socket_action"),
}
var check_action;

var screen_size;

func _ready():
	key_to_what = control_scheme_to_key_to_what[control_scheme];
	key_to_vector = control_scheme_to_key_to_vector[control_scheme];
	check_action = control_scheme_to_action_checker[control_scheme];
	screen_size = get_viewport_rect().size;

func _physics_process(delta):
	for key in key_to_vector:
		direction = get_direction(key);
	var _velocity = direction * velocity * delta;
	move_and_collide(_velocity)
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
	for key in key_to_what:
		input_form(key);
	transform();
	if hit_points <= 0:
		get_parent().restart("Player " + str(3 - my_index) + " won!", 3 - my_index);
		queue_free();

func check_socket_action(key):
	return latest_action == key;

func input_form(key):
	if not confused and check_action.call_func(key):
		latest_action = null;
		what_am_i = key_to_what[key];
		confused = true;
		$TransformTimer.start();
		$PlayerAnimation.confuse();

func transform():
	$PlayerAnimation.transform(what_am_i)

func compare_battle(what1, what2):
	var what_to_num = {
		"Rock": 0,
		"Paper": 1,
		"Scissor": 2,
	}
	var number = what_to_num[what1] - what_to_num[what2];
	return -(((3-((3-(((3-((number+3)%3))%3)+1))%3))%3)-1);
	# This ^ and this V are the Same
	#if number in [1, -2]:
	#	return 1;
	#elif number in [-1, 2]:
	#	return -1;
	#else:
	#	return 0;

func get_direction(key):
	if check_action.call_func(key) and direction != -key_to_vector[key]:
		latest_action = null;
		return key_to_vector[key];
	return direction;

func _on_TransformTimer_timeout():
	confused = false;
	$PlayerAnimation.unconfuse();

func _on_LittleMeTimer_timeout():
	if not confused:
		var little_me = little_me_scene.instance()
		little_me.change_what_am_i(what_am_i)
		little_me.position = position
		get_parent().add_child(little_me)

func _on_Player_area_entered(area):
	if "LittleMe" in area.get_name():
		var battle_result = compare_battle(what_am_i, area.what_am_i);
		if battle_result == 1:
			area.queue_free();
		elif battle_result == -1:
			hit_points -= 1;
			area.queue_free();

remote func set_action(action):
	latest_action = action
