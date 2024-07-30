extends Node2D

var _available_to_enact = true
var _range_speed = 1200

@onready var _attack_area_scene = preload("res://char/ability/basic_range/basic_range_attack_area.tscn")


func enact_ability():
	if !_available_to_enact:
		return false
	
	# TODO object pooling
	var attack_area = _attack_area_scene.instantiate()

	
	var mouse_position = get_global_mouse_position()
	var v = mouse_position - global_position
	var look_angle = v.angle()
	var travel_direction = v.normalized()

	attack_area.rotation = look_angle + (PI / 2)
	attack_area.setup(travel_direction, _range_speed, global_position)

	add_child(attack_area)
