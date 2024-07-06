extends Camera2D

var _tracker
var _offset = Vector2(180, -120)  

func _ready():
	position = Vector2(450, -420)
	#zoom = Vector2(0.3, 0.3)

func _process(delta):
	var target_position = _tracker.position + _offset
	
	position.x = lerp(position.x, target_position.x, 1.0 / 8)
	
	if _tracker.velocity.y == 0:
		position.y = lerp(position.y, target_position.y, 1.0 / 8)
	else:
		position.y = lerp(position.y, target_position.y, 1.0 / 15)


func set_tracker(tracker):
	_tracker = tracker
