extends Camera2D

var _tracker
var _tracker_vel_history = [0]
var _offset
var _offset_right = Vector2(300, -120)
var _offset_left = Vector2(100, -120)
var _current_direction = 1
var _threshold = 5
var _direction_change_time = 120.0
var _direction_change_counter = 0



func _ready():
	position = Vector2(450, -420)
	#position = Vector2(200, -220)
	#zoom = Vector2(0.3, 0.3)


func _update_offset():
	_tracker_vel_history.push_back(_tracker.position.x)
	
	if _tracker_vel_history.size() > 100:
		_tracker_vel_history.pop_front()
	
	var x_diff = 0
	for val in _tracker_vel_history:
		x_diff += (_tracker.position.x - val) / 80000

	var avg_velocity = (_tracker_vel_history[-1] - _tracker_vel_history[0]) / _tracker_vel_history.size()
	
	if avg_velocity > _threshold:
		_current_direction = 1
		if _direction_change_counter < _direction_change_time:
			_direction_change_counter += 1
	elif avg_velocity < -_threshold:
		_current_direction = -1
		if _direction_change_counter > 0:
			_direction_change_counter -= 1
	
	var amount = s_curve_lerp(_offset_left.x, _offset_right.x, _direction_change_counter / _direction_change_time)

	_offset = Vector2(amount, -120)


func s_curve_lerp(start_value: float, end_value: float, alpha: float) -> float:
	alpha = clamp(alpha, 0.0, 1.0)
	var t = alpha * alpha * (3.0 - 2.0 * alpha)
	return start_value + t * (end_value - start_value)


func _process(delta):
	_update_offset()
	var target_position = _tracker.position + _offset
	
	position.x = lerp(position.x, target_position.x, 1.0 / 6)
	
	if _tracker.velocity.y == 0:
		position.y = lerp(position.y, target_position.y, 1.0 / 20)
	else:
		position.y = lerp(position.y, target_position.y, 1.0 / 100)


func set_tracker(tracker):
	_tracker = tracker
