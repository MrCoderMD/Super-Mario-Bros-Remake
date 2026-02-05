extends Level

@onready var mario=$Mario
var is_pipe_entered:=false
var invisible_blocks=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	mario.is_auto_walking=true
	mario.set_physics_process(true) # Replace with function body.
	$UI/MarginContainer/HBoxContainer/Label2.text="WORLD\n1-2"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		if mario.global_position.x>=304:
			mario.is_auto_walking=false
			if !is_pipe_entered:
				is_pipe_entered=true
				$BgMusic.stop()
				if mario.global_position.y>=383:
					await mario.slide_right()
					get_tree().change_scene_to_file("res://Scenes/level_"+Global.currentlevel+".tscn")
