extends Node2D

var _direction
var _speed
var _tracking_pos

func setup(direction, speed, tracking_pos):
	_direction = direction
	_speed = speed
	_tracking_pos = tracking_pos

func _physics_process(delta):
	_tracking_pos += delta * _speed * _direction
	global_position = _tracking_pos


func _on_duration_timer_timeout():
	queue_free()


func _on_area_2d_body_shape_entered(body_rid:RID, body:Node2D, body_shape_index:int, local_shape_index:int):
	print('-------------range body shape entered---------------------------')
	print(body)