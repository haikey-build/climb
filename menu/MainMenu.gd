extends Node2D

@onready var level_1 = preload("res://menu/menu_char_select.tscn")
@onready var camera = $CameraMenu


func _ready():
	camera.enabled = true
	camera.make_current()


func _on_button_play_button_down():
	get_tree().change_scene_to_packed(level_1)


func _on_button_quit_button_down():
	get_tree().quit()
