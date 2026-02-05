extends Level

@onready var mario=$Mario

const QUESTION_BLOCK_ID=9
const BRICK_BLOCK_ID=0
const USED_BLOCK_ID=6
const INVISIBLE_BLOCK_ID=8
const COIN_BRICK_ID=0
const invisible_blocks=[]
const powerupcoords=[]
const lifeupcoords=[]
const coinbrickcoords=[]
const starcoords=[]
const palette:="castle"

func _ready() -> void:
	super()
	if !Global.can_transition:
		mario.z_index=$ForegroundTile.z_index-1
		mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		await mario.slide_up()
		mario.z_index=$ForegroundTile.z_index+1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x
		else:
			if $CameraFollower.position.x<=$Mario.global_position.x:
				$CameraFollower.position.x=$Mario.global_position.x

func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_level_timer_timeout() -> void:
	Global.check_time() # Replace with function body.
