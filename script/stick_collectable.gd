extends StaticBody2D

@export var item: InventoryItem

var player: CharacterBody2D = null
var player_in_area: bool = false

func _process(delta):
	if player_in_area:
		if Input.is_action_just_pressed("interact"):
			player_collect()

func _on_interactable_area_body_entered(body):
	if body.has_method("player"):
		player = body
		player_in_area = true
	
func _on_interactable_area_body_exited(body):
	if body.has_method("player"):
		player = null
		player_in_area = false

func player_collect():
	player.collect(item)
	await get_tree().create_timer(0.1).timeout
	queue_free()
