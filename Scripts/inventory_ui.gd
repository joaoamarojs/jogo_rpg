class_name InventoryUI extends CanvasLayer

signal shown
signal hidden

var is_opened : bool = false
@onready var item_description = $Control/ItemDescription


func _ready() -> void:
	hide_inventory()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		if is_opened == false:
			if DialogSystem.is_active:
				return
			show_inventory()
		else:
			hide_inventory()
		get_viewport().set_input_as_handled()


func show_inventory() -> void:
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = true
	visible = true
	is_opened = true
	shown.emit()



func hide_inventory() -> void:
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	visible = false
	is_opened = false
	hidden.emit()
	
func update_item_description( new_text : String ) -> void:
	item_description.text = new_text
	pass		
