class_name Teleporter extends Node2D

const EFFECT_SOUND = preload("res://Resources/Sounds/04_Fire_explosion_04_medium.wav")
const SWORD_HIT = preload("res://Resources/Sounds/26_sword_hit_3.wav")
const TELEPORT = preload("res://Resources/Sounds/88_Teleport_02.wav")
@onready var animated_sprite_effect: AnimatedSprite2D = $AnimatedSpriteEffect
@onready var animated_sprite_base: AnimatedSprite2D = $AnimatedSpriteBase
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export_file( "*.tscn" ) var level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HitBox.damaged.connect( take_damage )

func take_damage( _damage : HurtBox ) -> void:
	AudioManager.stop_music()
	audio_player.stream = SWORD_HIT
	audio_player.play()
	$DialogInteraction.visible = false
	animated_sprite_base.play("iluminating")
	PlayerManager.shake_camera(2)
	await animated_sprite_base.animation_finished
	get_tree().paused = true
	audio_player.stream = EFFECT_SOUND
	audio_player.play()
	animated_sprite_base.play("iluminated")
	animated_sprite_effect.play("default")
	await animated_sprite_effect.animation_finished
	audio_player.stream = TELEPORT
	audio_player.play()
	PlayerManager.shake_camera(1)
	await SceneTransition.fade_in_white()
	LevelManager.load_new_level( level,  "TeleporterDestination", Vector2.ZERO )
