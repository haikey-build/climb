extends StaticBody2D

var _id = 0
@onready var _type = Climb.PlatformType.STANDARD


func set_id(id):
	_id = id

func get_id():
	return _id

func get_type():
	return _type
	
