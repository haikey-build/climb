
# ------------------------------
# TODO
# most of this code should be in the parent scene: basic melee attack
# parent scene should spawn in one of these then kill it

extends Node2D

var _inner_radius: float = 50.0
var _outer_radius: float = 100.0
var _arc_width: float = PI / 3 
var _num_steps: int = 10 
var _available_to_enact = true

var _global_pos

@onready var _polygon2d = $Polygon2D
@onready var _collision_polygon2d = $Area2D/CollisionPolygon2D
@onready var _cooldown_timer = $CooldownTimer
@onready var _duration_timer = $DurationTimer
@onready var _area2D = $Area2D


func _ready():
	_polygon2d.polygon = _get_arc_points(0)
	_collision_polygon2d.polygon = _get_arc_points(0)
	set_process(false)
	_turn_off()

func enact_ability():
	if !_available_to_enact:
		return false

	_turn_on()
	
	var mouse_position = get_global_mouse_position()
	var look_angle = (mouse_position - global_position).angle()

	_collision_polygon2d.rotation = look_angle
	_polygon2d.rotation = look_angle

	_global_pos = global_position

func _physics_process(delta):
	global_position = _global_pos

func _process(delta):
	global_position = _global_pos

func _turn_on():
	_available_to_enact = false
	set_physics_process(true)
	_area2D.set_monitoring(true)
	_area2D.set_monitorable(true)
	_polygon2d.set_visible(true)

	_duration_timer.start()
	_cooldown_timer.start()
	

func _turn_off():
	position = Vector2(0, 0)
	set_physics_process(false)
	_area2D.set_monitoring(false)
	_area2D.set_monitorable(false)
	_polygon2d.set_visible(false)


func _get_arc_points(look_angle):
	var points = []
	var start_angle = look_angle - _arc_width / 2
	var step_size = _arc_width / _num_steps

	for i in range(_num_steps + 1):
		var angle = start_angle + i * step_size
		var point = Vector2(cos(angle) * _outer_radius, sin(angle) * _outer_radius)
		points.append(point)

	for i in range(_num_steps, -1, -1):
		var angle = start_angle + i * step_size
		var point = Vector2(cos(angle) * _inner_radius, sin(angle) * _inner_radius)
		points.append(point)

	return points


func _on_area_2d_body_entered(body):
	print('-------body entered-------------')
	print(body)


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print('-------body shape entered-------------')
	print(body)

func _on_cooldown_timer_timeout():
	_available_to_enact = true

func _on_duration_timer_timeout():
	_turn_off()
