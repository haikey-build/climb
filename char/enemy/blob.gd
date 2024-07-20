extends CharacterBody2D

# Speed at which the object moves
var speed = 100.0

# Array to hold references to point nodes
var points = []

# Index of the current target point
var current_point_index = 0

# Function to get the object type
func get_type():
	return Climb.ObjectType.BEING

# Function to get the object subtype
func get_subtype():
	return Climb.BeingType.BLOB

# Called when the node enters the scene tree
func _ready():
	# Reference the point nodes
	points = [
		$"Points/Point1",
		$"Points/Point2",
		$"Points/Point3",
		$"Points/Point4"
	]

# Called every frame
func _process(delta):
	move_towards_target(delta)

# Function to move the object towards the current target point
func move_towards_target(delta):
	if points.size() == 0:
		return

	var target = points[current_point_index].global_position
	var direction = (target - global_position).normalized()
	var distance_to_target = global_position.distance_to(target)
	
	if distance_to_target < speed * delta:
		global_position = target
		current_point_index = (current_point_index + 1) % points.size()
	else:
		global_position += direction * speed * delta
