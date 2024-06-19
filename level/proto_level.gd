extends Node2D

var _platform_scene = preload("res://level/blocks/basic_block.tscn")

@onready var _placed_platforms = []

@onready var _inventory_HUD = {
	Climb.PlatformType.STANDARD: $ProtoChar/StandardNumber,
	Climb.PlatformType.HIGH_JUMP: $ProtoChar/HighJumpNumber,
	Climb.PlatformType.BREAKABLE: $ProtoChar/BreakableNumber
}

@onready var _inventory = {
	Climb.PlatformType.STANDARD: 1,
	Climb.PlatformType.HIGH_JUMP: 0,
	Climb.PlatformType.BREAKABLE: 1,
}

func _ready():
	_update_inventory_HUD_all()

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_proto_char_set_platform_attempted(pos, type):
	if _inventory[type] > 0:
		var new_block
		new_block = _platform_scene.instantiate()
		new_block.position = pos + Vector2(0, 30)
		new_block.scale.x = 5

		add_child(new_block)
		new_block.setup(type)
		if type == Climb.PlatformType.BREAKABLE:
			_break_after_timer(new_block)
		else:
			_placed_platforms.push_back(new_block)
		_inventory[type] -= 1
		_update_inventory_HUD(type)


func _break_after_timer(block):
	await get_tree().create_timer(1.0).timeout
	_inventory[Climb.PlatformType.BREAKABLE] += 1
	block.queue_free()
	_update_inventory_HUD(Climb.PlatformType.BREAKABLE)

func _on_proto_char_recall_platform_attempted():
	if (_placed_platforms.size() > 0):
		var platform_to_delete = _placed_platforms.pop_front()
		var type = platform_to_delete.get_type()
		_inventory[type] += 1
		platform_to_delete.queue_free()
		_update_inventory_HUD(type)


func _on_level_up_body_entered(body):
	var type = Climb.PlatformType.HIGH_JUMP
	_inventory[type] += 1
	_update_inventory_HUD(type)
	$LevelUp.queue_free()


func _update_inventory_HUD_all():
	_update_inventory_HUD(Climb.PlatformType.STANDARD)
	_update_inventory_HUD(Climb.PlatformType.HIGH_JUMP)
	_update_inventory_HUD(Climb.PlatformType.BREAKABLE)

func _update_inventory_HUD(type):
	_inventory_HUD[type].text = str(_inventory[type])
