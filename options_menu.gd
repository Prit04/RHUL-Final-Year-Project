extends Control

@onready var master_slider = find_child("MasterSlider", true, false)
@onready var music_slider = find_child("MusicSlider", true, false)
@onready var sfx_slider = find_child("SFXSlider", true, false)

@onready var fullscreen_check = $VBoxContainer/FullscreenCheck
@onready var vsync_check = $VBoxContainer/VSyncCheck
@onready var back_button = $VBoxContainer/BackButton
@onready var click_player = $ClickPlayer

func _ready():
	$AnimationPlayer.play("fade_in")
	# Set initial values
	master_slider.value = Settings.master_volume
	music_slider.value = Settings.music_volume
	sfx_slider.value = Settings.sfx_volume
	fullscreen_check.button_pressed = Settings.fullscreen
	vsync_check.button_pressed = Settings.vsync

	master_slider.value_changed.connect(_on_volume_changed)
	music_slider.value_changed.connect(_on_volume_changed)
	sfx_slider.value_changed.connect(_on_volume_changed)
	fullscreen_check.toggled.connect(_on_video_setting_changed)
	vsync_check.toggled.connect(_on_video_setting_changed)
	back_button.pressed.connect(_on_back_button_pressed)

func _on_volume_changed(_val):
	Settings.master_volume = master_slider.value
	Settings.music_volume = music_slider.value
	Settings.sfx_volume = sfx_slider.value
	Settings.apply_audio_settings()
	Settings.save_settings()

func _on_video_setting_changed(_pressed):
	Settings.fullscreen = fullscreen_check.button_pressed
	Settings.vsync = vsync_check.button_pressed
	Settings.apply_video_settings()
	Settings.save_settings()



func _on_back_button_pressed():
	click_player.play()
	await $ClickPlayer.finished
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	queue_free()  
