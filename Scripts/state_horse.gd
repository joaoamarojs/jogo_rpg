class_name State_Horse extends State

@export var move_speed : float = 80.0

var walking : bool = false

@onready var idle: State_Idle = $"../Idle"
@onready var stun: State_Stun = $"../Stun"



## What happens when we initialize this state?
func init() -> void:
	pass


## What happens when the player enters this State?
func enter() -> void:
	player_boy.on_horse = true
	player_boy.update_animation( "horse" )
	walking = false
	pass


## What happens when the player exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	if player_boy.direction == Vector2.ZERO:
		walking = false
		player_boy.update_animation( "horse" )
	elif player_boy.set_direction() or walking == false:
		player_boy.update_animation( "horse_walk" )
		walking = true
	
	player_boy.velocity = player_boy.direction * move_speed
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed("sword_attack") or _event.is_action_pressed("interact"):
		return idle
	return null
