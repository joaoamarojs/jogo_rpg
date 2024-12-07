extends Node

const PLAYER = preload("res://Scenes/Player_boy.tscn")
const INVENTORY_DATA : InventoryData = preload("res://Resources/player_inventory.tres")

signal camera_shook( trauma : float )
signal interact_pressed

var interact_handled : bool = true
var player_boy : PlayerBoy
var player_spawned : bool = false


func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true



func add_player_instance() -> void:
	player_boy = PLAYER.instantiate()
	add_child( player_boy )
	pass



func set_health( hp: int, max_hp: int ) -> void:
	player_boy.max_hp = max_hp
	player_boy.hp = hp
	player_boy.update_hp( 0 )



func set_player_position( _new_pos : Vector2 ) -> void:
	player_boy.global_position = _new_pos
	pass



func set_as_parent( _p : Node2D ) -> void:
	if player_boy.get_parent():
		player_boy.get_parent().remove_child( player_boy )
	_p.add_child( player_boy )



func unparent_player( _p : Node2D ) -> void:
	_p.remove_child( player_boy )



func play_audio( _audio : AudioStream ) -> void:
	player_boy.audio.stream = _audio
	player_boy.audio.play()



func interact() -> void:
	interact_handled = false
	interact_pressed.emit()



func update_sword(action: bool, damage: int) -> void:
	player_boy.has_sword = action
	player_boy.player_hurt_box.damage = damage


func shake_camera( trauma : float = 1 ) -> void:
	camera_shook.emit( trauma )
