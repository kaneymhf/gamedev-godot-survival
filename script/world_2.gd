extends Node2D

@onready var animation: AnimationPlayer = $world2openingcutscene/AnimationPlayer
@onready var mainworld: Node2D = $world2main
@onready var cutsceneworld: Node2D = $world2openingcutscene
@onready var worldFinished: Node2D = $world2openingcutscene/TileMapFinished
@onready var worldUnfinished: Node2D = $world2openingcutscene/TileMapUnfinished
@onready var camera: Camera2D = $world2openingcutscene/Path2D/PathFollow2D/Camera2D
@onready var smoke_particles = $world2openingcutscene/smoke_effect.get_children()

var is_openingcutscene: bool = false
var has_player_entered_in_area: bool = false
var player = null
var is_path_following = false

var smoke_has_happened = false
var smoke_is_happening = false

func _physics_process(delta):
	if is_openingcutscene:
		var pathFollower: PathFollow2D = $world2openingcutscene/Path2D/PathFollow2D
		if is_path_following:
			if !smoke_is_happening:
				pathFollower.progress_ratio += 0.001
				
			if pathFollower.progress_ratio >= 0.98:
				cutsceneEnding()
				
			if !smoke_is_happening and pathFollower.progress_ratio >= 0.66 and !smoke_has_happened:
				smoke_is_happening = true
				toggle_smoke()
				await get_tree().create_timer(1).timeout
				worldFinished.visible = true
				worldUnfinished.visible = false
				toggle_smoke()
				await get_tree().create_timer(0.5).timeout				
				smoke_has_happened = true
				smoke_is_happening = false
		

func _on_player_detection_body_entered(body):
	if body.has_method("player"):
		player = body
		if !has_player_entered_in_area:
			has_player_entered_in_area = true
			cutsceneOpening()
			
func cutsceneOpening():
	is_openingcutscene = true
	animation.play("cover_fade")
	camera.enabled = true	
	player.camera.enabled = false
	is_path_following = true
	
func cutsceneEnding():
	is_path_following = false	
	is_openingcutscene = false
	player.camera.enabled = true
	camera.enabled = false
	cutsceneworld.visible = false
	mainworld.visible = true


func toggle_smoke():
	for particle in smoke_particles:
		particle.emitting = !particle.emitting
