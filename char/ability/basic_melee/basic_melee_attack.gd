extends Node2D

var _available_to_enact = true
var _level

@onready var _attack_area_scene = preload("res://char/ability/basic_melee/basic_melee_attack_area.tscn")

func set_level(level):
	_level = level

func enact_ability():
	if !_available_to_enact:
		return false
	
	var attack_area = _attack_area_scene.instantiate()

	var mouse_position = get_global_mouse_position()
	var v = mouse_position - global_position
	var look_angle = v.angle()


	_level.add_child(attack_area)
	attack_area.setup(global_position, look_angle)


