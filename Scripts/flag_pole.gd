extends Area2D

enum Palettes{OVERWORLD,OVERWORLD2}

var FlagPalette={
	Palettes.OVERWORLD:load("res://files/images/end0_flag.png"),
	Palettes.OVERWORLD2:load("res://files/images/end1_flag.png")
}

var PolePalette={
	Palettes.OVERWORLD:load("res://files/images/flagpole_1.png"),
	Palettes.OVERWORLD2:load("res://files/images/flagpole_2.png")
}
@export var palette:Palettes

func _ready() -> void:
	$Pole.texture=PolePalette[palette]
	$Flag.texture=FlagPalette[palette]

func _on_body_entered(body: Node2D) -> void:
		if body.name=="Mario":
			Global.is_completed=true
			get_tree().current_scene.get_node("LevelTimer").stop()
			var tween=get_tree().create_tween()
			tween.tween_property($Flag,"global_position:y",384-$Flag.texture.get_height()/2,1.1)
			body.start_flag_sequence() # Replace with function body.
			await tween.finished
			tween.kill()
			var scoring=AudioStreamPlayer2D.new()
			scoring.stream=load("res://files/sounds/scorering.wav")
			scoring.finished.connect(func():
				if Global.time!=0:
					scoring.play())
			get_tree().current_scene.get_node("CameraFollower").add_child(scoring)
			scoring.play()
			get_tree().current_scene.get_node("LevelTimer").start(0.05)
