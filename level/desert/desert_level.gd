extends Node2D

@onready var _placed_platform_scene = preload("res://level/blocks/standard_placed_plat.tscn")
@onready var _world_platform_scene = preload("res://background/platforms/floating_platform.tscn")
@onready var _player_platforms = []
@onready var _world_platforms = [$FloatingPlatform]
@onready var _rng = RandomNumberGenerator.new()

@export var _theta_1 = 0#- 3 * PI / 4
@export var _theta_2 = -0.5#PI / 4
@export var _r_1 = 350
@export var _r_2 = 400

func _ready():
	$DesertCamera.set_tracker($DesertChar)

func _process(delta):
	if _world_platforms[-1]:
		_world_platforms[-1].resize_zone(_theta_1, _theta_2, _r_1, _r_2)

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
		_world_platforms[-1].remove_polygon()
		var new_platform = _world_platform_scene.instantiate()
		new_platform.position = _get_random_platform_position()
		new_platform.set_id(_world_platforms[-1].get_id() + 1)
		add_child(new_platform)
		new_platform.display_zone(_theta_1, _theta_2, _r_1, _r_2)
		_world_platforms.push_back(new_platform)
		_slow_rotate()
		#_randomise_params()

func _slow_rotate():
	_theta_1 -= 0.01
	_theta_2 -= 0.01


func _randomise_params():
	_theta_1 = _rng.randf_range(- 3 * PI / 4 + 0.5, - 3 * PI / 4 + 2)
	_theta_2 = _theta_1 + _rng.randf_range(0, 1)
	_r_1 = _rng.randf_range(250, 400)
	_r_2 = _r_1 + _rng.randf_range(20, 200)

func _get_random_platform_dummy():
	var x = _rng.randf_range(-900, 960)
	var y =  _rng.randf_range(-340, 640)
	print(x, ' ', y)
	return Vector2(x, y)

func _get_random_platform_position():
	var theta = _rng.randf_range(_theta_1, _theta_2)
	var r = _rng.randf_range(_r_1, _r_2)
	var x = r * cos(theta)
	var y = r * sin(theta)
	return _world_platforms[-1].position +  Vector2(x, y)
