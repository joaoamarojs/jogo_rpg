@tool
class_name TeleporterDestination extends Area2D

@export var target_transition_area : String = "TeleporterDestination"
@export var center_player : bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D



func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_place_player()
	
	await LevelManager.level_loaded
	
	pass



func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	var pos = global_position
	pos.y = pos.y + 16
	PlayerManager.set_player_position( pos + LevelManager.position_offset )


func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player_boy.global_position

	return offset
