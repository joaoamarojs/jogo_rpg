extends Node2D

func _ready() -> void:
	visible = false
	if HorseManager.horse_spawned == false:
		HorseManager.set_horse_position( global_position )
		HorseManager.set_current_scene( LevelManager.get_current_scene_path() )
		HorseManager.horse_spawned = true
