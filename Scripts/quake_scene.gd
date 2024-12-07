class_name QuakeScene extends Node2D

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var dialog_interaction: DialogInteraction = $DialogInteraction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	InventoryUi.process_mode = Node.PROCESS_MODE_DISABLED
	AudioManager.stop_music()
	PlayerBoyHud.visible = false
	audio.play()
	PlayerManager.shake_camera(5)
	await audio.finished
	dialog_interaction.player_interact()
	await dialog_interaction.finished
	get_tree().paused = false
	PlayerBoyHud.visible = true
	LevelManager.load_new_level("res://Scenes/home_bedroom.tscn", "TeleporterDestination", Vector2.ZERO )
	pass
