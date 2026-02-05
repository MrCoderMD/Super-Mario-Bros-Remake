extends Level
@onready var mario=$Mario

const QUESTION_BLOCK_ID=19
const BRICK_BLOCK_ID=20
const USED_BLOCK_ID=22
var BRICK_TEXTURE=load("res://files/images/brick1.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris1.png")
const INVISIBLE_BLOCK_ID=12
const powerupcoords=[]
const lifeupcoords=[]
const coinbrickcoords=[Vector2i(21,9)]
const starcoords=[]
var invisible_blocks=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Global.can_transition=false # Replace with function body.
	mario.animation.play(mario.size_prefix[Global.size]+"_jump")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)


func _on_level_timer_timeout() -> void:
	if Global.time==0:
		$LevelTimer.autostart=false
		Global.size=Global.Size.SMOL
		await mario.shrink_or_die()
	else:
		Global.time-=1
		if Global.time<100:
			if Global.lowtime not in $CameraFollower.get_children():
				$CameraFollower.add_child(Global.lowtime)
				$CameraFollower/BgMusic.stop()
				Global.lowtime.play()
				await Global.lowtime.finished
				$CameraFollower/BgMusic.stream=load("res://files/sounds/underground-fast.wav")
				$CameraFollower/BgMusic.play()


func _on_transition_body_entered(body: Node2D) -> void:
	if body.name=="Mario":
		await body.slide_right() # Replace with function body.
		get_tree().change_scene_to_file("res://Scenes/level_"+Global.currentlevel+".tscn")


func _on_bg_music_finished() -> void:
	$BgMusic.play() # Replace with function body.
