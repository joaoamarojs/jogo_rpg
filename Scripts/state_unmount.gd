class_name State_Unmount extends State

@export var unmount_audio : AudioStream

@onready var idle = $"../Idle"
@onready var horse : State = $"../Horse"

var mount_area : Mount_Area




## What happens when the player enters this State?
func enter() -> void:
	mount_area = horse.mount_area	
	player_boy.animated_sprite_horse.scale.x = -1 if player_boy.cardinal_direction == Vector2.LEFT else 1
	player_boy.direction_changed.emit(player_boy.cardinal_direction)
	player_boy.update_animation( "unmount_" + horse.mount_area.side)
	player_boy.animated_sprite_horse.animation_finished.connect( state_complete )
	await player_boy.animated_sprite_horse.animation_finished
	player_boy.audio.stream = unmount_audio
	player_boy.audio.play()
	mount_area.unmount(true if horse.mount_area.side == "left" else false)
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
	state_machine.change_state( idle )
	pass
