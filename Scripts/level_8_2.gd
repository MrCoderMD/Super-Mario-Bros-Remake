extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(66,5),Vector2i(166,5)]
const lifeupcoords=[]
const coinbrickcoords=[Vector2i(190,9)]
const starcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID:=19
const BRICK_BLOCK_ID:=20
const USED_BLOCK_ID:=22
const INVISIBLE_BLOCK_ID:=9
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
const castle_x:=222*32+16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	await get_tree().process_frame
	var hop_koopa=[30,93]
	for enemy in $Enemies.get_children():
		var cell_pos=$Enemies.local_to_map($Enemies.to_local(enemy.global_position)).x
		if cell_pos in hop_koopa:
			enemy.direction=-1
			enemy.state=enemy.States.HOP
	if !Global.can_transition:
		mario.z_index=$ForegroundTile.z_index-1
		mario.global_position=self.to_global($ForegroundTile.map_to_local(Global.spawn[Global.currentlevel]))+Vector2(-16,mario.collision.shape.extents.y-16)
		await mario.slide_up()
		mario.z_index=$ForegroundTile.z_index+1
	else:
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
	Global.check_time("8-3")


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.
