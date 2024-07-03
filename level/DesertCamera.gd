extends Camera2D

var _tracker
var _frames_x = 10  
var _offset = Vector2(0, -200)  

func _process(delta):
	var target_position = _tracker.position + _offset
	
	position.x = lerp(position.x, target_position.x, 1.0 / _frames_x)
	
	if _tracker.velocity.y == 0:
		position.y = lerp(position.y, target_position.y, 1.0 / 10)
	else:
		position.y = lerp(position.y, target_position.y, 1.0 / 20)


func set_tracker(tracker):
	_tracker = tracker
