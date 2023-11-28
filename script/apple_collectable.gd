extends StaticBody2D

@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	fallFromTree()

func fallFromTree():
	animation.play("falling")
	await get_tree().create_timer(1.5).timeout
	animation.play("fade")
	await animation.animation_finished
	queue_free()
