class_name Puzzle_02 extends Node2D

@onready var barred_door = $BarredDoor2
@onready var is_finished_data = $PersistentDataHelper
@onready var ball_place = $"../BallPlace"
@onready var ball_place_2 = $"../BallPlace2"
@onready var ball_place_3 = $"../BallPlace3"
@onready var item_dropper: ItemDropper = $ItemDropper
var isFinished = true

func _ready() -> void:
	is_finished_data.data_loaded.connect( check_puzzle_state )
	check_puzzle_state()

func check_auth() -> void:
	var places = get_parent().get_children()
	var auth = false
	var password: Array [int] = []
	for place in places:
		if place is BallPlace:
			if not place.isEmpty:
				password.append(place.item.id)
			else:
				password.append(0)			
	if password[0] == 1 and password[1] == 2 and password[2] == 3:
		is_finished_data.set_value()
		ball_place.block()
		ball_place_2.block()
		ball_place_3.block()
		item_dropper.drop_item()
		auth = true

	if auth and not barred_door.is_open or isFinished:
		barred_door.open_door()
	elif not auth and barred_door.is_open:	
		barred_door.close_door()

func check_puzzle_state() -> void:
	isFinished = is_finished_data.value
	if isFinished:
		ball_place.block()
		ball_place_2.block()
		ball_place_3.block()
		barred_door.opened()
