class_name Chest extends Node2D

const OPEN_CHEST = preload("res://Resources/Sounds/01_chest_open_1.wav")

signal opened

@export var inventory_item: InventoryItem
@export var effects: Array[ ItemEffect ]
@export var quantity : int = 1: set = _set_quantity
@onready var animated_sprite = $AnimatedSprite2D
@onready var audio_player = $AudioPlayer
var isOpened = false
@onready var animation_player = $AnimationPlayer
@onready var itemSprite = $ItemSprite
@onready var label: Label = $ItemSprite/Label
@onready var interact_area: Area2D = $Area2D
@onready var is_opened_data = $PersistentDataHelper
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready():
	_update_label()
	interact_area.area_entered.connect( _on_area_enter )
	interact_area.area_exited.connect( _on_area_exit )
	itemSprite.texture = inventory_item.side_texture
	is_opened_data.data_loaded.connect( set_chest_state )
	set_chest_state()
	
func _on_area_enter( _a : Area2D ) -> void:
	if not isOpened:
		sprite_2d.visible = true
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	sprite_2d.visible = false
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass
	
func player_interact() -> void:
	if isOpened == false:
		sprite_2d.visible = false
		audio_player.stream = OPEN_CHEST
		audio_player.play()
		playOpenChest()	
		
func _update_label() -> void:
	if label:
		if quantity <= 1:
			label.text = ""
		else:
			label.text = "x" + str( quantity )

func _set_quantity( value : int ) -> void:
	quantity = value
	_update_label()
	pass		
	
func playOpenChest():
	audio_player.stream = OPEN_CHEST
	audio_player.play()
	animated_sprite.play("opening")
	opened.emit()

func _on_animated_sprite_2d_animation_finished():
	if isOpened == false: 
		is_opened_data.set_value()
		isOpened = true
		if inventory_item and quantity > 0:
			animation_player.play("showItem")
			audio_player.stream = inventory_item.pickup_sound
			audio_player.play()
			if inventory_item.use_on_pickup == false:
				PlayerManager.INVENTORY_DATA.add_item( inventory_item, quantity )
			else:
				for n in quantity:
					inventory_item.use()
		for e in effects:
			if e:
				e.use()
		
			
func set_chest_state() -> void:
	isOpened = is_opened_data.value
	if isOpened:
		animated_sprite.play("opened")
	else:
		animated_sprite.play("closed")
	
