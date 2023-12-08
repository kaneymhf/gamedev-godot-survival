extends StaticBody2D

@onready var despawn_timer: Timer = $despawn


func _ready():
	despawn_timer.start(5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_despawn_timeout():
	pass # Replace with function body.
