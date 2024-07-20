extends StaticBody2D

var _type = Climb.ObjectType.PLATFORM
var _subtype = Climb.PlatformType.STANDARD

func setup(type):
	_type = type
	match _type:
		Climb.PlatformType.HIGH_JUMP:
			modulate = Color(1,1,0)
		Climb.PlatformType.BREAKABLE:
			modulate = Color(0,1,0)


func get_type():
	return _type

func get_subtype():
	return _subtype

func get_id():
	return -1

