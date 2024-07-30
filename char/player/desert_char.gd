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
@onready var _primary_ability = $BasicMeleeAttackArea
@onready var _secondary_ability = $BasicRangeAttack


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
		_handle_jump()
	if Input.is_action_just_pressed("set_platform"):
		_attempt_set_platform()
	if Input.is_action_just_pressed("recall_platform"):
		recall_platform_attempted.emit()
	if Input.is_action_just_pressed("swap_platform_type"):
		_cycle_platform_type()
	if Input.is_action_just_pressed("primary_ability"):
		_primary_ability.enact_ability()
	if Input.is_action_just_pressed("secondary_ability"):
		_secondary_ability.enact_ability()
	
	velocity.x *= 0.75
	velocity.y += 5000 * delta
	
	velocity.x = clamp(velocity.x, -1000, 1000)
	velocity.y = clamp(velocity.y, -5000, 5000)
	
	move_and_slide()
	
	var collision = get_slide_collision(0)
	if collision != null:
		var collider = collision.get_collider()
		match(collider.get_type()):
			Climb.ObjectType.PLATFORM:
				_update_standing(collider)
			Climb.ObjectType.BEING:
				print('------hit being--------')
	else:
		_update_standing(null)
	
	#_background.update_slices($Camera2D.velocity.y)
	if not _can_place_platform:
		_update_platform_cooldown_timer_viz()

func _update_standing(platform):
	if platform == null:
		_type_standing_on = Climb.PlatformType.NOTHING
		return
	
	if _type_standing_on == platform.get_subtype():
		return
	
	if _type_standing_on == Climb.PlatformType.NOTHING:
		char_landed.emit(platform)
		_type_standing_on = platform.get_subtype()
		_air_jump = 1

func _attempt_set_platform():
	if _can_place_platform:
		_can_place_platform = false
		set_platform_attempted.emit(position, _current_selected_platform_type)
		_platform_cooldown_timer.start()

func _handle_jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif _air_jump > 0:
		velocity.y = JUMP_VELOCITY
		_air_jump = 0

func _on_platform_cooldown_timer_timeout():
	_can_place_platform = true
	$BlackMesh.scale.y = 0

func _update_platform_cooldown_timer_viz():
	var proportion = _platform_cooldown_timer.time_left / 3
	$BlackMesh.scale.y = proportion * 16

