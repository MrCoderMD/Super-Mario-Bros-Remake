extends Node2D
class_name Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level=self
	var music=Configfile.load_music_settings()
	if self.has_node("CameraFollower"):
		self.get_node("CameraFollower/BgMusic").volume_linear=float(music["music_volume"]*0.01)
	else:
		self.get_node("BgMusic").volume_linear=float(music["music_volume"]*0.01)
