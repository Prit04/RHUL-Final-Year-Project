extends CanvasLayer

@onready var health_container = $MarginContainer/VBoxContainer/HealthContainer
@onready var score_label = $ScoreLabel

var max_health = 5
var current_health = 5
var score = 0

func _ready():
	update_health(current_health, max_health)
	update_score(score)

func update_health(current: int, max: int):
	current_health = current
	max_health = max
	for i in range(health_container.get_child_count()):
		var heart = health_container.get_child(i)
		heart.visible = i < current


func update_score(value: int):
	score = value
	score_label.text = "Score: " + str(score)

func add_score(amount: int):
	update_score(score + amount)
	$AnimationPlayer.play("score_pop")
