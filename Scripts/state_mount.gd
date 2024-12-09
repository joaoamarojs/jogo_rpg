class_name State_Mount extends State

@export var mount_audio : AudioStream

@onready var horse : State = $"../Horse"





## What happens when the player enters this State?
func enter() -> void:		
	player_boy.cardinal_direction = horse.mount_area.horse.cardinal_direction
	player_boy.animated_sprite_horse.scale.x = -1 if player_boy.cardinal_direction == Vector2.LEFT else 1
	player_boy.direction_changed.emit(player_boy.cardinal_direction)
	player_boy.on_horse = true
	player_boy.update_animation( "mount_" + horse.mount_area.side)
	player_boy.animated_sprite_horse.animation_finished.connect( state_complete )
	await player_boy.animated_sprite_horse.animation_finished
	player_boy.audio.stream = mount_audio
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
	player_boy.animated_sprite_horse.animation_finished.disconnect( state_complete )
	state_machine.change_state( horse )
	pass
