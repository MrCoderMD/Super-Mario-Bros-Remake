extends CanvasLayer

@onready var musicvalue=$MarginContainer/VBoxContainer2/VBoxContainer/Music/Value
@onready var musicslider=$MarginContainer/VBoxContainer2/VBoxContainer/Music/MusicSlider
@onready var sfxvalue=$MarginContainer/VBoxContainer2/VBoxContainer/SFX/Value
@onready var sfxslider=$MarginContainer/VBoxContainer2/VBoxContainer/SFX/SFXSlider
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sound=Configfile.load_music_settings() # Replace with function body.
	musicslider.value=sound["music_volume"]
	sfxslider.value=sound["sfx_volume"]

func _on_music_slider_value_changed(value: float) -> void:
	musicvalue.text=str(int(musicslider.value)) # Replace with function body.


func _on_sfx_slider_value_changed(value: float) -> void:
	sfxvalue.text=str(int(sfxslider.value))


func _on_save_pressed() -> void:
	await Configfile.save_music_setting("sfx_volume",int(sfxslider.value))
	await Configfile.save_music_setting("music_volume",int(musicslider.value))
	if self!=get_tree().current_scene:
		self.queue_free()
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_cancel_pressed() -> void:
	if self!=get_tree().current_scene:
		self.queue_free()
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_customize_pressed() -> void:
	if self!=get_tree().current_scene:
		var control=load("res://Scenes/control_2.tscn").instantiate()
		control.process_mode=PROCESS_MODE_ALWAYS
		get_tree().current_scene.add_child(control)
	else:
		get_tree().change_scene_to_file("res://Scenes/control_2.tscn") # Replace with function body.
