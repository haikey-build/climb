extends Node2D

var rng = RandomNumberGenerator.new()

@onready var slice_scene = preload("res://background/desert_slice.tscn")
@onready var slices = []
@onready var start_color = Color(1, 1, 0.7, 1)
@onready var end_color = Color(.7, .6, 0.4, 1)

func _ready():
	for i in range(8):
		var new_slice = slice_scene.instantiate()
		add_child(new_slice)
		_init_shader(new_slice)
		new_slice.scale.x = 2800
		new_slice.scale.y = 1400
		new_slice.position = Vector2(i * 120, i * 100)
		new_slice.move_to_front()
		
		new_slice.modulate = start_color.lerp(end_color, i/8.0)

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
		
		var random_multiplier = rng.randf_range(0.005, 0.05)
		offset_multipliers.append(random_multiplier)
	
	shader_material.set_shader_parameter("cutoffs", cutoffs)
	shader_material.set_shader_parameter("offset_multipliers", offset_multipliers)
	
	slice.material = shader_material
