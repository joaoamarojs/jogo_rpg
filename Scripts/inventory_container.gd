class_name InventoryContainer extends Control

const INVENTORY_SLOT = preload("res://Scenes/UI/inventory_slot.tscn")

var focus_index : int = 0

@export var data : InventoryData
@onready var inventory_slot_sword: InventorySlotSwordUI = $"../../PanelContainer2/GridContainer/InventorySlotSword"
const SWORD = preload("res://Resources/sword.tres")

func _ready() -> void:
	InventoryUi.shown.connect( update_inventory )
	InventoryUi.hidden.connect( clear_inventory )
	clear_inventory()
	data.changed.connect( on_inventory_changed )
	pass


func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()


func update_inventory( i : int = 0 ) -> void:
			
	clear_inventory()
	if PlayerManager.player_boy.has_sword:
		var new_slot: SlotData = SlotData.new()
		new_slot.inventory_item = SWORD
		new_slot.quantity = 0
		inventory_slot_sword.slot_data = new_slot
	else:
		inventory_slot_sword.slot_data = null 
		
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child( new_slot )
		new_slot.slot_data = s
		new_slot.focus_entered.connect( item_focused )
	
	await get_tree().process_frame
	get_child( i ).grab_focus()


func item_focused() -> void:
	for i in get_child_count():
		if get_child( i ).has_focus():
			focus_index = i
			return
	pass


func on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory( i )
	
