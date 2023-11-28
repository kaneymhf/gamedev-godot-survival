extends CharacterBody2D

@export var inventory: Inventory

@onready var animSprite: AnimatedSprite2D = $AnimatedSprite2D

var speed = 100
var player_state: String = "idle"
var player_last_dir: String = "s"

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0 || direction.y != 0:
		player_state = "walk"
	
	velocity = direction * speed
	move_and_slide()
	
	checkDirection(direction)
	play_anim(direction)
	
func play_anim(playerDirection: Vector2):
	animSprite.play(player_last_dir + "-" + player_state)


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
