class_name State_Lift extends State

@export var lift_audio : AudioStream

@onready var carry : State = $"../Carry"





## What happens when the player enters this State?
func enter() -> void:
	
	player_boy.update_animation( "lift" )
	player_boy.animated_sprite.animation_finished.connect( state_complete )
	await player_boy.animated_sprite.animation_finished
	player_boy.held_item.visible = true
	player_boy.audio.stream = lift_audio
	player_boy.audio.play()
	pass


## What happens when the player exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	player_boy.velocity = Vector2.ZERO
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	return null



func state_complete() -> void:
	player_boy.animated_sprite.animation_finished.disconnect( state_complete )
	state_machine.change_state( carry )
	pass
