class_name InventoryData extends Resource

@export var slots : Array[ SlotData ]


func _init() -> void:
	connect_slots()
	pass



func add_item( item : InventoryItem, count : int = 1 ) -> bool:
	for s in slots:
		if s:
			if s.inventory_item == item:
				s.quantity += count
				return true
	
	for i in slots.size():
		if slots[ i ] == null:
			var new = SlotData.new()
			new.inventory_item = item
			new.quantity = count
			slots[ i ] = new
			new.changed.connect( slot_changed )
			return true
	
	return false


func connect_slots() -> void:
	for s in slots:
		if s:
			s.changed.connect( slot_changed )


func slot_changed() -> void:
	for s in slots:
		if s:
			if s.quantity < 1:
				s.changed.disconnect( slot_changed )
				var index = slots.find( s )
				slots[ index ] = null
				emit_changed()
	pass



## Gather the inventory into an array
func get_save_data() -> Array:
	var item_save : Array = []
	for i in slots.size():
		item_save.append( item_to_save( slots[i] ) )
	return item_save


## Convert each inventory item into a dictionary
func item_to_save( slot : SlotData ) -> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.inventory_item != null:
			result.item = slot.inventory_item.resource_path
	return result




func parse_save_data( save_data : Array ) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize( array_size )
	for i in save_data.size():
		slots[ i ] = item_from_save( save_data[ i ] )
	connect_slots()



func item_from_save( save_object : Dictionary ) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.inventory_item = load( save_object.item )
	new_slot.quantity = int( save_object.quantity )
	return new_slot



func use_item( item : InventoryItem, count : int = 1 ) -> bool:
	for s in slots:
		if s:
			if s.inventory_item == item and s.quantity >= count:
				s.quantity -= count
				return true
	return false
	
func has_item_of_category(category: String) -> bool:
	for s in slots:
		if s and s.inventory_item:
			if s.inventory_item.item_type == category:
				return true
	return false