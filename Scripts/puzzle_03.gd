extends Node2D

@onready var is_finished_data: PersistentDataHelper = $PersistentDataHelper
@onready var item_dropper: ItemDropper = $ItemDropper

const SLIME = preload("res://Scenes/slime.tscn")
const BAT = preload("res://Scenes/bat.tscn")
const SKELETON = preload("res://Scenes/skeleton.tscn")

var isFinished = false
var level : int = 1

func _ready() -> void:
	is_finished_data.data_loaded.connect( check_puzzle_state )
	get_parent().child_exiting_tree.connect( _on_enemy_destroyed )
	check_puzzle_state()
	
func check_puzzle_state() -> void:
	isFinished = is_finished_data.value
	if not isFinished and level <= 3:
		for child in get_parent().get_children():
			if child is EnemyDropper:
				if level == 1:
					child.enemy = SLIME.instantiate()
				elif level == 2:
					child.enemy = BAT.instantiate()
				elif level == 3:
					child.enemy = SKELETON.instantiate()		
				child.drop_enemy()
	
	if level > 3:
		isFinished = true	
		is_finished_data.set_value()
		item_dropper.drop_item()		
		
func _on_enemy_destroyed( e : Node ) -> void:
	if e is Enemy:
		if enemy_count() <= 1:
			level += 1
			check_puzzle_state()
	pass


func enemy_count() -> int:
	var _count : int = 0
	for c in get_parent().get_children():
		if c is Enemy:
			_count += 1		
			
	return _count
