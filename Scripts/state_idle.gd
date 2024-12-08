class_name State_Idle extends State

@onready var walk : State = $"../Walk"
@onready var sword_attack : State  = $"../Sword_Attack"
@onready var horse = $"../Horse"

const INACTIVE_TIME_THRESHOLD = 15.0
var inactive_time = 0.0
var isSleeping = false
@onready var cpu_particles_2d: CPUParticles2D = $"../../CPUParticles2D"

## What happens when the player enters this State?
func enter() -> void:
	player_boy.on_horse = false
	cpu_particles_2d.emitting = false
	inactive_time = 0.0
	isSleeping = false
	player_boy.animated_sprite.speed_scale = 1
	player_boy.update_animation("idle")
	pass


## What happens when the player exits this State?
func exit() -> void:
	inactive_time = 0.0
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	if player_boy.direction != Vector2.ZERO:
		return walk
	player_boy.velocity = Vector2.ZERO
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	inactive_time += _delta
	if inactive_time >= INACTIVE_TIME_THRESHOLD and !isSleeping:
		isSleeping = true
		player_boy.play_sleep()
		
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed("sword_attack"):
		if player_boy.has_sword == true:
			return sword_attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact()
	if _event.is_action_pressed("horse"):
		return horse
	return null
