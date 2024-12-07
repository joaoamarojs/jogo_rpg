class_name NPCStateWander extends NPCState


@export var anim_name : String = "walk"
@export var wander_speed : float = 10.0

@export_category("AI")
@export var state_animation_duration : float = 0.8
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3
@export var next_state : NPCState

var _timer : float = 0.0
var _direction : Vector2

## What happens when we initialize this state?
func init() -> void:
	pass


## What happens when the npc enters this State?
func enter() -> void:
	_timer = randi_range( state_cycles_min, state_cycles_max ) * state_animation_duration
	var rand = randi_range( 0, 2 )
	_direction = npc.DIR_4[ rand ]
	npc.velocity = _direction * wander_speed
	npc.set_direction( _direction )
	npc.update_animation( anim_name )
	pass


## What happens when the npc exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> NPCState:
	_timer -= _delta
	if _timer < 0:
		return next_state
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> NPCState:
	return null
