extends Node3D

@export var score_amount := 100
@onready var anim_player = $AnimationPlayer

var opened = false

func open():
	if opened:
		return
	opened = true
	print("Chest opened! Adding score: ", score_amount)

	
	if anim_player and anim_player.has_animation("Open"):
		anim_player.play("Open")

	# Add to score
	var hud = get_tree().get_root().get_node_or_null("DungeonGenerator/HUD")
	if hud:
		hud.add_score(score_amount)
	else:
		print("HUD not found. Score not updated.")

	await get_tree().create_timer(1.0).timeout
	queue_free()  # Remove chest after a delay
