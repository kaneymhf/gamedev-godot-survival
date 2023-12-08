extends StaticBody2D

@export var item: InventoryItem

@onready var growth_timer: Timer = $growth_timer
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_apples_markers: Array = $spawn_apples_markers.get_children()
@onready var apple = preload("res://scenes/apple_collectable.tscn")

var player: CharacterBody2D = null
var state: String = "no_apples" # apples / no_apples
var player_in_area: bool = false
var drop_chances = [0.7, 0.2, 0.1] # 70% for 1 apple, 20% for 2 apples, 10% for 3 apples

func _ready():
	if state == "no_apples":
		growth_timer.start()

func _process(delta):
	anim_sprite.play(state)
	
	var can_pick = (player_in_area and state == "apples")
	
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
	# Generate a random number between 0 and 1
	var random_number = randf()
	
	# Determine how many apples wiil drop
	var num_apples = 1
	if random_number > drop_chances[0]:
		if random_number > drop_chances[0] + drop_chances[1]:
			num_apples = 3
		else:
			num_apples = 2
			
	process_dropped_apples(num_apples)
	

func process_dropped_apples(num_apples: int):
	var spawn_points = get_spawn_points()
	for i in num_apples:
		var apple_instance = apple.instantiate()
		var marker = randi() % spawn_points.size()
		var spawn_apple = spawn_points[marker]
		spawn_points.remove_at(marker)
		apple_instance.global_position = spawn_apple
		get_parent().add_child(apple_instance)
		player.collect(item)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(3).timeout
	growth_timer.start()

func get_spawn_points():
	var spawn_points: Array[Vector2]
	for marker in spawn_apples_markers:
		spawn_points.append(marker.global_position)
	
	return spawn_points
		
