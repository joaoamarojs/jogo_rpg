@tool
class_name DecorationLamp extends StaticBody2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export var side: SIDE = SIDE.LEFT:
	set( _v ):
		side = _v
		_change_position()

@onready var sprite_2d_4 = $Sprite2D4
@onready var sprite_2d_3 = $Sprite2D3
@onready var sprite_2d_2 = $Sprite2D2
@onready var sprite_2d = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	_change_position()

func _change_position() -> void:
	if sprite_2d == null:
		sprite_2d = get_node("Sprite2D")
		
	if sprite_2d_2 == null:
		sprite_2d_2 = get_node("Sprite2D2")
	
	if sprite_2d_3 == null:
		sprite_2d_3 = get_node("Sprite2D3")
	
	if sprite_2d_4 == null:
		sprite_2d_4 = get_node("Sprite2D4")	
		
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")	
		
	if side == SIDE.TOP:
		sprite_2d.visible = false
		sprite_2d_2.visible = false
		sprite_2d_3.visible = false
		sprite_2d_4.visible = true
		collision_shape.position.y = -1
	elif side == SIDE.BOTTOM:
		sprite_2d.visible = false
		sprite_2d_2.visible = true
		sprite_2d_3.visible = false
		sprite_2d_4.visible = false
		collision_shape.position.y = -33
	elif side == SIDE.LEFT:
		sprite_2d.visible = false
		sprite_2d_2.visible = false
		sprite_2d_3.visible = true
		sprite_2d_4.visible = false
		collision_shape.position.y = -1
	elif side == SIDE.RIGHT:
		sprite_2d.visible = true
		sprite_2d_2.visible = false
		sprite_2d_3.visible = false
		sprite_2d_4.visible = false
		collision_shape.position.y = -1
