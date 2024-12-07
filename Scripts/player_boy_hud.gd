extends CanvasLayer

@export var button_focus_audio : AudioStream = preload( "res://Resources/Sounds/001_hover_01.wav" )
@export var button_select_audio : AudioStream = preload( "res://Resources/Sounds/013_Confirm_03.wav")

var hearts : Array[ HeartGUI ] = []


@onready var game_over : Control = $Control/GameOver
@onready var continue_button: Button = $Control/GameOver/VBoxContainer/ContinueButton
@onready var title_button: Button = $Control/GameOver/VBoxContainer/TitleButton
@onready var animation_player: AnimationPlayer = $Control/GameOver/AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer




func _ready():
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false
	
	hide_game_over_screen()
	continue_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	continue_button.pressed.connect( load_game )
	title_button.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	title_button.pressed.connect( title_screen )
	LevelManager.level_load_started.connect( hide_game_over_screen )
	pass



func update_hp( _hp: int, _max_hp: int ) -> void:
	update_max_hp( _max_hp )
	var hearts = _max_hp / 4
	for i in hearts:
		update_heart( i, _hp )
		pass
	pass



func update_heart( _index : int, _hp : int ) -> void:
	var _value : int = clampi( _hp - _index * 4, 0, 4 )
	hearts[ _index ].value = _value
	pass



func update_max_hp( _max_hp : int ) -> void:
	var _heart_count : int = roundi( _max_hp * 0.25 )
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass



func show_game_over_screen() -> void:
	game_over.visible = true
	game_over.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var can_continue : bool = SaveManager.get_save_file() != null
	continue_button.visible = can_continue
	
	animation_player.play("show_game_over")
	await animation_player.animation_finished
	
	if can_continue == true:
		continue_button.grab_focus()
	else:
		title_button.grab_focus()
	pass	
	



func hide_game_over_screen() -> void:
	game_over.visible = false
	game_over.mouse_filter = Control.MOUSE_FILTER_IGNORE
	game_over.modulate = Color( 1,1,1,0 )
	pass



func load_game() -> void:
	play_audio( button_select_audio )
	await fade_to_black()
	SaveManager.load_game()
	pass


func title_screen() -> void:
	play_audio( button_select_audio )
	await fade_to_black()
	LevelManager.load_new_level( "res://Scenes/main_menu.tscn", "", Vector2.ZERO )
	pass


func fade_to_black() -> bool:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	PlayerManager.player_boy.revive_player()
	return true



func play_audio( _a : AudioStream ) -> void:
	audio.stream = _a
	audio.play()
	pass
