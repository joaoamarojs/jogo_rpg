class_name BallPlace extends StaticBody2D

signal ball_changed

@onready var sprite_interact: Sprite2D = $Sprite2D2

@onready var sprite = $Sprite2D
@onready var interact_area: Area2D = $Area2D
var inventory_items: Array[ InventoryItem ] = []
var is_blocked = false
@export var blocked_id = 0

const ITEM_PATH_1 = "res://Resources/red_ball.tres"
const ITEM_PATH_2 = "res://Resources/green_ball.tres"
const ITEM_PATH_3 = "res://Resources/blue_ball.tres"

var item: PuzzleItem
var isEmpty = true

func _ready():
	sprite_interact.visible = false
	inventory_items.append(load(ITEM_PATH_1))
	inventory_items.append(load(ITEM_PATH_2))
	inventory_items.append(load(ITEM_PATH_3))
	if not is_blocked:
		if item:
			isEmpty = false
			
		if isEmpty:
			sprite.frame = 0
		else:
			sprite.frame = item.id
	else:
		sprite.frame = blocked_id	
		
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )	
	
func _on_area_enter( _a : Area2D ) -> void:
	if sprite.frame != 0 and not is_blocked:
		sprite_interact.visible = true
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	sprite_interact.visible = false
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass
	
func player_interact() -> void:
	if not is_blocked:
		if not isEmpty:
			PlayerManager.INVENTORY_DATA.add_item( inventory_items[item.id-1], 1 )
			isEmpty = true
			set_place_state()
		pass
	
func set_item(a: PuzzleItem) -> bool:
	if not is_blocked:	
		if isEmpty:
			isEmpty = false
			item = a
			set_place_state()
			return true
		
	return false	
	
func set_place_state():
	ball_changed.emit()
	if not is_blocked:
		if isEmpty:
			sprite_interact.visible = false
			sprite.frame = 0
		else:
			sprite.frame = item.id
			pass	
	else:	
		sprite.frame = blocked_id	

func block() -> void:
	is_blocked = true
	sprite.frame = blocked_id
	sprite_interact.visible = false
