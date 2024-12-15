class_name State_Thrown extends State

@export var gravity_strength : float = 980
@export var throw_speed : float = 120.0
@export var throw_height_strength : float = 150.0
@export var throw_starting_height : float = 9.0
@export var animated_sprite : AnimatedSprite2D

@onready var idle : State = $"../Idle"
@onready var death = $"../Death"

var throw_direction : Vector2
var vertical_velocity : float = 0
var ground_height : float = 0

func init() -> void:
	set_physics_process( false )

## What happens when the player enters this State?
func enter() -> void:
	animated_sprite = player_boy.animated_sprite
	ground_height = animated_sprite.position.y
	player_boy.on_horse = false
	var mount_area = player_boy.horse.mount_area
	mount_area.throw_player()
	player_boy.update_animation( "stun" )
	player_boy.get_parent().call_deferred("add_child", mount_area.horse)
	animated_sprite.position.y = -throw_starting_height
	player_boy.velocity.y = -throw_height_strength
	throw_direction = player_boy.cardinal_direction
	set_physics_process( true )
	pass


## What happens when the player exits this State?
func exit() -> void:
	set_physics_process( false )
	var horse = player_boy.horse.mount_area.horse
	horse.change_to_idle()
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	player_boy.velocity.y += gravity_strength * _delta
	animated_sprite.position.y += player_boy.velocity.y * _delta
	if animated_sprite.position.y >= ground_height:
		var hp = player_boy.hp
		player_boy.update_hp(-1)
		
		if player_boy.hp <= 0:
			return death
			
		return idle
	vertical_velocity += gravity_strength * _delta
	player_boy.position += throw_direction * throw_speed * _delta
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	return null
