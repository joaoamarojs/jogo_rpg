class_name Level extends Node2D

@export var music : AudioStream


func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent( self )
	HorseManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level )
	AudioManager.play_music( music )



func _free_level() -> void:
	PlayerManager.unparent_player( self )
	HorseManager.unparent_horse( self )
	queue_free()
