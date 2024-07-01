extends Node2D

@onready var _placed_platform_scene = preload("res://level/blocks/standard_placed_plat.tscn")
@onready var _platforms = []

func _on_desert_char_set_platform_attempted(pos, type):
	var new_platform = _placed_platform_scene.instantiate()
	new_platform.position = Vector2(pos.x, pos.y + 30)
	add_child(new_platform)
	_platforms.push_back(new_platform)
	_break_after_timer(new_platform)


func _break_after_timer(platform):
	await get_tree().create_timer(1.0).timeout
	platform.queue_free()
