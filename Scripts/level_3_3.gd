extends Level

@onready var mario=$Mario

const powerupcoords=[Vector2i(49,3)]
const coinbrickcoords=[]
const starcoords=[]
const lifeupcoords=[]
const invisible_blocks=[]
const QUESTION_BLOCK_ID=1
const BRICK_BLOCK_ID=0
const USED_BLOCK_ID=4
const INVISIBLE_BLOCK_ID=5
const palette="overworld"
var transition_coordx=0
var castle_x:=5008

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	if Global.checkpoint:
		mario.global_position=Vector2(2496,96)
	Global.time=399
	
	await get_tree().process_frame
	var fly_koopa=[Vector2i(114,5)]
	for enemy in $Enemies.get_children():
		var cell_pos=$Enemies.local_to_map($Enemies.to_local(enemy.global_position))
		if cell_pos in fly_koopa:
			enemy.direction=-1
			enemy.state=enemy.States.FLY
		if cell_pos!=Vector2i(26,6):
			enemy.palette="red"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("select"):
		Global.pause_game(self)
	if mario:
		if $CameraFollower.position.x<=$Mario.global_position.x:
			$CameraFollower.position.x=$Mario.global_position.x


func _on_level_timer_timeout() -> void:
	Global.check_time("3-4") # Replace with function body.


func _on_bg_music_finished() -> void:
	$CameraFollower/BgMusic.play() # Replace with function body.


func _on_checkpoint_body_entered(body: Node2D) -> void:
	if body==mario:
		Global.checkpoint=true # Replace with function body.
