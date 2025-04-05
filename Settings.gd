extends Node

## --- Settings Manager Script ---
## Stores and applies game settings such as volume levels, fullscreen, and vsync.
## Saves to and loads from a local configuration file.

# --- Audio Settings ---
var master_volume := 1.0
var music_volume := 1.0
var sfx_volume := 1.0

# --- Video Settings ---
var fullscreen := false
var vsync := false

# --- Config Path ---
var config_path := "user://settings.cfg"


func _ready() -> void:
	# Load settings on game start
	load_settings()


func save_settings() -> void:
	# Saves current settings to config file
	var config = ConfigFile.new()
	config.set_value("Audio", "master", master_volume)
	config.set_value("Audio", "music", music_volume)
	config.set_value("Audio", "sfx", sfx_volume)
	config.set_value("Video", "fullscreen", fullscreen)
	config.set_value("Video", "vsync", vsync)
	config.save(config_path)


func load_settings() -> void:
	# Loads settings from config file and applies them
	var config = ConfigFile.new()
	if config.load(config_path) == OK:
		master_volume = config.get_value("Audio", "master", 1.0)
		music_volume = config.get_value("Audio", "music", 1.0)
		sfx_volume = config.get_value("Audio", "sfx", 1.0)
		fullscreen = config.get_value("Video", "fullscreen", false)
		vsync = config.get_value("Video", "vsync", false)

		apply_video_settings()
		apply_audio_settings()


func apply_video_settings() -> void:
	# Applies current video settings (fullscreen and vsync)
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED
	)
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED
	)


func apply_audio_settings() -> void:
	# Applies volume settings to respective audio buses
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))
