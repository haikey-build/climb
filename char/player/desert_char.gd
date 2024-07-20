extends CharacterBody2D

signal set_platform_attempted(pos, type)
signal recall_platform_attempted()
signal char_landed(platform)

const JUMP_VELOCITY = -1500

@onready var FPS = 60
@onready var WALK_SPEED = 200
@onready var _current_selected_platform_type = Climb.PlatformType.STANDARD
@onready var _type_standing_on = Climb.PlatformType.STANDARD
@onready var _background = $DesertBackground
@onready var _platform_cooldown_timer = $PlatformCooldownTimer
@onready var _air_jump = 1
@onready var _can_place_platform = true


func _cycle_platform_type():
	match _current_selected_platform_type:
		Climb.PlatformType.STANDARD:
			_current_selected_platform_type = Climb.PlatformType.HIGH_JUMP
		Climb.PlatformType.HIGH_JUMP:
			_current_selected_platform_type = Climb.PlatformType.BREAKABLE
		Climb.PlatformType.BREAKABLE:
			_current_selected_platform_type = Climb.PlatformType.STANDARD

func _physics_process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	if Input.is_action_pressed("left"):
		velocity.x -= delta * FPS * WALK_SPEED
	if Input.is_action_pressed("right"):
		velocity.x += delta * FPS * WALK_SPEED
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif _air_jump > 0:
			velocity.y = JUMP_VELOCITY
			_air_jump = 0
	if Input.is_action_just_pressed("set_platform"):
		_attempt_set_platform()
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
		_update_standing(collision.get_collider())
	else:
		_update_standing(null)
	
	#_background.update_slices($Camera2D.velocity.y)
	if not _can_place_platform:
		_update_platform_cooldown_timer_viz()

func _update_standing(platform):
	if platform == null:
		_type_standing_on = Climb.PlatformType.NOTHING
		return
	
	if _type_standing_on == platform.get_type():
		return
	
	if _type_standing_on == Climb.PlatformType.NOTHING:
		char_landed.emit(platform)
		_type_standing_on = platform.get_type()
		_air_jump = 1

func _attempt_set_platform():
	if _can_place_platform:
		_can_place_platform = false
		set_platform_attempted.emit(position, _current_selected_platform_type)
		_platform_cooldown_timer.start()

func _on_platform_cooldown_timer_timeout():
	_can_place_platform = true
	$BlackMesh.scale.y = 0

func _update_platform_cooldown_timer_viz():
	var proportion = _platform_cooldown_timer.time_left / 3
	$BlackMesh.scale.y = proportion * 16
