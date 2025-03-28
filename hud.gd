extends CanvasLayer

@onready var health_container = $MarginContainer/VBoxContainer/HealthContainer
@onready var score_label = $ScoreLabel


var save_path := "user://save_data.cfg"
var high_score := 0

var max_health = 5
var current_health = 5
var score = 0

func _ready():
	high_score = load_high_score()  # Only load high score
	score = 0  # Reset score when starting/retrying
	update_health(current_health, max_health)
	update_score_display()





func save_score():
	var config = ConfigFile.new()
	config.set_value("Save", "high_score", high_score)
	config.save(save_path)
	print("💾 High Score saved:", high_score)


func load_score():
	# Load current score
	if FileAccess.file_exists("user://score.save"):
		var file = FileAccess.open("user://score.save", FileAccess.READ)
		score = file.get_var()

	# Load high score
	high_score = load_high_score()

	update_score_display()

func load_high_score() -> int:
	var config = ConfigFile.new()
	if config.load(save_path) == OK:
		return config.get_value("Save", "high_score", 0)
	return 0

func update_score_display():
	if score_label:
		score_label.text = "Score: %d\nHigh Score: %d" % [score, high_score]

	
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
	score += amount
	if score > high_score:
		high_score = score
		show_new_high_score_message()
		save_score()  
	update_score_display()

	
func show_new_high_score_message():
	var label = $NewHighScoreLabel
	if label:
		label.visible = true
		await get_tree().create_timer(2.0).timeout  
		label.visible = false
