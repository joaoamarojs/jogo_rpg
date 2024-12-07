class_name EnemyStateChase extends EnemyState


@export var anim_name : String = "chase"
@export var chase_speed : float = 40.0
@export var turn_rate : float = 0.5

@export_category("AI")
@export var vision_area : VisionArea
@export var near_area : Area2D
@export var state_aggro_duration : float = 0.5
@export var next_state : EnemyState
@onready var attack: EnemyState = $"../Attack"

var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false
var _player_near : bool = false



## What happens when we initialize this state?
func init() -> void:
	if near_area:
		near_area.player_entered.connect( _on_player_near )
		near_area.player_exited.connect( _on_player_away )
		
	if vision_area:
		vision_area.player_entered.connect( _on_player_enter )
		vision_area.player_exited.connect( _on_player_exit )
	pass


## What happens when the enemy enters this State?
func enter() -> void:

	_timer = state_aggro_duration
	enemy.update_animation( anim_name )
	_player_near = false
	_can_see_player = true
	near_area.monitoring = true
	pass


## What happens when the enemy exits this State?
func exit() -> void:
	_can_see_player = false
	_player_near = false
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> EnemyState:
	if PlayerManager.player_boy.hp <= 0:
		return next_state
	
	var new_dir : Vector2 = enemy.global_position.direction_to( PlayerManager.player_boy.global_position )
	_direction = lerp( _direction, new_dir, turn_rate )
	enemy.velocity = _direction * chase_speed
	if enemy.set_direction( _direction ):
		enemy.update_animation( anim_name )
		
	if _player_near == true:
		return attack
	
	if _can_see_player == false:
		_player_near = false
		_timer -= _delta
		if _timer < 0:
			return next_state
	else:
		_timer = state_aggro_duration
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> EnemyState:
	return null


func _on_player_enter() -> void:
	_player_near = false
	_can_see_player = true
	if(
			state_machine.current_state is EnemyStateStun
			or state_machine.current_state is EnemyStateDestroy
	):
		return
	state_machine.change_state( self )
	pass


func _on_player_exit() -> void:
	_can_see_player = false
	_player_near = false
	pass
	
func _on_player_away() -> void:
	_player_near = false	
	pass	

func _on_player_near() -> void:
	_player_near = true	
	pass
