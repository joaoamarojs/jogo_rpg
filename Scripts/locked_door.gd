class_name LockedDoor extends Node2D


var is_open : bool = false

@export var key_item : InventoryItem 

@export var locked_audio : AudioStream
@export var open_audio : AudioStream

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var is_open_data: PersistentDataHelper = $PersistentDataHelper
@onready var interact_area: Area2D = $InteractArea2D
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var interact_sprite: Sprite2D = $Sprite2D2



func _ready() -> void:
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	is_open_data.data_loaded.connect( set_state )
	set_state()



func open_door() -> void:
	if key_item == null:
		return
	var door_unlocked = PlayerManager.INVENTORY_DATA.use_item( key_item )
	
	if door_unlocked:
		get_tree().paused = true
		interact_sprite.visible = false
		animated_sprite.play( "unlock" )
		audio.stream = open_audio
		audio.play()
		await animated_sprite.animation_finished
		collision_shape.disabled = true
		is_open_data.set_value()
	else:
		audio.stream = locked_audio
		collision_shape.disabled = false
		audio.play()
	pass



func close_door() -> void:
	animated_sprite.play( "lock" )



func set_state() -> void:
	is_open = is_open_data.value
	if is_open:
		animated_sprite.play( "opened" )
		collision_shape.disabled = true
	else:
		animated_sprite.play( "closed" )
		collision_shape.disabled = false



func _on_area_enter( _a : Area2D ) -> void:
	if not is_open:
		interact_sprite.visible = true
	PlayerManager.interact_pressed.connect( open_door )


func _on_area_exit( _a : Area2D ) -> void:
	interact_sprite.visible = false
	PlayerManager.interact_pressed.disconnect( open_door )
