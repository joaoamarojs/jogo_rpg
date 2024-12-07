class_name EnemyStateAttack extends EnemyState

@export var anim_name : String = "attack"

@export var attack_sound : AudioStream
@export_category("AI")
@export var attack_area : HurtBox
@export var near_area : VisionArea
@export var state_aggro_duration : float = 0.5
@export var next_state : EnemyState
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioPlayer"

var _animation_finished : bool = false

var _timer : float = 1.0
var _player_near : bool = true

## What happens when we initialize this state?
func init() -> void:
	if near_area:
		near_area.player_entered.connect( _on_player_near )
		near_area.player_exited.connect( _on_player_away )
	attack_area.monitoring = false
	near_area.monitoring = false
	pass


## What happens when the enemy enters this State?
func enter() -> void:
	_timer = 1.0
	enemy.animated_sprite.animation_finished.connect( _on_animation_finished )
	enemy.velocity = enemy.DIR_4[ 0 ] * 0.0
	_animation_finished = false
	
	enemy.update_animation( anim_name )
	pass


## What happens when the enemy exits this State?
func exit() -> void:
	attack_area.monitoring = false
	near_area.monitoring = true
	enemy.animated_sprite.animation_finished.disconnect( _on_animation_finished )
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> EnemyState:
	_timer -= _delta
	if _timer > 0.5 and _timer < 0.55:
		near_area.monitoring = true
		attack_area.monitoring = true
		audio.stream = attack_sound
		audio.pitch_scale = randf_range( 0.9, 1.1 )
		audio.play()
	
	if _timer < 0.15:
		attack_area.monitoring = false
		
	if _animation_finished == true:
		if _timer < 0:
			if _player_near == false:
				return next_state
			else:
				enemy.update_animation( anim_name )
				_timer = 1.0
				
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


func _on_animation_finished() -> void:
	_animation_finished = true
	
func _on_player_away() -> void:
	_player_near = false	
	pass	

func _on_player_near() -> void:
	_player_near = true	
	pass	
