class_name ItemEffectPuzzle extends ItemEffect

signal finished

@export var item : PuzzleItem
@export var npc_info: NPCResource

var dialog_texts_error: Array[ String ] = [ "Esse item não pode ser usado aqui!" ]
var dialog_texts_error_2: Array[ String ] = [ "O pedestal já tem uma bola!" ]
var dialog_items : Array[ DialogItem ]

func use() -> bool:
	InventoryUi.hide_inventory()
	var overlapping_bodies = PlayerManager.player_boy.interact_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is BallPlace:
			if body.set_item(item): 
				return true
				
			_send_dialog(dialog_texts_error_2)
			
			return false	

	_send_dialog(dialog_texts_error)
	return false
func _send_dialog(dialog_texts: Array[ String ]) -> void:
	for text in dialog_texts:
		var dialog_text = DialogText.new()
		dialog_text.npc_info = npc_info
		dialog_text.text = text  
		dialog_items.append(dialog_text)  
		
	DialogSystem.finished.connect( _on_dialog_finished )
	DialogSystem.show_dialog( dialog_items )
	
func _on_dialog_finished() -> void:
	DialogSystem.finished.disconnect( _on_dialog_finished )
	finished.emit()
	dialog_items.clear()
	
