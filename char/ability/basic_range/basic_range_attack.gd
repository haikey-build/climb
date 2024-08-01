extends Node2D

var _available_to_enact = true
var _range_speed = 1200
var _level

@onready var _attack_area_scene = preload("res://char/ability/basic_range/basic_range_attack_area.tscn")
@onready var _cooldown_timer = $CooldownTimer

func set_level(level):
	_level = level

func enact_ability():
	if !_available_to_enact:
		return false
	_available_to_enact = false
	_cooldown_timer.start()
	
	var attack_area = _attack_area_scene.instantiate()

	
	var mouse_position = get_global_mouse_position()
	var v = mouse_position - global_position
	var look_angle = v.angle()
	var travel_direction = v.normalized()

	attack_area.rotation = look_angle + (PI / 2)
	_level.add_child(attack_area)
	attack_area.setup(travel_direction, _range_speed, global_position)


func _on_cooldown_timer_timeout():
	_available_to_enact = true
