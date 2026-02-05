extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(25,9),Vector2i(148,9)]
const lifeupcoords=[Vector2i(92,5)]
const coinbrickcoords=[Vector2i(220,9)]
const starcoords=[]
const invisible_blocks=[Vector2i(92,5)]
const QUESTION_BLOCK_ID:=19
const BRICK_BLOCK_ID:=20
const USED_BLOCK_ID:=22
const INVISIBLE_BLOCK_ID:=9
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
const castle_x:=7408
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if !Global.can_transition:
		mario.z_index=$ForegroundTile.z_index-1
		mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		print(mario.global_position)
		await mario.slide_up()
		mario.z_index=$ForegroundTile.z_index+1
	else:
		if Global.checkpoint:
			mario.global_position=Vector2(2976,400)
		$Lakitu.process_mode=Node.PROCESS_MODE_INHERIT
		Global.time=399


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
		#$CameraFollower/Controls.process_mode=Node.PROCESS_MODE_ALWAYS
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_level_timer_timeout() -> void:
	Global.check_time("4-2") # Replace with function body.


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_lakitu_start_body_entered(body) -> void:
	if body.name=="Mario":
		$Lakitu.process_mode=Node.PROCESS_MODE_INHERIT # Replace with function body.


func _on_lakitu_end_body_entered(body) -> void:
	if body.name=="Mario":
		$Lakitu.state=$Lakitu.States.IDLE


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
