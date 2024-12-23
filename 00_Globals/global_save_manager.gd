extends Node

const SAVE_PATH = "user://"


signal game_loaded
signal game_saved


var current_save : Dictionary = {
	scene_path = "",
	player_boy = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0,
		has_sword = false,
		can_mount = false
	},
	horse = {
		pos_x = 0,
		pos_y = 0,
		scene_path = ""
	},
	items = [],
	persistence = [],
	quests = [],
}




func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_horse_data()
	update_item_data()
	
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()



func get_save_file() -> FileAccess:
	return FileAccess.open( SAVE_PATH + "save.sav", FileAccess.READ )



func load_game() -> void:
	var file := get_save_file()
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict: Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position(Vector2(current_save.player_boy.pos_x, current_save.player_boy.pos_y))
	PlayerManager.set_health(current_save.player_boy.hp, current_save.player_boy.max_hp)
	PlayerManager.player_boy.has_sword = current_save.player_boy.has_sword
	PlayerManager.player_boy.can_mount = current_save.player_boy.can_mount
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	
	load_horse_data()
	await LevelManager.level_loaded
	
	game_loaded.emit()
	
	pass


func update_player_data() -> void:
	var p : PlayerBoy = PlayerManager.player_boy
	current_save.player_boy.hp = p.hp
	current_save.player_boy.max_hp = p.max_hp
	current_save.player_boy.pos_x = p.global_position.x
	current_save.player_boy.pos_y = p.global_position.y
	current_save.player_boy.has_sword = p.has_sword

func update_horse_data() -> void:
	if HorseManager.horse and HorseManager.horse_spawned:
		current_save.horse.pos_x = HorseManager.horse.global_position.x
		current_save.horse.pos_y = HorseManager.horse.global_position.y
		current_save.horse.scene_path = current_save.scene_path  # Atualiza para a cena atual


func load_horse_data() -> void:
	if current_save.horse.scene_path == current_save.scene_path:  # Só instancia se estiver na mesma cena
		HorseManager.add_horse_instance()
		HorseManager.set_horse_position(Vector2(current_save.horse.pos_x, current_save.horse.pos_y))


func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()


func add_persistent_value( value : String ) -> void:
	if check_persistent_value( value ) == false:
		current_save.persistence.append( value )
	pass


func check_persistent_value( value : String ) -> bool:
	var p = current_save.persistence as Array
	return p.has( value )
