class_name NPCStateMount extends NPCState

@export var anim_name : String = "idle"

@export_category("AI")
@export var state_aggro_duration : float = 0.5
@export var next_state : NPCState

var _timer : float = 0.8

## What happens when we initialize this state?
func init() -> void:
	pass


## What happens when the enemy enters this State?
func enter() -> void:
	npc.velocity = Vector2.ZERO
	npc.update_animation( anim_name )
	pass


## What happens when the enemy exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> NPCState:
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> NPCState:
	return null
