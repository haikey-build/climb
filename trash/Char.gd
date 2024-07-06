extends MeshInstance2D



func _physics_process(delta):
	if Input.is_action_pressed("right"):
		position.x += 0.3
	if Input.is_action_pressed("jump"):
		position.y -= 0.3
