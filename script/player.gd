extends CharacterBody2D

@export var inventory: Inventory

@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_arrow: Marker2D = $Marker2D
@onready var arrow = preload("res://scenes/arrow.tscn")
@onready var camera: Camera2D = $Camera2D

var speed = 100
var player_state: String = "idle"
var player_last_dir: String = "s"
var bow_equiped = false
var bow_cooldown = true
var mouse_loc_from_player = null

func _physics_process(delta):
	
	mouse_loc_from_player = get_global_mouse_position() - self.position
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 || direction.y != 0:
		player_state = "walk"
	
	if !bow_equiped:
		velocity = direction * speed
		move_and_slide()
	
	if Input.is_action_just_pressed("toggle_weapon"):
		bow_equiped = !bow_equiped
	
	var mouse_position = get_global_mouse_position()
	spawn_arrow.look_at(mouse_position)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equiped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = spawn_arrow.rotation
		arrow_instance.global_position = spawn_arrow.global_position
		add_child(arrow_instance)
		
		animSprite.play(player_last_dir + "-attack")
				
		await get_tree().create_timer(0.5).timeout
		bow_cooldown = true
	
	checkDirection(direction)
	play_anim(direction)
	
func play_anim(playerDirection: Vector2):
	if !bow_equiped:
		animSprite.play(player_last_dir + "-" + player_state)
	else:
		checkBowDirection()
		animSprite.play(player_last_dir + "-attack")
		
func checkBowDirection():
	var x = mouse_loc_from_player.x
	var y = mouse_loc_from_player.y
	if x >= -25 and x <= 25 and y < 0:
		player_last_dir = "n"
	if y >= -25 and y <= 25 and x > 0:
		player_last_dir = "e"
	if x >= -25 and x <= 25 and y > 0:
		player_last_dir = "s"
	if y >= -25 and y <= 25 and x < 0:
		player_last_dir = "w"
	
	if x >= 25 and y <= -25:
		player_last_dir = "ne"
	if x >= 0.5 and y >= 25:
		player_last_dir = "se"
	if x <= -0.5 and y >= 25:
		player_last_dir = "sw"
	if x <= -25 and y <= -25:
		player_last_dir = "nw"
	

func checkDirection(playerDirection: Vector2):
	if playerDirection.y == -1:
		player_last_dir = "n"
	if playerDirection.x == 1:
		player_last_dir = "e"
	if playerDirection.y == 1:
		player_last_dir = "s"
	if playerDirection.x == -1:
		player_last_dir = "w"
		
	if playerDirection.x > 0.5 and playerDirection.y < -0.5:
		player_last_dir = "ne"
	if playerDirection.x > 0.5 and playerDirection.y > 0.5:
		player_last_dir = "se"
	if playerDirection.x < -0.5 and playerDirection.y < -0.5:
		player_last_dir = "nw"
	if playerDirection.x < -0.5 and playerDirection.y > 0.5:
		player_last_dir = "sw"

func collect(item: InventoryItem):
	inventory.insert(item)

func player():
	pass
