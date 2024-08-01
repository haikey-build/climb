extends StaticBody2D

var _type = Climb.ObjectType.PLATFORM
var _subtype = Climb.PlatformType.STANDARD

func setup(pos):
	position = pos
	position.y += 30

func get_type():
	return _type

func get_subtype():
	return _subtype

func get_id():
	return -1


func _on_timer_timeout():
	queue_free()
