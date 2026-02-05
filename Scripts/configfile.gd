extends Node

var config=ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("sound","music_volume",100)
		config.set_value("sound","sfx_volume",100)
		
		config.set_value("controls","jump_pos",Vector2(714,390))
		config.set_value("controls","sprint_pos",Vector2(772,258))
		config.set_value("controls","select_pos",Vector2(813,38))
		config.set_value("controls","left_pos",Vector2(68,403))
		config.set_value("controls","right_pos",Vector2(285,403))
		config.set_value("controls","down_pos",Vector2(176,403))
		config.set_value("controls","up_pos",Vector2(176,294))
		
		config.set_value("controls","jump_scale",1.5)
		config.set_value("controls","sprint_scale",1.5)
		config.set_value("controls","select_scale",0.5)
		config.set_value("controls","left_scale",1.25)
		config.set_value("controls","right_scale",1.25)
		config.set_value("controls","down_scale",1.25)
		config.set_value("controls","up_scale",1.25)
		
		config.set_value("controls","jump_opacity",100)
		config.set_value("controls","sprint_opacity",100)
		config.set_value("controls","select_opacity",100)
		config.set_value("controls","left_opacity",100)
		config.set_value("controls","right_opacity",100)
		config.set_value("controls","down_opacity",100)
		config.set_value("controls","up_opacity",100)
		
		config.save(SETTINGS_FILE_PATH)
		
	else:
		config.load(SETTINGS_FILE_PATH)
		
func save_music_setting(key:String,value:int):
	config.set_value("sound",key,value)
	config.save(SETTINGS_FILE_PATH)
	
func load_music_settings():
	var music_settings={}
	for key in config.get_section_keys("sound"):
		music_settings[key]=config.get_value("sound",key)
	return music_settings
	
func save_control_settings():
	if get_tree().current_scene.has_node("Control2"):
		for button in get_tree().current_scene.get_node("Control2/Controls").get_children():
			config.set_value("controls",button.pos_key,button.global_position)
			config.set_value("controls",button.scale_key,button.scale.x)
			config.set_value("controls",button.opacity_key,button.modulate.a)
		config.save(SETTINGS_FILE_PATH)
	else:
		for button in get_tree().current_scene.get_node("Controls").get_children():
			config.set_value("controls",button.pos_key,button.global_position)
			config.set_value("controls",button.scale_key,button.scale.x)
			config.set_value("controls",button.opacity_key,button.modulate.a)
		config.save(SETTINGS_FILE_PATH)

func load_control_settings():
	var control_settings={}
	for key in config.get_section_keys("controls"):
		control_settings[key]=config.get_value("controls",key)
	return control_settings
