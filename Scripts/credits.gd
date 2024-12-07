extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func credits() -> void:
	PlayerBoyHud.show_game_over_screen()
	AudioManager.play_music(null)
	PlayerBoyHud.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

func _on_dialog_interaction_finished() -> void:
	pass # Replace with function body.
