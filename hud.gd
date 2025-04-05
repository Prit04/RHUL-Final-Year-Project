extends CanvasLayer

## --- Main Gameplay HUD Script ---
## This is the main HUD for the gameplay, holding values such as the players health and score, along with score saving.

# --- UI Nodes ---
@onready var health_container = $MarginContainer/VBoxContainer/HealthContainer
@onready var score_label = $ScoreLabel

# --- Paths & Save Data ---
var save_path := "user://save_data.cfg"
var high_score := 0
var score := 0

# --- Health ---
var max_health := 5
var current_health := 5


func _ready() -> void:
	high_score = load_high_score()
	score = 0  # Reset score on game start or retry
	update_health(current_health, max_health)
	update_score_display()


# --- Score Management ---
func add_score(amount: int) -> void:
	score += amount
	if score > high_score:
		high_score = score
		show_new_high_score_message()
		save_score()

	update_score_display()

	if has_node("Points"):
		$Points.play()


func update_score(value: int) -> void:
	score = value
	score_label.text = "Score: " + str(score)


func update_score_display() -> void:
	if score_label:
		score_label.text = "Score: %d\nHigh Score: %d" % [score, high_score]


func show_new_high_score_message() -> void:
	var label := $NewHighScoreLabel
	if label:
		label.visible = true
		await get_tree().create_timer(2.0).timeout
		label.visible = false


# --- Health Management ---
func update_health(current: int, max: int) -> void:
	current_health = current
	max_health = max

	for i in range(health_container.get_child_count()):
		var heart = health_container.get_child(i)
		heart.visible = i < current


# --- Save / Load ---
func save_score() -> void:
	var config := ConfigFile.new()
	config.set_value("Save", "high_score", high_score)
	config.save(save_path)


func load_score() -> void:
	# Load score from separate file
	if FileAccess.file_exists("user://score.save"):
		var file = FileAccess.open("user://score.save", FileAccess.READ)
		score = file.get_var()

	# Load high score
	high_score = load_high_score()
	update_score_display()


func load_high_score() -> int:
	var config := ConfigFile.new()
	if config.load(save_path) == OK:
		return config.get_value("Save", "high_score", 0)
	return 0
