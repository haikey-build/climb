extends Node2D

# Parameters
var radius: float = 100.0
var width: float = PI / 3 # Width of the section in radians
var steps: int = 10 # Number of intermediate points

# References to the nodes
@onready var polygon2d = $Polygon2D
@onready var collision_polygon2d = $Area2D/CollisionPolygon2D

func _ready():
	set_process(true)

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var look_angle = (mouse_position - global_position).angle()
	
	draw_hitbox(look_angle)
	setup_collision(look_angle)

func draw_hitbox(look_angle):
	var points = []
	
	# Center point at (0, 0)
	points.append(Vector2.ZERO)
	
	# Calculate the two outer points of the hitbox
	var start_angle = look_angle - width / 2
	var end_angle = look_angle + width / 2
	
	var start_point = Vector2(cos(start_angle) * radius, sin(start_angle) * radius)
	var end_point = Vector2(cos(end_angle) * radius, sin(end_angle) * radius)
	
	points.append(start_point)
	
	# Intermediate points for better shape
	var step = width / steps
	for i in range(1, steps):
		var angle = start_angle + i * step
		var point = Vector2(cos(angle) * radius, sin(angle) * radius)
		points.append(point)
		
	points.append(end_point)
	
	# Assign points to the Polygon2D
	polygon2d.polygon = points

func setup_collision(look_angle):
	var points = []
	
	# Center point at (0, 0)
	points.append(Vector2.ZERO)
	
	# Calculate the two outer points of the hitbox
	var start_angle = look_angle - width / 2
	var end_angle = look_angle + width / 2
	
	var start_point = Vector2(cos(start_angle) * radius, sin(start_angle) * radius)
	var end_point = Vector2(cos(end_angle) * radius, sin(end_angle) * radius)
	
	points.append(start_point)
	
	# Intermediate points for better shape
	var step = width / steps
	for i in range(1, steps):
		var angle = start_angle + i * step
		var point = Vector2(cos(angle) * radius, sin(angle) * radius)
		points.append(point)
		
	points.append(end_point)
	
	# Assign points to the CollisionPolygon2D
	collision_polygon2d.polygon = points
