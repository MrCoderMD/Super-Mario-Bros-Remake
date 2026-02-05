extends Level

@onready var mario=$Mario

const QUESTION_BLOCK_ID=1
const BRICK_BLOCK_ID=0
const USED_BLOCK_ID=4
const INVISIBLE_BLOCK_ID=5
const powerupcoords=[Vector2i(59,10)]
const invisible_blocks=[]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const palette="overworld"
const castle_x:=5040
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if Global.checkpoint:
		mario.global_position=Vector2(2304,256)
	Global.time=399
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.



func _on_level_timer_timeout() -> void:
	Global.check_time("1-4") # Replace with function body.


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
