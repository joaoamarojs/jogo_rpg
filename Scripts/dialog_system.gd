@tool
class_name DialogSystemNode extends CanvasLayer

signal finished
signal letter_added( letter : String )

var is_active : bool = false
var text_in_progress : bool = false

var text_speed : float = 0.02
var text_length : int = 0
var plain_text : String

var dialog_items : Array[ DialogItem ]
var dialog_item_index : int = 0


@onready var dialog_ui : Control = $DialogUI
@onready var content: RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogUI/NameLabel
@onready var dialog_progress_indicator: PanelContainer = $DialogUI/DialogProgressIndicator
@onready var dialog_progress_indicator_label: Label = $DialogUI/DialogProgressIndicator/Label
@onready var timer: Timer = $DialogUI/Timer
@onready var audio_stream_player: AudioStreamPlayer = $DialogUI/AudioStreamPlayer




func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child( self )
			return
		return
	timer.timeout.connect( _on_timer_timeout )
	hide_dialog()
	pass



## Handle key presses, but only if Dialog System is active
func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	if(
			event.is_action_pressed("interact") or
			event.is_action_pressed("sword_attack") 
	):
		if text_in_progress == true:
			content.visible_characters = text_length
			timer.stop()
			text_in_progress = false
			show_dialog_button_indicator( true )
			return
		dialog_item_index += 1
		if dialog_item_index < dialog_items.size():
			start_dialog()
		else:
			hide_dialog()
	pass



## Show the dialog UI
func show_dialog( _items : Array[ DialogItem ] ) -> void:
	is_active = true
	dialog_ui.visible = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	InventoryUi.process_mode = Node.PROCESS_MODE_DISABLED
	dialog_items = _items
	dialog_item_index = 0
	get_tree().paused = true
	await get_tree().process_frame
	start_dialog()
	pass



## Hide Dialog System UI
func hide_dialog() -> void:
	is_active = false
	dialog_ui.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	InventoryUi.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	pass



## Initialize UI variables for a new Dialog Interaction
func start_dialog() -> void:
	show_dialog_button_indicator( false )
	var _d : DialogItem = dialog_items[ dialog_item_index ]
	set_dialog_data( _d )
	
	content.visible_characters = 0
	text_length = content.get_total_character_count()
	plain_text = content.get_parsed_text()
	text_in_progress = true
	start_timer()
	pass



func _on_timer_timeout() -> void:
	content.visible_characters += 1
	if content.visible_characters <= text_length:
		letter_added.emit( plain_text[ content.visible_characters - 1 ] )
		start_timer()
	else:
		show_dialog_button_indicator( true )
		text_in_progress = false
	pass


## Set dialog and NPC variables, etc based on dialog item parameters
func set_dialog_data( _d : DialogItem ) -> void:
	if _d is DialogText:
		content.text = _d.text
	name_label.text = _d.npc_info.npc_name
	pass



## Show dialog NEXT/END indicator once dialog item is complete and ready to advance
func show_dialog_button_indicator( _is_visible : bool ) -> void:
	dialog_progress_indicator.visible = _is_visible
	if dialog_item_index + 1 < dialog_items.size():
		dialog_progress_indicator_label.text = "PROXIMO"
	else:
		dialog_progress_indicator_label.text = "FIM"



func start_timer() -> void:
	timer.wait_time = text_speed
	timer.start()
	pass
