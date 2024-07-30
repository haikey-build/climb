extends Node2D

var _inner_radius: float = 50.0
var _outer_radius: float = 100.0
var _arc_width: float = PI / 3 
var _num_steps: int = 10 
var _available_to_enact = true

var _tracking_pos
var _look_angle

@onready var _polygon2d = $Polygon2D
@onready var _collision_polygon2d = $Area2D/CollisionPolygon2D
@onready var _cooldown_timer = $CooldownTimer
@onready var _duration_timer = $DurationTimer
@onready var _area2D = $Area2D


func setup(position, look_angle):
	_tracking_pos = position
	_look_angle = look_angle

	_polygon2d.polygon = _get_arc_points(look_angle)
	_collision_polygon2d.polygon = _get_arc_points(look_angle)



func _physics_process(delta):
	global_position = _tracking_pos


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


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print('-------body shape entered-------------')
	print(body)


func _on_duration_timer_timeout():
	queue_free()
