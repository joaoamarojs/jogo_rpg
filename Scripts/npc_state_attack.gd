class_name NPCStateAttack extends NPCState

@export var anim_name : String = "attack"

@export_category("AI")
@export var attack_area : HurtBox
@export var near_area : Area2D
@export var state_aggro_duration : float = 0.5
@export var next_state : NPCState

var _animation_finished : bool = false

var _timer : float = 0.8
var _player_near : bool = true

## What happens when we initialize this state?
func init() -> void:
	if near_area:
		near_area.body_entered.connect( _on_player_near )
		near_area.body_exited.connect( _on_player_away )
		
	attack_area.monitoring = false
	near_area.monitoring = false
	pass


## What happens when the enemy enters this State?
func enter() -> void:
	_timer = 0.8
	npc.animated_sprite.animation_finished.connect( _on_animation_finished )
	npc.velocity = npc.DIR_4[ 0 ] * 0.0
	_animation_finished = false
	
	npc.update_animation( anim_name )
	pass


## What happens when the enemy exits this State?
func exit() -> void:
	attack_area.monitoring = false
	near_area.monitoring = true
	npc.animated_sprite.animation_finished.disconnect( _on_animation_finished )
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> NPCState:
	_timer -= _delta
	if _timer > 0.6 and _timer < 0.65:
		near_area.monitoring = true
		attack_area.monitoring = true
	
	if _timer < 0.3:
		attack_area.monitoring = false
		
	if _animation_finished == true:
		if _timer < 0:
			if _player_near == false:
				return next_state
			else:
				npc.update_animation( anim_name )
				_timer = 0.8
				
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> NPCState:
	return null


func _on_animation_finished() -> void:
	_animation_finished = true
	
func _on_player_away(_b : Node2D) -> void:
	if _b is PlayerBoy:
		_player_near = false	
	pass	

func _on_player_near(_b : Node2D) -> void:
	if _b is PlayerBoy:
		_player_near = true	
	pass	
