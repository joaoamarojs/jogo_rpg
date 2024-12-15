class_name Mount_Area extends Area2D

var mount : bool = false
var horse : Horse
var side : String

func _ready() -> void:
	horse = get_parent().get_parent()
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	pass

func unmount(side) -> void:
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
	horse.position = PlayerManager.player_boy.position
	horse.cardinal_direction = PlayerManager.player_boy.cardinal_direction
	horse.animated_sprite.scale.x = -1 if horse.cardinal_direction == Vector2.LEFT else 1
	horse.direction_changed.emit(horse.cardinal_direction)
	horse.change_to_idle()
	PlayerManager.player_boy.get_parent().call_deferred("add_child", horse)
	PlayerManager.interact_handled = false
	PlayerManager.player_boy.on_horse = false
	var pos = horse.left.position if side else horse.right.position
	if horse.cardinal_direction == Vector2.LEFT or horse.cardinal_direction == Vector2.RIGHT:
		pos.x = pos.x - 4 if pos.x > 4 else pos.x + 8	
		PlayerManager.player_boy.position.y += pos.x
	else:
		PlayerManager.player_boy.position.x += pos.x
	HorseManager.horse = horse	
	set_physics_process(true)

func throw_player() -> void:
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
	horse.position = PlayerManager.player_boy.position
	horse.cardinal_direction = PlayerManager.player_boy.cardinal_direction
	horse.animated_sprite.scale.x = -1 if horse.cardinal_direction == Vector2.LEFT else 1
	horse.direction_changed.emit(horse.cardinal_direction)
	horse.update_animation("attack")
	await horse.animated_sprite.animation_finished
	horse.change_to_idle()
	HorseManager.horse = horse	

func player_interact() -> void:
	if PlayerManager.interact_handled == true:
		return

	# Determina se o jogador está à direita ou à esquerda do Mount_Area
	var player_position = PlayerManager.player_boy.position
	var self_position = global_position
	side = "right" if player_position.x > self_position.x else "left"
	if horse.cardinal_direction == Vector2.LEFT or horse.cardinal_direction == Vector2.RIGHT:
		side = "right" if player_position.y > self_position.y else "left"
	if mount == false:
		PlayerManager.player_boy.position = horse.position
		PlayerManager.player_boy.direction = horse.direction
		PlayerManager.player_boy.set_direction()
		horse.change_to_mount()
		if horse.get_parent().get_parent():
			horse.get_parent().remove_child(horse)
		PlayerManager.interact_handled = true
		PlayerManager.player_boy.mount_horse(self)
		area_entered.disconnect(_on_area_enter)
		area_exited.disconnect(_on_area_exit)
	pass

func _on_area_enter(_a: Area2D) -> void:
	PlayerManager.interact_pressed.connect(player_interact)
	pass

func _on_area_exit(_a: Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(player_interact)
	pass
