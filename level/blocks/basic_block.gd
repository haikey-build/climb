extends StaticBody2D

@onready var _type = Climb.PlatformType.STANDARD

func setup(type):
	_type = type
	match _type:
		Climb.PlatformType.HIGH_JUMP:
			modulate = Color(1,1,0)
		Climb.PlatformType.BREAKABLE:
			modulate = Color(0,1,0)


func get_type():
	return _type

