extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(43,2)]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID:=1
const USED_BLOCK_ID:=5
const BRICK_BLOCK_ID:=0
const INVISIBLE_BLOCK_ID:=6
const palette="overworld"
var transition_coordx=-1
const castle_x:=4880

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if Global.checkpoint:
		mario.global_position=Vector2(2272,64)
	Global.time=399
	await get_tree().process_frame
	for koopa in $Enemies.get_children():
		koopa.palette="red"
		if $ForegroundTile.local_to_map(self.to_local(koopa.global_position))==Vector2i(36,3):
			koopa.state=koopa.States.FLY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_level_timer_timeout() -> void:
	Global.check_time("4-4") # Replace with function body.


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
