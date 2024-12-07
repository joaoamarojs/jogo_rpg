class_name Vase extends Node2D

const BREAK_VASE = preload("res://Resources/Sounds/31_breaking_vase_1.wav")

@onready var audio_player: AudioStreamPlayer = $AudioPlayer
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready():
	$HitBox.damaged.connect( take_damage )
	animated_sprite.play("default")
	
func take_damage( _damage : HurtBox ) -> void:
	collision_shape.call_deferred("set_disabled", true)
	audio_player.stream = BREAK_VASE
	
	audio_player.play()
	animated_sprite.play("destroy")
	await animated_sprite.animation_finished
	queue_free()
