@tool
class_name PickUpItem extends CharacterBody2D

signal picked_up

@export var inventory_item: InventoryItem
@export var pickup_once: bool = false

@onready var animated_sprite: AnimatedSprite2D = $Area2D/AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer
@onready var area_2d: Area2D = $Area2D
@onready var use_on_pickup:bool = false
@onready var is_pickedup = $PersistentDataHelper

func _ready():
	animated_sprite.frames = inventory_item.animation
	collision_shape_2d.shape = inventory_item.ground_collision_shape
	area_2d.body_entered.connect( _on_body_entered )

	animated_sprite.play("default")
	use_on_pickup = inventory_item.use_on_pickup
	is_pickedup.data_loaded.connect( check_was_picked_up )
	check_was_picked_up()

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerBoy:
		if inventory_item.use_on_pickup == false:
			picked_up.emit()
			if PlayerManager.INVENTORY_DATA.add_item( inventory_item ) == true:
				item_picked_up()
		else:
			inventory_item.use()
			item_picked_up()
			
func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4		
		
func check_was_picked_up() -> void:
	if pickup_once:
		if is_pickedup.value:
			queue_free()
			
func item_picked_up() -> void:
	if pickup_once:
		is_pickedup.set_value()
	audio_player.stream = inventory_item.pickup_sound
	audio_player.play()
	visible = false
	await audio_player.finished
	queue_free()
	pass		
