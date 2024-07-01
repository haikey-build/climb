extends Node2D

@onready var _placed_platform_scene = preload("res://level/blocks/standard_placed_plat.tscn")
@onready var _world_platform_scene = preload("res://background/floating_platform.tscn")
@onready var _player_platforms = []
@onready var _world_platforms = [$FloatingPlatform]
@onready var _rng = RandomNumberGenerator.new()


func _on_desert_char_set_platform_attempted(pos, type):
	var new_platform = _placed_platform_scene.instantiate()
	new_platform.position = Vector2(pos.x, pos.y + 30)
	add_child(new_platform)
	_player_platforms.push_back(new_platform)
	_break_after_timer(new_platform)


func _break_after_timer(platform):
	await get_tree().create_timer(1.0).timeout
	platform.queue_free()


func _on_desert_char_char_landed(platform):
	if platform.get_id() == _world_platforms[-1].get_id():
		var new_platform = _world_platform_scene.instantiate()
		new_platform.position = _world_platforms[-1].position + _get_random_platform_offset()
		print(_world_platforms[-1].get_id())
		new_platform.set_id(_world_platforms[-1].get_id() + 1)
		add_child(new_platform)
		_world_platforms.push_back(new_platform)
	for p in _world_platforms:
		#print(p.get_id())
		pass

func _get_random_platform_offset():
	#var theta = _rng.randf_range(- 3 * PI / 4, PI / 4)
	var theta = _rng.randf_range(0, - PI / 4)
	var r = _rng.randf_range(200, 300)
	var x = r * cos(theta)
	var y = r * sin(theta)
	return Vector2(x, y)
