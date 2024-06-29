extends Node2D

var rng = RandomNumberGenerator.new()

@onready var slice_scene = preload("res://background/desert_slice.tscn")
@onready var slices = []
@onready var start_color = Color(1, 1, 0.7, 1)
@onready var end_color = Color(.6, .4, 0.2, 1)

var yVal_queue = []
var queue_size = 5  # Number of recent values to consider
var negative_scale_factor = 0.3  # Scale factor for negative values

func update_slices(yVal):
	# Add new yVal to the queue
	yVal_queue.push_back(yVal)
	
	# Keep only the last 'queue_size' values
	if yVal_queue.size() > queue_size:
		yVal_queue.pop_front()
	
	# Calculate the average of recent yVal values, with weaker negative values
	var avg_yVal = 0.0
	for val in yVal_queue:
		if val > 0:
			avg_yVal += val * negative_scale_factor
		else:
			avg_yVal += val
	avg_yVal /= yVal_queue.size()
	
	# Use the average value for updating slice positions
	for i in range(10):
		var offset = avg_yVal * i * i / 1000
		if offset < 0:
			offset *= negative_scale_factor
		slices[i].position.y = slices[i].home_position.y + offset

func _ready():
	for i in range(10):
		var new_slice = slice_scene.instantiate()
		add_child(new_slice)
		_init_shader(new_slice)
		new_slice.scale.x = 2800
		new_slice.scale.y = 1900
		var pos = i * 120 - 5 * 120
		new_slice.position = Vector2(pos, pos)
		new_slice.home_position = Vector2(pos, pos)
		new_slice.move_to_front()
		
		new_slice.modulate = start_color.lerp(end_color, i/10.0)

		slices.push_back(new_slice)


func _init_shader(slice):
	var shader_material = ShaderMaterial.new()
	shader_material.shader = slice.material.shader
	
	var cutoffs = PackedVector2Array()
	var offset_multipliers = PackedFloat32Array()
	
	for i in range(5):
		var random_x = rng.randf_range(0.05, 0.2)
		var random_y = rng.randf_range(0.05, 0.2)
		cutoffs.append(Vector2(random_x, random_y))
		
		var random_multiplier = rng.randf_range(0.01, 0.06)
		offset_multipliers.append(random_multiplier)
	
	shader_material.set_shader_parameter("cutoffs", cutoffs)
	shader_material.set_shader_parameter("offset_multipliers", offset_multipliers)
	
	slice.material = shader_material
