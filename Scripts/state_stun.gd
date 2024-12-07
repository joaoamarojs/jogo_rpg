class_name State_Stun extends State

@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null

@onready var idle : State = $"../Idle"
@onready var death: State_Death = $"../Death"


func init() -> void:
	player_boy.player_damaged.connect( _player_damaged )


## What happens when the player enters this State?
func enter() -> void:
	player_boy.animated_sprite.animation_finished.connect( _animation_finished )
	
	direction = player_boy.global_position.direction_to( hurt_box.global_position )
	player_boy.velocity = direction * -knockback_speed
	player_boy.set_direction()
	
	player_boy.update_animation("stun")
	player_boy.make_invulnerable( invulnerable_duration )
	
	PlayerManager.shake_camera( hurt_box.damage / 2)
	pass


## What happens when the player exits this State?
func exit() -> void:
	next_state = null
	player_boy.animated_sprite.animation_finished.disconnect( _animation_finished )
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	player_boy.velocity -= player_boy.velocity * decelerate_speed * _delta
	return next_state


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	return null


func _player_damaged( _hurt_box : HurtBox ) -> void:
	hurt_box = _hurt_box
	if state_machine.current_state != death:
		state_machine.change_state( self )
	pass


func _animation_finished() -> void:
	next_state = idle
	if player_boy.hp <= 0:
		next_state = death
