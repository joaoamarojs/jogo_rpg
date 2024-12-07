class_name ItemEffectDialog extends ItemEffect

signal finished

@export var npc_info: NPCResource
@export var dialog_texts: Array[ String ]

var dialog_items : Array[ DialogItem ]

func use() -> bool:
	dialog_items.clear()
	for text in dialog_texts:
		var dialog_text = DialogText.new()
		dialog_text.npc_info = npc_info
		dialog_text.text = text  
		dialog_items.append(dialog_text)  
		
	DialogSystem.finished.connect( _on_dialog_finished )
	DialogSystem.show_dialog( dialog_items )
	InventoryUi.hide_inventory()
	return false
	
func _on_dialog_finished() -> void:
	DialogSystem.finished.disconnect( _on_dialog_finished )
	finished.emit()
