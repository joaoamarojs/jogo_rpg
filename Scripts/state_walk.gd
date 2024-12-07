class_name State_Walk extends State

@export var move_speed : float = 50.0

@onready var idle : State = $"../Idle"
@onready var sword_attack : State = $"../Sword_Attack"
@onready var cpu_particles_2d: CPUParticles2D = $"../../CPUParticles2D"


func enter() -> void:
	cpu_particles_2d.emitting = true
	player_boy.update_animation("walk")
	pass


func exit() -> void:
	cpu_particles_2d.emitting = false
	pass


func process( _delta : float ) -> State:
	if player_boy.direction == Vector2.ZERO:
		return idle
	
	player_boy.velocity = player_boy.direction * move_speed
	
	if player_boy.set_direction():
		player_boy.update_animation("walk")
	return null


func physics( _delta : float ) -> State:
	return null


func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed("sword_attack"):
		if player_boy.has_sword == true:
			return sword_attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact()
	return null
