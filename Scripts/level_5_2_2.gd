extends Level

@onready var mario=$Mario

const powerupcoords=[]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID=0
const BRICK_BLOCK_ID=0
const USED_BLOCK_ID=0
const INVISIBLE_BLOCK_ID:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if mario.global_position.x<1653.5:
			if $CameraFollower.position.x<=$Mario.global_position.x:
				$CameraFollower.position.x=$Mario.global_position.x
			

func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_level_timer_timeout() -> void:
	Global.check_time() # Replace with function body.


func _on_transition_body_entered(body: Node2D) -> void:
	if body==mario:
		await body.slide_right() # Replace with function body.
		get_tree().change_scene_to_file("res://Scenes/level_"+Global.currentlevel+".tscn")
