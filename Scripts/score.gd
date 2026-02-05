extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween=get_tree().create_tween()
	tween.tween_property(self,"position:y",-48,1).as_relative()
	await tween.finished
	tween.kill()
	self.text=""
