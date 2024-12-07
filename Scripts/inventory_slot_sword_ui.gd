class_name InventorySlotSwordUI extends Button


var slot_data : SlotData : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label



func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )
	pressed.connect( item_pressed )


func set_slot_data( value : SlotData ) -> void:
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.inventory_item.side_texture
	if slot_data.quantity > 0:
		label.text = str( slot_data.quantity )


func item_focused() -> void:
	if slot_data != null:
		if slot_data.inventory_item != null:
			InventoryUi.update_item_description( slot_data.inventory_item.description )
	pass


func item_unfocused() -> void:
	InventoryUi.update_item_description( "" )
	pass


func item_pressed() -> void:
	pass
