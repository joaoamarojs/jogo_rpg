@tool
class_name ChestDropper extends Node2D

const CHEST = preload("res://Scenes/chest.tscn")

@export var item : InventoryItem : set = _set_item_data

var has_dropped : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var has_dropped_data: PersistentDataHelper = $PersistentDataHelper
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D



func _ready() -> void:
	if Engine.is_editor_hint() == true:
		_update_texture()
		return
	
	sprite.visible = false
	has_dropped_data.data_loaded.connect( _on_data_loaded )
	_on_data_loaded()


func drop_chest() -> void:
	if has_dropped == true:
		return
	has_dropped = true
	
	animated_sprite.play("default")
	audio.play()
	await animated_sprite.animation_finished
	var chest = CHEST.instantiate() as Chest
	chest.inventory_item = item
	add_child( chest )
	chest.opened.connect( _on_drop_pickup )



func _on_drop_pickup() -> void:
	has_dropped_data.set_value()

func _on_data_loaded() -> void:
	has_dropped = has_dropped_data.value
	if has_dropped == true:
		var chest = CHEST.instantiate() as Chest
		chest.inventory_item = item
		add_child( chest )



func _set_item_data( value : InventoryItem ) -> void:
	item = value
	_update_texture()


func _update_texture() -> void:
	if Engine.is_editor_hint() == true:
		if item and sprite:
			sprite.texture = item.side_texture
