class_name NPCStateIdleAttack extends NPCState


@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : NPCState
@export var near_area : Area2D
@onready var attack: NPCState = $"../Attack"

var _timer : float = 0.0
var _player_near : bool = false

## What happens when we initialize this state?
func init() -> void:
	if near_area:
		near_area.body_entered.connect( _on_player_near )
		near_area.body_exited.connect( _on_player_away )
		near_area.monitoring = true
	pass


## What happens when the enemy enters this State?
func enter() -> void:
	near_area.monitoring = true
	npc.velocity = Vector2.ZERO
	_timer = randf_range( state_duration_min, state_duration_max )
	npc.update_animation( anim_name )
	pass


## What happens when the enemy exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> NPCState:
	_timer -= _delta
	if _player_near == true:
		return attack
		
	if _timer <= 0:
		return after_idle_state
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> NPCState:
	return null
	
func _on_player_away(_b : Node2D) -> void:
	print(_b)
	if _b is PlayerBoy:
		_player_near = false	
	pass	

func _on_player_near(_b : Node2D) -> void:
	print(_b)
	if _b is PlayerBoy:
		_player_near = true	
	pass	
