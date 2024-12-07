@tool
class_name EnemyDropper extends Node2D

@export var enemy : Enemy : set = _set_enemy
var has_dropped : bool = false

@onready var sprite : AnimatedSprite2D = $Sprite2D
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:

	if Engine.is_editor_hint() == true:
		_update_texture()
		return
	
	sprite.visible = false

func drop_enemy() -> void:
	animated_sprite.play("default")
	await animated_sprite.animation_finished
	enemy.global_position = global_position 
	get_parent().add_child(enemy) 
	audio.play()

func _set_enemy(value : Enemy) -> void:
	enemy = value
	_update_texture()

func _update_texture() -> void:
	if Engine.is_editor_hint() == true:
		if enemy and sprite:
			sprite.animation = enemy.animated_sprite.animation
