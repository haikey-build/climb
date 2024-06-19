extends CharacterBody2D

signal set_platform_attempted(pos, type)
signal recall_platform_attempted()

@onready var FPS = 60
@onready var WALK_SPEED = 200
@onready var _current_selected_platform_type = Climb.PlatformType.STANDARD
@onready var _type_standing_on = Climb.PlatformType.STANDARD


func _cycle_platform_type():
	match _current_selected_platform_type:
		Climb.PlatformType.STANDARD:
			_current_selected_platform_type = Climb.PlatformType.HIGH_JUMP
		Climb.PlatformType.HIGH_JUMP:
			_current_selected_platform_type = Climb.PlatformType.BREAKABLE
		Climb.PlatformType.BREAKABLE:
			_current_selected_platform_type = Climb.PlatformType.STANDARD


func _physics_process(delta):
	if Input.is_action_pressed("left"):
		velocity.x -= delta * FPS * WALK_SPEED
	if Input.is_action_pressed("right"):
		velocity.x += delta * FPS * WALK_SPEED
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= 1500
		if _type_standing_on == Climb.PlatformType.HIGH_JUMP:
			velocity.y -= 800
	if Input.is_action_just_pressed("set_platform"):
		set_platform_attempted.emit(position, _current_selected_platform_type)
	if Input.is_action_just_pressed("recall_platform"):
		recall_platform_attempted.emit()
	if Input.is_action_just_pressed("swap_platform_type"):
		_cycle_platform_type()
	
	velocity.x *= 0.75
	velocity.y += 5000 * delta
	
	velocity.x = clamp(velocity.x, -1000, 1000)
	velocity.y = clamp(velocity.y, -5000, 5000)
	
	move_and_slide()
	
	var collision = get_slide_collision(0)
	if collision != null:
		_type_standing_on = collision.get_collider().get_type()
	else:
		_type_standing_on = Climb.PlatformType.NOTHING


