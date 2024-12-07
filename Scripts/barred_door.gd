class_name BarredDoor extends Node2D

var is_open = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	pass



func open_door() -> void:
	animation_player.play( "opened" )
	is_open = true
	pass


func close_door() -> void:
	animation_player.play( "closed" )
	is_open = false
	pass

func opened() -> void:
	animation_player.play( "open" )
	is_open = true
	pass	
