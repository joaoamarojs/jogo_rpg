extends Node2D

const START_LEVEL : String = "res://Scenes/quake_scene.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var button_novo: Button = $CanvasLayer/Control/ButtonNovo
@onready var button_continuar: Button = $CanvasLayer/Control/ButtonContinuar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer




func _ready() -> void:
	
	get_tree().paused = true
	PlayerManager.player_boy.visible = false
	PlayerBoyHud.visible = false
	PlayerBoyHud.process_mode = Node.PROCESS_MODE_INHERIT
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	InventoryUi.process_mode = Node.PROCESS_MODE_DISABLED
	
	if SaveManager.get_save_file() == null:
		button_continuar.disabled = true
		button_continuar.visible = false
	
	#$CanvasLayer/SplashScene.finished.connect( setup_title_screen )
	setup_title_screen()
	
	LevelManager.level_load_started.connect( exit_title_screen )
	pass



func setup_title_screen() -> void:
	AudioManager.play_music( music )
	button_novo.pressed.connect( start_game )
	button_continuar.pressed.connect( load_game )
	button_novo.grab_focus()
	
	button_novo.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	button_continuar.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	
	pass



func start_game() -> void:
	play_audio( button_press_audio )
	LevelManager.load_new_level( START_LEVEL, "", Vector2.ZERO )
	pass



func load_game() -> void:
	play_audio( button_press_audio )
	SaveManager.load_game()
	pass



func exit_title_screen() -> void:
	PlayerManager.player_boy.visible = true
	PlayerBoyHud.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	InventoryUi.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()
	pass



func play_audio( _a : AudioStream ) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
	pass
