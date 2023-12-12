extends CharacterBody2D

@onready var detection_area = $detection_area/CollisionShape2D
@onready var collect_area = $collect_area/CollisionShape2D
@onready var collision = $CollisionShape2D
@onready var animation = $AnimatedSprite2D
@onready var slime_collectable = preload("res://scenes/slime_collectable.tscn")

@export var item: InventoryItem

var speed: int = 100
var health: float = 100.0

var dead: bool = false
var player_in_area: bool = false
var player: CharacterBody2D = null

var drop
var can_collect: bool = false

func _ready():
	dead = false
	health = randi_range(80, 120)
	
func _physics_process(delta):
	if !dead:
		detection_area.disabled = false
		collect_area.disabled = true
		collision.disabled = false		
		if player_in_area:
			position += (player.position - position) / speed
			animation.play("move")
		else:
			animation.play("idle")
	else:
		detection_area.disabled = true
		collision.disabled = true
		collect_area.disabled = false		
		if can_collect and Input.is_action_just_pressed("interact"):
			player.collect(item)
			drop.visible = false
			queue_free()


func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body

func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		player = null


func _on_hitbox_area_entered(area):
	if area.has_method("deal_damage"):
		take_damage(area.deal_damage())

func take_damage(ammount: int):
	health -= ammount
	if health <= 0 and !dead:
		death()
		
func death():
	dead = true
	animation.play("dead")
	await get_tree().create_timer(1).timeout
	drop_slime()

func drop_slime():
	drop = slime_collectable.instantiate()
	drop.global_position = global_position
	get_parent().add_child(drop)	
	await get_tree().create_timer(5).timeout
	get_parent().remove_child(drop)
	queue_free()	


func _on_collect_area_body_entered(body):
	if body.has_method("player"):
		if dead:
			can_collect = true
			player = body

func _on_collect_area_body_exited(body):
	if body.has_method("player"):
		can_collect = false
		player = null
