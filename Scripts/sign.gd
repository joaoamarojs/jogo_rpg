@tool
class_name Sign extends StaticBody2D

enum TYPE { SMALL, MEDIUM, BIG_LEFT, BIG_RIGHT }
enum STYLE_SMALL { MIDDLE, RIGHT, LEFT }
enum STYLE_OTHERS { MIDDLE, RIGHT, LEFT, DOUBLE_MIDDLE, DOUBLE_RIGHT, DOUBLE_LEFT, TOP_MIDDLE_BOTTOM_RIGHT, TOP_LEFT_BOTTOM_RIGHT, TOP_MIDDLE_BOTTOM_LEFT, TOP_RIGHT_BOTTOM_LEFT, TOP_RIGHT_BOTTOM_MIDDLE, TOP_LEFT_BOTTOM_MIDDLE }

@export var type: TYPE = TYPE.SMALL:
	set(_v):
		type = _v
		_change_type()

@export var style_small: STYLE_SMALL = STYLE_SMALL.MIDDLE:
	set(_v):
		style_small = _v
		_change_style()

@export var style_others: STYLE_OTHERS = STYLE_OTHERS.MIDDLE:
	set(_v):
		style_others = _v
		_change_style()

@onready var collision_shape = $CollisionShape2D
@onready var small = $small
@onready var medium = $medium
@onready var big_left = $big_left
@onready var big_right = $big_right

func _ready() -> void:
	_change_type()
	_change_style()

func _change_type() -> void:
	if small == null:
		small = get_node("small")
		
	if medium == null:
		medium = get_node("medium")
	
	if big_left == null:
		big_left = get_node("big_left")
	
	if big_right == null:
		big_right = get_node("big_right")	
		
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")		
		
	if type == TYPE.SMALL:
		collision_shape.shape.size = Vector2(16,4)
		small.visible = true
		medium.visible = false
		big_left.visible = false
		big_right.visible = false
	elif type == TYPE.MEDIUM:
		collision_shape.shape.size = Vector2(6,4)
		small.visible = false
		medium.visible = true
		big_left.visible = false
		big_right.visible = false
	elif type == TYPE.BIG_LEFT:
		collision_shape.shape.size = Vector2(6,4)
		small.visible = false
		medium.visible = false
		big_left.visible = true
		big_right.visible = false
	elif type == TYPE.BIG_RIGHT:
		collision_shape.shape.size = Vector2(6,4)
		small.visible = false
		medium.visible = false
		big_left.visible = false
		big_right.visible = true
	_change_style()

func _change_style() -> void:
	if type == TYPE.SMALL:
		match style_small:
			STYLE_SMALL.MIDDLE:
				small.frame = 0
			STYLE_SMALL.RIGHT:
				small.frame = 1
			STYLE_SMALL.LEFT:
				small.frame = 2
	elif type == TYPE.MEDIUM or type == TYPE.BIG_LEFT or type == TYPE.BIG_RIGHT:
		var target_sprite = null
		if type == TYPE.MEDIUM:
			target_sprite = medium
		elif type == TYPE.BIG_LEFT:
			target_sprite = big_left
		elif type == TYPE.BIG_RIGHT:
			target_sprite = big_right
		
		match style_others:
			STYLE_OTHERS.MIDDLE:
				target_sprite.frame = 0
			STYLE_OTHERS.RIGHT:
				target_sprite.frame = 1
			STYLE_OTHERS.LEFT:
				target_sprite.frame = 2
			STYLE_OTHERS.DOUBLE_MIDDLE:
				target_sprite.frame = 3
			STYLE_OTHERS.DOUBLE_RIGHT:
				target_sprite.frame = 4
			STYLE_OTHERS.DOUBLE_LEFT:
				target_sprite.frame = 5
			STYLE_OTHERS.TOP_MIDDLE_BOTTOM_RIGHT:
				target_sprite.frame = 6
			STYLE_OTHERS.TOP_LEFT_BOTTOM_RIGHT:
				target_sprite.frame = 7
			STYLE_OTHERS.TOP_MIDDLE_BOTTOM_LEFT:
				target_sprite.frame = 8
			STYLE_OTHERS.TOP_RIGHT_BOTTOM_LEFT:
				target_sprite.frame = 9
			STYLE_OTHERS.TOP_RIGHT_BOTTOM_MIDDLE:
				target_sprite.frame = 10
			STYLE_OTHERS.TOP_LEFT_BOTTOM_MIDDLE:
				target_sprite.frame = 11
