class_name Mount_Area extends Area2D

var mount : bool = false
var horse : Horse

func _ready() -> void:
	horse = get_parent().get_parent()
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	set_physics_process( false )



func _physics_process( delta: float ) -> void:
	pass

func unmount() -> void:
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	PlayerManager.player_boy.get_parent().call_deferred( "add_child", horse )
	horse.position = PlayerManager.player_boy.position
	PlayerManager.interact_handled = false
	set_physics_process( true )

func player_interact() -> void:
	if PlayerManager.interact_handled == true:
		return
	if mount == false:
		PlayerManager.player_boy.position = horse.position
		PlayerManager.player_boy.direction = horse.direction
		if horse.get_parent().get_parent():
			horse.get_parent().remove_child( horse )
		PlayerManager.interact_handled = true
		PlayerManager.player_boy.mount_horse( self )
		area_entered.disconnect( _on_area_enter )
		area_exited.disconnect( _on_area_exit )
		pass
	pass


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass
