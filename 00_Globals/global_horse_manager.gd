extends Node

const HORSE = preload("res://Scenes/npc_horse.tscn")

var horse : Horse
var horse_spawned : bool = false


func _ready() -> void:
	add_horse_instance()
	await get_tree().create_timer(0.2).timeout
	horse_spawned = true


func add_horse_instance() -> void:
	horse = HORSE.instantiate()
	pass
	


func set_horse_position( _new_pos : Vector2 ) -> void:
	horse.global_position = _new_pos
	pass

func set_current_scene( path : String ) -> void:
	SaveManager.current_save.horse.scene_path = path

func set_as_parent( _p : Node2D ) -> void:
	if PlayerManager.player_boy.on_horse == false:
		if LevelManager.get_current_scene_path() == SaveManager.current_save.horse.scene_path:
			if horse.get_parent():
				horse.get_parent().remove_child( horse )
			_p.add_child( horse )
	else:
		set_current_scene(LevelManager.get_current_scene_path())	


func unparent_horse( _p : Node2D ) -> void:
	if PlayerManager.player_boy.on_horse == false and LevelManager.get_current_scene_path() == SaveManager.current_save.horse.scene_path:
		_p.remove_child( horse )


func play_audio( _audio : AudioStream ) -> void:
	horse.audio.stream = _audio
	horse.audio.play()
