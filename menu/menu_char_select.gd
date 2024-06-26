extends Node2D

@onready var _explorer_scene = preload()

@onready var _level_scene = preload("res://level/proto_level.tscn")
@onready var _level
@onready var _camera


func _ready():
	_level = _level_scene.instantiate()
	add_child(_level)
	_camera = _level.get_level_camera()
	_camera.enabled = true
	_camera.make_current()



func _on_button_button_down():
	print('buutton 1')


func _on_button_2_button_down():
	print('buutton 2')


func _on_button_3_button_down():
	print('buutton 3')
