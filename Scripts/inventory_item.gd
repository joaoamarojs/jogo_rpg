class_name InventoryItem extends Resource

var stacks = 1

@export var ground_collision_shape: RectangleShape2D
@export var name: String = ""
@export var animation: SpriteFrames
@export var side_texture: Texture2D
@export_multiline var description : String = ""
@export var pickup_sound: AudioStream
@export var use_on_pickup: bool = false

@export_category("Item Use Effects")
@export var effects : Array[ ItemEffect ]


func use() -> bool:
	if effects.size() == 0:
		return false
	
	for e in effects:
		if e:
			var was_used = e.use()
			if not was_used:
				return false
	return true
