extends Node2D

var _level
var _available_to_enact = true

@onready var _placed_platform_scene = preload("res://char/ability/basic_platform/standard_placed_plat.tscn")
@onready var _cooldown_timer = $CooldownTimer


func set_level(level):
	_level = level

func enact_ability():
	if !_available_to_enact:
		return false
	_available_to_enact = false
	_cooldown_timer.start()

	var new_platform = _placed_platform_scene.instantiate()
	new_platform.position = Vector2(position.x, position.y + 30)
	_level.add_child(new_platform)
	new_platform.setup(global_position)

func _on_cooldown_timer_timeout():
	_available_to_enact = true