class_name Puzzle_01 extends Node2D

@onready var barred_door = $BarredDoor

func check_pressure_plates() -> void:
	var plates = get_children()
	var all_active = true
	
	for plate in plates:
		if plate is PressurePlate:
			if not plate.is_active:
				all_active = false
				break
	
	if all_active and not barred_door.is_open:
		barred_door.open_door()
	elif not all_active and barred_door.is_open:
		barred_door.close_door()
