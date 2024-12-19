@tool
class_name Sign extends StaticBody2D

enum TYPE { SMALL, MEDIUM, BIG_LEFT, BIG_RIGHT }
enum STYLE { LEFT, MIDDLE, RIGHT }

@export var type: TYPE = TYPE.SMALL:
	set( _v ):
		type = _v
		_change_type()

@export_range(1, 2) var qtd_placas : int:
	set( _v ):
		qtd_placas = _v
		_validate_qtd_placas()
		_update_sprite_frame()

@export var sign: STYLE = STYLE.LEFT:
	set( _v ):
		sign = _v
		_update_sprite_frame()
		
@export var sign_2: STYLE = STYLE.LEFT:
	set( _v ):
		sign_2 = _v
		_update_sprite_frame()

@onready var small = $small
@onready var medium = $medium
@onready var big_left = $big_left
@onready var big_right = $big_right
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	_change_type()

func _change_type() -> void:
	if small == null:
		return
		
	if medium == null:
		return
	
	if big_left == null:
		return
	
	if big_right == null:
		return
		
	if collision_shape == null:
		return
		
	if type == TYPE.SMALL:
		qtd_placas=1
		collision_shape.shape.size.x = 16
		collision_shape.shape.size.y = 4
		small.visible = true
		medium.visible = false
		big_left.visible = false
		big_right.visible = false
	elif type == TYPE.MEDIUM:
		collision_shape.shape.size.x = 6
		collision_shape.shape.size.y = 4
		small.visible = false
		medium.visible = true
		big_left.visible = false
		big_right.visible = false
	elif type == TYPE.BIG_LEFT:
		collision_shape.shape.size.x = 6
		collision_shape.shape.size.y = 4
		small.visible = false
		medium.visible = false
		big_left.visible = true
		big_right.visible = false
	elif type == TYPE.BIG_RIGHT:
		collision_shape.shape.size.x = 6
		collision_shape.shape.size.y = 4
		small.visible = false
		medium.visible = false
		big_left.visible = false
		big_right.visible = true
		
	_update_sprite_frame()	

func _validate_qtd_placas() -> void:
	if type == TYPE.SMALL and qtd_placas > 1:
		qtd_placas = 1  # Ajusta automaticamente a quantidade de placas
		print("Quantidade de placas ajustada para 1, pois o tipo é SMALL.")
		
func _update_sprite_frame() -> void:
	var sprite: Sprite2D = _get_visible_sprite()
	if sprite == null:
		return
	
	var frame = 0
	
	match type:
		TYPE.SMALL:
			if qtd_placas == 1:
				match sign:
					STYLE.MIDDLE: frame = 0
					STYLE.RIGHT: frame = 1
					STYLE.LEFT: frame = 2
		TYPE.MEDIUM, TYPE.BIG_LEFT, TYPE.BIG_RIGHT:
			if qtd_placas == 1:
				match sign:
					STYLE.MIDDLE: frame = 0
					STYLE.RIGHT: frame = 1
					STYLE.LEFT: frame = 2
			elif qtd_placas == 2:
				match sign:
					STYLE.MIDDLE:
						match sign_2:
							STYLE.MIDDLE: frame = 3
							STYLE.RIGHT: frame = 6
							STYLE.LEFT: frame = 8
					STYLE.RIGHT:
						match sign_2:
							STYLE.RIGHT: frame = 4
							STYLE.LEFT: frame = 9
							STYLE.MIDDLE: frame = 10
					STYLE.LEFT:
						match sign_2:
							STYLE.LEFT: frame = 5
							STYLE.MIDDLE: frame = 11
							STYLE.RIGHT: frame = 7
	sprite.frame = frame

func _get_visible_sprite() -> Sprite2D:
	if type == TYPE.SMALL:
		return small
	elif type == TYPE.MEDIUM:
		return medium
	elif type == TYPE.BIG_LEFT:
		return big_left
	elif type == TYPE.BIG_RIGHT:
		return big_right
	return null
