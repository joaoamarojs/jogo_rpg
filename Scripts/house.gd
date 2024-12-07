@tool
class_name House extends StaticBody2D

@export var opened: bool:
	set(_v):
		opened = _v
		_update_door()
		
@export var chimney: bool:
	set(_v):
		chimney = _v
		_update_chimney()		
		
@onready var collision_shape: CollisionShape2D = $CollisionShape2D4
@onready var tile_map_layer: TileMapLayer = $TileMapLayer2
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return

func _update_door() -> void:
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D4")
		
	if sprite == null:
		sprite = get_node("Sprite2D")	
		
	if opened:
		collision_shape.disabled = true
		sprite.visible = true
	else:
		collision_shape.disabled = false
		sprite.visible = false

func _update_chimney() -> void:
	if tile_map_layer == null:
		tile_map_layer = get_node("TileMapLayer2")
		
	if chimney:
		tile_map_layer.visible = true
	else:
		tile_map_layer.visible = false
