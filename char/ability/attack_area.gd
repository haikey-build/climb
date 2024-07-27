extends Node2D

# Parameters
var _inner_radius: float = 50.0
var _outer_radius: float = 100.0
var _arc_width: float = PI / 3 
var _num_steps: int = 10 

# References to the nodes
@onready var polygon2d = $Polygon2D
@onready var collision_polygon2d = $Area2D/CollisionPolygon2D


func _ready():
	polygon2d.polygon = _get_arc_points(0)
	collision_polygon2d.polygon = _get_arc_points(0)


func _process(delta):
	var mouse_position = get_global_mouse_position()
	var look_angle = (mouse_position - global_position).angle()

	collision_polygon2d.rotation = look_angle
	polygon2d.rotation = look_angle


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
	print('-------entered-------------')
	print(body)


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print('-------entered-------------')
	print(body)
