class_name CastleDoor extends Node2D


var is_open : bool = false
var is_moving : bool = false

@export var close_audio : AudioStream
@export var open_audio : AudioStream

@onready var animated_sprite: AnimatedSprite2D =$AnimatedDoor
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var was_open_data: PersistentDataHelper = $PersistentDataHelper
@onready var interact_area: Area2D = $InteractArea2D
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D



func _ready() -> void:
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	was_open_data.data_loaded.connect( set_state )
	set_state()



func open_door() -> void:
	if is_moving:
		return
	if is_open:
		animated_sprite.play( "closing" )
		audio.stream = open_audio
		is_open = false
		audio.play()
		is_moving = true
		await animated_sprite.animation_finished
		is_moving = false
		collision_shape.disabled = false
	else:
		animated_sprite.play( "opening" )
		audio.stream = close_audio
		is_open = true
		audio.play()
		is_moving = true
		await animated_sprite.animation_finished
		is_moving = false
		if not was_open_data.value: 
			was_open_data.set_value()
		collision_shape.disabled = true


func set_state() -> void:
	is_open = was_open_data.value
	if is_open:
		is_open = false
		animated_sprite.play( "closing" )
		collision_shape.disabled = false
	else:
		animated_sprite.play( "closed" )
		collision_shape.disabled = false



func _on_area_enter( _a : Area2D ) -> void:
	sprite_2d.visible = true
	PlayerManager.interact_pressed.connect( open_door )


func _on_area_exit( _a : Area2D ) -> void:
	sprite_2d.visible = false
	PlayerManager.interact_pressed.disconnect( open_door )
