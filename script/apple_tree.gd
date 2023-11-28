extends Node2D

@export var item: InventoryItem

@onready var growth_timer: Timer = $growth_timer
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var press_label: Label = $pressLabel
@onready var spawn_apple: Marker2D = $Marker2D
@onready var apple = preload("res://scenes/apple_collectable.tscn")

var player: CharacterBody2D = null
var state: String = "no_apples" # apples / no_apples
var player_in_area: bool = false

func _ready():
	if state == "no_apples":
		growth_timer.start()

func _process(delta):
	anim_sprite.play(state)
	
	var can_pick = (player_in_area and state == "apples")
	
	press_label.visible = can_pick
	
	if can_pick:
		if Input.is_action_just_pressed("interact"):
			state = "no_apples"
			dropApple()
			

func _on_pickable_area_body_entered(body):
	if body.has_method("player"): 
		player_in_area = true
		player = body

func _on_pickable_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		player = null


func _on_growth_timer_timeout():
	if state == "no_apples": state = "apples"


func dropApple():
	var apple_instance = apple.instantiate()
	apple_instance.global_position = spawn_apple.global_position
	get_parent().add_child(apple_instance)
	player.collect(item)
	await get_tree().create_timer(3).timeout
	growth_timer.start()
