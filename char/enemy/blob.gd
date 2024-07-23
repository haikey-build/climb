extends CharacterBody2D

var speed = 100.0

var points = []

var current_point_index = 0

func get_type():
	return Climb.ObjectType.BEING

func get_subtype():
	return Climb.BeingType.BLOB

func _ready():
	points = [
        $"../Blob1Points/Point1",
        $"../Blob1Points/Point2",
        $"../Blob1Points/Point3",
        $"../Blob1Points/Point4"
    ]

func _physics_process(delta):
	move_towards_target(delta)

func move_towards_target(delta):
	if points.size() == 0:
		return

	var target = points[current_point_index].global_position
	var direction = (target - global_position).normalized()
	var distance_to_target = global_position.distance_to(target)

	print(distance_to_target)
	
	if distance_to_target < (speed * delta) * 10:
		current_point_index = (current_point_index + 1) % points.size()
	else:
		global_position += direction * speed * delta
