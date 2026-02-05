extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(60,6)]
const coinbrickcoords=[Vector2i(77,9)]
const starcoords=[Vector2i(77,5)]
const lifeupcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID=14
const BRICK_BLOCK_ID=15
const USED_BLOCK_ID=26
const INVISIBLE_BLOCK_ID=23
var BRICK_TEXTURE=load("res://files/images/brickred.bmp")
var DEBRIS_TEXTURE=load("res://files/images/block_debris0.png")
const palette="overworld"
var transition_coordx=0
var castle_x:=6896

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Global.time=399
	await get_tree().process_frame
	var hop_koopa=[Vector2i(92,10)]
	for enemy in $Enemies.get_children():
		var cell_pos=$Enemies.local_to_map($Enemies.to_local(enemy.global_position))
		if cell_pos in hop_koopa:
			enemy.direction=-1
			enemy.state=enemy.States.HOP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_level_timer_timeout() -> void:
	Global.check_time("3-3") # Replace with function body.


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.
